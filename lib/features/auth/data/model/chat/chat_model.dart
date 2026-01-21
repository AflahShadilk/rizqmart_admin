import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/chat/chat_entity.dart';

class ChatModel extends ChatEntity {
  const ChatModel({
    required super.userId,
    required super.userName,
    required super.userProfile,
    required super.lastMessage,
    required super.lastMessageTime,
    required super.unreadCount,
  });

  factory ChatModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatModel(
      userId: doc.id,
      userName: data['userName'] ?? data['name'] ?? data['fullName'] ?? data['email'] ?? 'Unknown User',
      userProfile: data['userProfile'] ?? data['image'] ?? data['profileImage'] ?? '',
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime: (data['lastMessageTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      unreadCount: (data['unreadCount'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userName': userName,
      'userProfile': userProfile,
      'lastMessage': lastMessage,
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
      'unreadCount': unreadCount,
    };

  }

  ChatModel copyWith({
    String? userId,
    String? userName,
    String? userProfile,
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
  }) {
    return ChatModel(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userProfile: userProfile ?? this.userProfile,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
