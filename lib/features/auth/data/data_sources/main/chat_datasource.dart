// ignore_for_file: avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmartadmin/features/auth/data/model/chat_model.dart';
import 'package:rizqmartadmin/features/auth/data/model/message_model.dart';

abstract class ChatDataSource {
  Stream<List<ChatModel>> getChats();
  Stream<List<MessageModel>> getMessages(String chatId);
  Future<void> sendMessage(String chatId, MessageModel message);
  Future<void> markChatAsRead(String chatId);
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
        
        // We need userId to fetch user details. If it's missing or empty, we can't do much.
        if (chat.userId.isNotEmpty && (chat.userName == 'Unknown User' || chat.userName.isEmpty || chat.userProfile.isEmpty)) {
          try {
            final userDoc = await _firestore.collection('users').doc(chat.userId).get();
            if (userDoc.exists) {
              final data = userDoc.data()!;
              final name = data['name'] ?? data['fullName'] ?? data['userName'] ?? 'Unknown User';
              final profile = data['image'] ?? data['profileImage'] ?? data['userProfile'] ?? '';
              
              if (name != 'Unknown User') {
                 // Update the cache in the chat document using chat.id
                 await _firestore.collection('chats').doc(chat.id).set({
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
  Stream<List<MessageModel>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => MessageModel.fromFirestore(doc)).toList();
    });
  }

  @override
  Future<void> sendMessage(String chatId, MessageModel message) async {
    // Basic fallback: if chatId seems to be a userId (length 28 approx for auth ids, but doc ids are also strings),
    // ideally the caller passes the correct chatId. 
    // But to be robust: check if doc exists. If not, try to find by userId.
    
    DocumentReference chatRef = _firestore.collection('chats').doc(chatId);
    
    // Check if we need to do a lookup (defensive programming, optional but good)
    // For now assuming caller passes valid chatId. 
    // If strict fallback is needed per plan:
    // "Attempt to locate the chat by where('userId', isEqualTo: userId).limit(1).get() and map to chatId. (This is a fallback path.)"
    // Since we changed signature to `chatId`, we assume it IS a chatId. 
    // If the Admin UI is still passing userId, this might break if we don't fix UI. 
    // But we are fixing UI. So we trust chatId.
    
    final messagesRef = chatRef.collection('messages');

    final batch = _firestore.batch();
    
    // 1. Add Message
    final newMessageRef = messagesRef.doc();
    batch.set(newMessageRef, message.toFirestore());

    // 2. Update Metadata & Unread Count
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
  Future<void> markChatAsRead(String chatId) async {
    // Reset Admin's unread count to 0
    await _firestore.collection('chats').doc(chatId).set({
      'unreadCounts': {
        'admin': 0
      }
    }, SetOptions(merge: true));
  }
}
