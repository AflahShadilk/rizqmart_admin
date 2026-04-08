import 'package:rizqmartadmin/features/domain/entities/main/chat_entity.dart';

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
    Object? lastAddedNotification = _undefined,
    Object? lastAddedChat = _undefined,
  }) {
    return NotificationBellState(
      notifications: notifications ?? this.notifications,
      unreadChats: unreadChats ?? this.unreadChats,
      notificationCount: notificationCount ?? this.notificationCount,
      lastAddedNotification: lastAddedNotification == _undefined
          ? this.lastAddedNotification
          : lastAddedNotification as Map<String, dynamic>?,
      lastAddedChat: lastAddedChat == _undefined
          ? this.lastAddedChat
          : lastAddedChat as ChatEntity?,
    );
  }

  static const _undefined = Object();
}
