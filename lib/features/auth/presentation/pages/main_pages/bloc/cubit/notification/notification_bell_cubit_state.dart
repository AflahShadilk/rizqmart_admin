import 'package:rizqmartadmin/features/auth/domain/entities/main/chat_entity.dart';

class NotificationBellState {
  final List<Map<String, dynamic>> notifications;
  final List<ChatEntity> unreadChats;
  final int notificationCount;
  final Map<String, dynamic>? lastAddedNotification;
  final ChatEntity? lastAddedChat;

  const NotificationBellState({
    this.notifications = const [],
    this.unreadChats = const [],
    this.notificationCount = 0,
    this.lastAddedNotification,
    this.lastAddedChat,
  });

  NotificationBellState copyWith({
    List<Map<String, dynamic>>? notifications,
    List<ChatEntity>? unreadChats,
    int? notificationCount,
    Map<String, dynamic>? lastAddedNotification,
    ChatEntity? lastAddedChat,
  }) {
    return NotificationBellState(
      notifications: notifications ?? this.notifications,
      unreadChats: unreadChats ?? this.unreadChats,
      notificationCount: notificationCount ?? this.notificationCount,
      lastAddedNotification: lastAddedNotification ?? this.lastAddedNotification,
      lastAddedChat: lastAddedChat ?? this.lastAddedChat,
    );
  }
}
