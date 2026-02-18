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
        .collection('chatRooms')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ChatModel.fromFirestore(doc)).toList();
    });
  }

  @override
  Stream<List<MessageModel>> getMessages(String chatId) {
    if (chatId.isEmpty) return Stream.value([]);
    return _firestore
        .collection('chatRooms')
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
    if (chatId.isEmpty) return;
    DocumentReference chatRef = _firestore.collection('chatRooms').doc(chatId);
    final messagesRef = chatRef.collection('messages');
    final batch = _firestore.batch();

    // 1. Add Message
    final newMessageRef = messagesRef.doc();
    batch.set(newMessageRef, message.toFirestore());

    // 2. Update chat room metadata
    batch.set(chatRef, {
      'lastMessage': message.type == 'image' ? 'Image' : message.text,
      'lastMessageSenderRole': message.senderRole,
      'timestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await batch.commit();
  }

  @override
  Future<void> markChatAsRead(String chatId) async {
    if (chatId.isEmpty) return;
    // Simple flag — can be extended later with per-role unread counts
    await _firestore.collection('chatRooms').doc(chatId).set({
      'adminUnread': 0,
    }, SetOptions(merge: true));
  }
}
