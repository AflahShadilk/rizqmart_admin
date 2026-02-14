import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final String id; 
  final String productName;
  final String productId;
  final String userId;
  final String adminId;
  final String lastMessage;
  final DateTime timestamp;

  const ChatEntity({
    required this.id,
    required this.productName,
    required this.productId,  
    required this.userId,
    required this.adminId,
    required this.lastMessage,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
        id,
        productName,
        productId,
        userId,
        adminId,
        lastMessage,
        timestamp,
      ];
}
