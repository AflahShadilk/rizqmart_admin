import 'package:flutter/material.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';

/// A modern card for general (order/system) notification items.
class GeneralNotificationTile extends StatelessWidget {
  final Map<String, dynamic> notification;

  const GeneralNotificationTile({
    super.key,
    required this.notification,
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
    final bool isOrder = notification['title'].toString().toLowerCase().contains('order');
    final Color accentColor = isOrder ? AppColors.matGreen : AppColors.amber;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: theme.cardTheme.color ?? AppColors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: () {}, // reserved for future detail view
          borderRadius: BorderRadius.circular(14),
          hoverColor: accentColor.withValues(alpha: 0.04),
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
                // ---------------- Notification Icon ----------------
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accentColor.withValues(alpha: 0.15),
                        accentColor.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isOrder ? Icons.shopping_cart_outlined : Icons.info_outline,
                    color: accentColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                // ---------------- Notification Content ----------------
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification['title'],
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification['body'],
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: AppColors.grey600,
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _formatTime(notification['timestamp']),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
