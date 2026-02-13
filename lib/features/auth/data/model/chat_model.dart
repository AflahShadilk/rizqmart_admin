import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/chat_entity.dart';

class ChatModel extends ChatEntity {
  const ChatModel({
    required super.id,
    required super.userId,
    required super.userName,
    required super.userProfile,
    required super.lastMessage,
    required super.lastMessageTime,
    required super.unreadCounts,
    required super.userData,
  });

  factory ChatModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatModel(
      id: doc.id,
      userId: data['userId'] ?? '', // Fallback to empty if missing, but should be there
      userName: data['userName'] ?? data['name'] ?? data['fullName'] ?? data['email'] ?? 'Unknown User',
      userProfile: data['userProfile'] ?? data['image'] ?? data['profileImage'] ?? '',
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime: (data['lastMessageTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      unreadCounts: data['unreadCounts'] != null 
          ? Map<String, dynamic>.from(data['unreadCounts']) 
          : {'admin': data['unreadCount'] ?? 0, 'user': 0},
      userData: data['userData'] != null 
          ? Map<String, dynamic>.from(data['userData']) 
          : {},
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'userProfile': userProfile,
      'lastMessage': lastMessage,
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
      'unreadCounts': unreadCounts,
      'userData': userData,
    };
  }

  ChatModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userProfile,
    String? lastMessage,
    DateTime? lastMessageTime,
    Map<String, dynamic>? unreadCounts,
    Map<String, dynamic>? userData,
  }) {
    return ChatModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userProfile: userProfile ?? this.userProfile,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCounts: unreadCounts ?? this.unreadCounts,
      userData: userData ?? this.userData,
    );
  }
}
