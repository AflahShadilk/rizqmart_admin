// ignore_for_file: deprecated_member_use, unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rizqmartadmin/core/services/web_messaging_service.dart';
import 'package:badges/badges.dart' as badges;
import 'package:rizqmartadmin/features/auth/data/repository/main/chat_repository_impl.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/chat/chat_entity.dart';
import 'package:rizqmartadmin/core/services/repository_providers_page.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

class NotificationBell extends StatefulWidget {
  const NotificationBell({super.key});

  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell> {
  int notificationCount = 0;
  List<Map<String, dynamic>> notifications = [];
  List<ChatEntity> unreadChats = [];
  StreamSubscription? _chatSubscription; // Add subscription
  String? fcmToken;

  @override
  void initState() {
    super.initState();
    _setupNotifications();
  }

  void _setupNotifications() async {
    // Get FCM token
    fcmToken = await WebMessagingService.getToken();
    
    // Subscribe to topics
    await WebMessagingService.subscribeToTopic('admin_alerts');
    await WebMessagingService.subscribeToTopic('order_updates');

    // Set callback for foreground messages
    WebMessagingService.onMessageCallback = (RemoteMessage message) {
      _addNotification(message);
    };

    // Set callback for when notification is clicked
    WebMessagingService.onMessageOpenedAppCallback = (RemoteMessage message) {
      _handleNotificationClick(message);
    };

    _setupChatListener();
  }

  void _setupChatListener() {
    try {
      final chatRepo = sl<ChatRepositoryImpl>(); // Access repo
      _chatSubscription = chatRepo.getChats().listen((chats) {
        if (mounted) {
          setState(() {
            unreadChats = chats.where((c) => c.unreadCount > 0).toList();
            _updateTotalCount();
          });
        }
      });
    } catch (e) {
    }
  }

  void _updateTotalCount() {
    int chatUnreadCount = unreadChats.fold(0, (sum, chat) => sum + chat.unreadCount);
    notificationCount = notifications.length + chatUnreadCount; 
  }

  void _addNotification(RemoteMessage message) {
    setState(() {
      notifications.insert(0, {
        'title': message.notification?.title ?? 'Notification',
        'body': message.notification?.body ?? '',
        'timestamp': DateTime.now(),
        'data': message.data,
      });

      _updateTotalCount();

      // Keep only last 10 notifications
      if (notifications.length > 10) {
        notifications.removeLast();
      }
    });


  }

  void _handleNotificationClick(RemoteMessage message) {
    
    // Handle based on notification type
    String? type = message.data['type'];
    String? id = message.data['id'];
    
    switch (type) {
      case 'order':
        // context.push('/order/$id');
        break;
      case 'payment':
        // context.push('/payment/$id');
        break;
      case 'alert':
        // Show alert dialog
        break;
      default:
    }
  }

  void _clearNotifications() {
    setState(() {
      notifications.clear();
      notifications.clear();
      // We don't clear chat notifications here as they are cleared when read
      _updateTotalCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      offset: const Offset(0, 50),
      itemBuilder: (BuildContext context) {
        if (notifications.isEmpty && unreadChats.isEmpty) {
          return [
            PopupMenuItem(
              enabled: false,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'No notifications',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
          ];
        }

        return [
          // Chat Notifications
          ...unreadChats.map((chat) {
            return PopupMenuItem(
              onTap: () {
                 context.push('/chat_details', extra: {
                  'userId': chat.userId,
                  'userName': chat.userName,
                });
              },
              child: Container(
                width: 300,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[300]!),
                    left: const BorderSide(color: Colors.blue, width: 4), // Highlight chat
                  ),
                  color: Colors.blue.withOpacity(0.05),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Message from ${chat.userName}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                         Container(
                           padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                           decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(10)),
                           child: Text('${chat.unreadCount}', style: const TextStyle(color: Colors.white, fontSize: 10))
                         )
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      chat.lastMessage,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTime(chat.lastMessageTime),
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          
          // Original Notifications
          ...notifications.map((notif) {
            return PopupMenuItem(
              enabled: false,
              child: Container(
                width: 300,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notif['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notif['body'],
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTime(notif['timestamp']),
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          if (notifications.isNotEmpty)
            PopupMenuItem(
              child: Center(
                child: TextButton(
                  onPressed: _clearNotifications,
                  child: const Text('Clear All'),
                ),
              ),
            ),
        ];
      },
      child: badges.Badge(
        badgeContent: Text(
          notificationCount.toString(),
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        showBadge: notificationCount > 0,
        child: const Icon(Icons.notifications, color: Colors.white),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
  @override
  void dispose() {
    _chatSubscription?.cancel();
    super.dispose();
  }
}