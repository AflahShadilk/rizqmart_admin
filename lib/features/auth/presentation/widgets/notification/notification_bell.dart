

import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/notification/notification_bell_cubit.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/notification/notification_bell_cubit_state.dart';
import 'package:badges/badges.dart' as badges;
import 'package:go_router/go_router.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';

class NotificationBell extends StatelessWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context) {
    return const _NotificationBellView();
  }
}

class _NotificationBellView extends StatelessWidget {
  const _NotificationBellView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationBellCubit, NotificationBellState>(
      listenWhen: (previous, current) =>
          previous.lastAddedNotification != current.lastAddedNotification ||
          previous.lastAddedChat != current.lastAddedChat,
      listener: (context, state) {
        if (state.lastAddedChat != null) {
          _showChatSnackbar(context, state.lastAddedChat!);
          context.read<NotificationBellCubit>().resetLastAdded();
        }
        if (state.lastAddedNotification != null) {
          _showNotificationSnackbar(context, state.lastAddedNotification!);
          context.read<NotificationBellCubit>().resetLastAdded();
        }
      },
      child: BlocBuilder<NotificationBellCubit, NotificationBellState>(
        builder: (context, state) {
          return PopupMenuButton(
            offset: const Offset(0, 50),
            itemBuilder: (BuildContext context) {
              if (state.notifications.isEmpty && state.unreadChats.isEmpty) {
                return [
                  PopupMenuItem(
                    enabled: false,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'No notifications',
                        style: TextStyle(color: AppColors.grey[600]),
                      ),
                    ),
                  ),
                ];
              }

              return [
                // Chat Notifications
                ...state.unreadChats.take(5).map((chat) {
                  return PopupMenuItem(
                    onTap: () {
                      context.push('/chat_details', extra: {
                        'chatId': chat.id,
                        'productName': chat.productName,
                        'userId': chat.userId,
                      });
                    },
                    child: Container(
                      width: 300,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: AppColors.grey[300]!),
                          left: const BorderSide(color: AppColors.blue, width: 4),
                        ),
                        color: AppColors.blue.withValues(alpha: 0.05),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  chat.productName.isNotEmpty
                                      ? chat.productName
                                      : 'Order ${chat.id}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: AppColors.blue,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          4.h,
                          Text(
                            chat.lastMessage,
                            style: TextStyle(
                              color: AppColors.grey[700],
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          4.h,
                          Text(
                            'User: ${chat.userId}',
                            style: TextStyle(color: AppColors.grey[500], fontSize: 11),
                          ),
                          Text(
                            _formatTime(chat.timestamp),
                            style: TextStyle(
                              color: AppColors.grey[400],
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                // Original Notifications
                ...state.notifications.map((notif) {
                  return PopupMenuItem(
                    enabled: false,
                    child: Container(
                      width: 300,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: AppColors.grey[300]!),
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
                          4.h,
                          Text(
                            notif['body'],
                            style: TextStyle(
                              color: AppColors.grey[700],
                              fontSize: 12,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          4.h,
                          Text(
                            _formatTime(notif['timestamp']),
                            style: TextStyle(
                              color: AppColors.grey[500],
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                if (state.notifications.isNotEmpty || state.unreadChats.isNotEmpty)
                  PopupMenuItem(
                    child: Column(
                      children: [
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () => context.push('/notifications'),
                              child: const Text('View All'),
                            ),
                            TextButton(
                              onPressed: () => context
                                  .read<NotificationBellCubit>()
                                  .clearNotifications(),
                              child: const Text('Clear All'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ];
            },
            child: badges.Badge(
              badgeContent: Text(
                state.notificationCount.toString(),
                style: const TextStyle(color: AppColors.white, fontSize: 12),
              ),
              showBadge: state.notificationCount > 0,
              child: const Icon(Icons.notifications, color: AppColors.white),
            ),
          );
        },
      ),
    );
  }

  void _showChatSnackbar(BuildContext context, dynamic chat) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 150,
            left: 16,
            right: 16),
        content: Row(
          children: [
            const Icon(Icons.chat, color: AppColors.white),
            12.w,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      'New Message for ${chat.productName.isNotEmpty ? chat.productName : chat.id}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(chat.lastMessage,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'View',
          textColor: AppColors.yellow,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            context.push('/chat_details', extra: {
              'chatId': chat.id,
              'productName': chat.productName,
              'userId': chat.userId,
            });
          },
        ),
        backgroundColor: AppColors.blue600,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showNotificationSnackbar(BuildContext context, Map<String, dynamic> notif) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 150,
            left: 16,
            right: 16),
        content: Row(
          children: [
            Icon(
                notif['title'].toString().toLowerCase().contains('order') == true
                    ? Icons.shopping_cart
                    : Icons.notifications_active,
                color: AppColors.white),
            12.w,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(notif['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(notif['body'],
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.green,
        duration: const Duration(seconds: 2),
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
}