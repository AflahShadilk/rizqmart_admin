// ignore_for_file: avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmartadmin/features/auth/data/model/chat/chat_model.dart';
import 'package:rizqmartadmin/features/auth/data/model/chat/message_model.dart';

abstract class ChatDataSource {
  Stream<List<ChatModel>> getChats();
  Stream<List<MessageModel>> getMessages(String userId);
  Future<void> sendMessage(String userId, MessageModel message);
  Future<void> markChatAsRead(String userId);
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
                 // Update the cache in the chat document
                 await _firestore.collection('chats').doc(chat.userId).set({
                   'userName': name,
                   'userProfile': profile,
                   'userData': data, // Cache full data
                 }, SetOptions(merge: true));
              }

              return chat.copyWith(
                userName: name,
                userProfile: profile,
                userData: data,
              );
            }
          } catch (e) {
            print("Error fetching user details for ${chat.userId}: $e");
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

    final batch = _firestore.batch();
    
    // 1. Add Message
    final newMessageRef = messagesRef.doc();
    batch.set(newMessageRef, message.toFirestore());

    // 2. Update Metadata & Unread Count
    // Since ADMIM is sending, increment USER's unread count
    batch.set(chatRef, {
      'lastMessage': message.type == 'image' ? 'Image' : message.text,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'unreadCounts': {
        'user': FieldValue.increment(1),
        // 'admin': FieldValue.increment(0) // No change to admin count
      }
    }, SetOptions(merge: true));

    await batch.commit();
  }

  @override
  Future<void> markChatAsRead(String userId) async {
    // Reset Admin's unread count to 0
    await _firestore.collection('chats').doc(userId).set({
      'unreadCounts': {
        'admin': 0
      }
    }, SetOptions(merge: true));
  }
}
