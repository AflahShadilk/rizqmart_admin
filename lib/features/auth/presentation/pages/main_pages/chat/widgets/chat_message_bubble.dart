import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/message_entity.dart';

class ChatMessageBubble extends StatelessWidget {
  final MessageEntity message;

  const ChatMessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = message.senderRole == 'admin';

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isMe ? Theme.of(context).primaryColor : Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isMe ? const Radius.circular(12) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(12),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Sender role label
            Text(
              isMe ? 'Admin' : 'User',
              style: TextStyle(
                fontFamily: 'Inter',
                color: isMe ? AppColors.white.withValues(alpha: 0.7) : AppColors.grey.shade500,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
            2.h,
            Text(
              message.text,
              style: TextStyle(
                fontFamily: 'Inter',
                color: isMe ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 14,
              ),
            ),
            4.h,
            Text(
              DateFormat('dd MMM, h:mm a').format(message.timestamp),
              style: TextStyle(
                fontFamily: 'Inter',
                color: isMe ? AppColors.white.withValues(alpha: 0.7) : AppColors.grey.shade500,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
