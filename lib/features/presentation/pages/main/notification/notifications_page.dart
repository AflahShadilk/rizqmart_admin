import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/core/theme/appcolor.dart';
import 'package:rizqmartadmin/features/presentation/cubit/notification/notification_bell_cubit.dart';
import 'package:rizqmartadmin/features/presentation/cubit/notification/notification_bell_cubit_state.dart';
import 'package:rizqmartadmin/features/presentation/pages/main/notification/widgets/chat_notification_tile.dart';
import 'package:rizqmartadmin/features/presentation/pages/main/notification/widgets/general_notification_tile.dart';
import 'package:rizqmartadmin/features/presentation/pages/main/notification/widgets/notification_header.dart';
import 'package:rizqmartadmin/features/presentation/pages/main/notification/widgets/notification_section_header.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      // ---------------- Notifications Body ----------------
      body: BlocBuilder<NotificationBellCubit, NotificationBellState>(
        builder: (context, state) {
          final totalCount = state.notifications.length + state.unreadChats.length;

          return Column(
            children: [
              // ---------------- Notifications Header ----------------
              NotificationHeader(
                totalCount: totalCount,
                messageCount: state.unreadChats.length,
                updateCount: state.notifications.length,
                onClearAll: () {
                  context.read<NotificationBellCubit>().clearNotifications();
                },
              ),

              // ---------------- Notifications Content ----------------
              Expanded(
                child: totalCount == 0
                    ? _EmptyNotificationsView(colorScheme: colorScheme)
                    : _NotificationListView(state: state),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ---------------- Empty State Widget ----------------
class _EmptyNotificationsView extends StatelessWidget {
  final ColorScheme colorScheme;

  const _EmptyNotificationsView({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.06),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none_outlined,
              size: 64,
              color: colorScheme.primary.withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'All caught up!',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No new notifications at the moment',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: AppColors.grey500,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- Notification List Widget ----------------
class _NotificationListView extends StatelessWidget {
  final NotificationBellState state;

  const _NotificationListView({required this.state});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          children: [
            // ---------------- Messages Section ----------------
            if (state.unreadChats.isNotEmpty) ...[
              const NotificationSectionHeader(
                title: 'Messages',
                icon: Icons.chat_outlined,
              ),
              ...state.unreadChats.map(
                (chat) => ChatNotificationTile(chat: chat),
              ),
              const SizedBox(height: 20),
            ],
            // ---------------- Updates Section ----------------
            if (state.notifications.isNotEmpty) ...[
              NotificationSectionHeader(
                title: 'Updates',
                icon: Icons.notifications_outlined,
                color: AppColors.matGreen,
              ),
              ...state.notifications.map(
                (notif) => GeneralNotificationTile(notification: notif),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
