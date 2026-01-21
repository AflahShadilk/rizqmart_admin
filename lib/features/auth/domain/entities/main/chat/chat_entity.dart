import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final String userId;
  final String userName;
  final String userProfile;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  const ChatEntity({
    required this.userId,
    required this.userName,
    required this.userProfile,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [
        userId,
        userName,
        userProfile,
        lastMessage,
        lastMessageTime,
        unreadCount,
      ];
}
