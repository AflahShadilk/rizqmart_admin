import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/chat/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    super.id,
    required super.senderId,
    required super.text,
    required super.type,
    required super.timestamp,
    super.orderId,
  });

  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MessageModel(
      id: doc.id,
      senderId: data['senderId'] ?? '',
      text: data['text'] ?? '',
      type: data['type'] ?? 'text',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      orderId: data['orderId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'text': text,
      'type': type,
      'timestamp': Timestamp.fromDate(timestamp),
      if (orderId != null) 'orderId': orderId,
    };
  }
}
