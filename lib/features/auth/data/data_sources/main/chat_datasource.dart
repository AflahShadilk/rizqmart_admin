import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmartadmin/features/auth/data/model/chat/chat_model.dart';
import 'package:rizqmartadmin/features/auth/data/model/chat/message_model.dart';

abstract class ChatDataSource {
  Stream<List<ChatModel>> getChats();
  Stream<List<MessageModel>> getMessages(String userId);
  Future<void> sendMessage(String userId, MessageModel message);
}

class ChatDataSourceImpl implements ChatDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<ChatModel>> getChats() {
    return _firestore
        .collection('chats')
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      final chats = snapshot.docs.map((doc) => ChatModel.fromFirestore(doc)).toList();
      
      // Enhance chats with user details if missing
      return await Future.wait(chats.map((chat) async {
        
        if (chat.userName == 'Unknown User' || chat.userName.isEmpty || chat.userProfile.isEmpty) {
          try {
            final userDoc = await _firestore.collection('users').doc(chat.userId).get();
            if (userDoc.exists) {
              final data = userDoc.data()!;
              final name = data['name'] ?? data['fullName'] ?? data['userName'] ?? 'Unknown User';
              final profile = data['image'] ?? data['profileImage'] ?? data['userProfile'] ?? '';
              
              if (name != 'Unknown User') {
                 await _firestore.collection('chats').doc(chat.userId).update({
                   'userName': name,
                   'userProfile': profile,
                 });
              }

              return chat.copyWith(
                userName: name,
                userProfile: profile,
              );
            }
          } catch (e) {
          }
        }
        return chat;
      }));
    });
  }

  @override
  Stream<List<MessageModel>> getMessages(String userId) {
    return _firestore
        .collection('chats')
        .doc(userId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => MessageModel.fromFirestore(doc)).toList();
    });
  }

  @override
  Future<void> sendMessage(String userId, MessageModel message) async {
    final chatRef = _firestore.collection('chats').doc(userId);
    final messagesRef = chatRef.collection('messages');

    // Add message
    await messagesRef.add(message.toFirestore());

    // Update last message in chat summary
    await chatRef.update({
      'lastMessage': message.type == 'image' ? 'Image' : message.text,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'unreadCount': 0, // Admin replied, so unread count reset (or handle differently based on req)
    });
  }
}
