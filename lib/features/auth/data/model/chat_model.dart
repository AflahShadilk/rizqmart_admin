import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/chat_entity.dart';

class ChatModel extends ChatEntity {
  const ChatModel({
    required super.id,
    required super.productName,
    required super.productId,
    required super.userId,
    required super.adminId,
    required super.lastMessage,
    required super.timestamp,
  });

  factory ChatModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatModel(
      id: doc.id, // orderId
      productName: data['productName'] ?? '',
      productId: data['productId'] ?? '',
      userId: data['userId'] ?? '',
      adminId: data['adminId'] ?? 'admin',
      lastMessage: data['lastMessage'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'productName': productName,
      'productId': productId,
      'userId': userId,
      'adminId': adminId,
      'lastMessage': lastMessage,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  ChatModel copyWith({
    String? id,
    String? productName,
    String? productId,
    String? userId,
    String? adminId,
    String? lastMessage,
    DateTime? timestamp,
  }) {
    return ChatModel(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      productId: productId ?? this.productId,
      userId: userId ?? this.userId,
      adminId: adminId ?? this.adminId,
      lastMessage: lastMessage ?? this.lastMessage,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
