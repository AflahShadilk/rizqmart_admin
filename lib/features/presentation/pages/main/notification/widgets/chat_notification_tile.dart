import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rizqmartadmin/core/theme/appcolor.dart';

/// A modern card for unread chat notification items with hover effect and chevron.
class ChatNotificationTile extends StatelessWidget {
  final dynamic chat;

  const ChatNotificationTile({
    super.key,
    required this.chat,
  });

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: theme.cardTheme.color ?? AppColors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: () {
            context.push('/chat_details', extra: {
              'chatId': chat.id,
              'productName': chat.productName,
              'userId': chat.userId,
            });
          },
          borderRadius: BorderRadius.circular(14),
          hoverColor: colorScheme.primary.withValues(alpha: 0.04),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.08),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // ---------------- Chat Avatar ----------------
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.matBlue.withValues(alpha: 0.15),
                        AppColors.matBlue.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_outline, color: AppColors.matBlue, size: 22),
                ),
                const SizedBox(width: 14),
                // ---------------- Chat Content ----------------
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chat.productName.isNotEmpty ? chat.productName : 'Order ${chat.id}',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: theme.textTheme.bodyLarge?.color,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Unread indicator
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.matBlue,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        chat.lastMessage,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: AppColors.grey600,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _formatTime(chat.timestamp),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: AppColors.grey400,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right, color: AppColors.grey400, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
