import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String userProfile;
  final String lastMessage;
  final DateTime lastMessageTime;
  final Map<String, dynamic> unreadCounts;
  final Map<String, dynamic> userData;

  const ChatEntity({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userProfile,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCounts,
    required this.userData,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        userName,
        userProfile,
        lastMessage,
        lastMessageTime,
        unreadCounts,
        userData,
      ];
}
