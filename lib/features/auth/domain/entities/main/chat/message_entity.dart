import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String senderId;
  final String text;
  final String type; // 'text', 'image'
  final DateTime timestamp;
  final String? orderId; // Added orderId

  const MessageEntity({
    this.id = '',
    required this.senderId,
    required this.text,
    required this.type,
    required this.timestamp,
    this.orderId,
  });

  @override
  List<Object?> get props => [id, senderId, text, type, timestamp, orderId];
}
