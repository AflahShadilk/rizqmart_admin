import 'package:flutter/material.dart';

/// A modern section header with an icon and label, separated with a line divider.
class NotificationSectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? color;

  const NotificationSectionHeader({
    super.key,
    required this.title,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = color ?? Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14, top: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: accentColor),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: accentColor,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Divider(
              color: accentColor.withValues(alpha: 0.15),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
