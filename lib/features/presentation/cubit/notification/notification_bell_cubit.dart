import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/di/repository_providers_page.dart';
import 'package:rizqmartadmin/features/data/data_sources/services/web_messaging_service.dart';
import 'package:rizqmartadmin/features/data/repository/chat_repository_impl.dart';
import 'package:rizqmartadmin/features/domain/entities/main/chat_entity.dart';
import 'package:rizqmartadmin/features/presentation/cubit/notification/notification_bell_cubit_state.dart';

class NotificationBellCubit extends Cubit<NotificationBellState> {
  StreamSubscription? _chatSubscription;

  NotificationBellCubit() : super(const NotificationBellState()) {
    _init();
  }

  void _init() async {
    // Subscribe to topics
    await WebMessagingService.subscribeToTopic('admin_alerts');
    await WebMessagingService.subscribeToTopic('order_updates');

    // Set callback for foreground messages
    WebMessagingService.onMessageCallback = (RemoteMessage message) {
      addNotification({
        'title': message.notification?.title ?? 'Notification',
        'body': message.notification?.body ?? '',
        'timestamp': DateTime.now(),
        'data': message.data,
      });
    };

    _setupChatListener();
  }

  void _setupChatListener() {
    try {
      final chatRepo = sl<ChatRepositoryImpl>();
      _chatSubscription = chatRepo.getChats().listen((chats) {
        updateUnreadChats(chats);
      });
    } catch (e) {
      // Ignore errors in chat listener
    }
  }

  void addNotification(Map<String, dynamic> notification) {
    final updated = [notification, ...state.notifications];
    // Keep only last 10
    final trimmed = updated.length > 10 ? updated.sublist(0, 10) : updated;
    emit(state.copyWith(
      notifications: trimmed,
      notificationCount: trimmed.length + state.unreadChats.length,
      lastAddedNotification: notification,
    ));
  }

  void updateUnreadChats(List<ChatEntity> chats) {
    ChatEntity? lastChat;
    // Only trigger notification if the last message was NOT from an admin
    if (chats.isNotEmpty && 
        chats.first.lastMessageSenderRole != 'admin' &&
        (state.unreadChats.isEmpty || 
         (chats.first.timestamp.isAfter(state.unreadChats.first.timestamp) &&
          chats.first.lastMessage != state.unreadChats.first.lastMessage))) {
      lastChat = chats.first;
    }

    emit(state.copyWith(
      unreadChats: chats,
      notificationCount: state.notifications.length + chats.length,
      lastAddedChat: lastChat,
    ));
  }

  void resetLastAdded() {
    emit(state.copyWith(
      lastAddedNotification: null,
      lastAddedChat: null,
    ));
  }

  void clearNotifications() {
    emit(state.copyWith(
      notifications: [],
      unreadChats: [],
      notificationCount: 0,
      lastAddedNotification: null,
      lastAddedChat: null,
    ));
  }

  @override
  Future<void> close() {
    _chatSubscription?.cancel();
    WebMessagingService.onMessageCallback = null;
    return super.close();
  }
}
