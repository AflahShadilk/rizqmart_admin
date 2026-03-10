import 'package:flutter/material.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';

class ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).cardTheme.color,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(
                fontFamily: 'Inter',
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  color: AppColors.grey.shade400,
                ),
                filled: true,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor ?? Theme.of(context).scaffoldBackgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onSubmitted: (_) => onSend(),
            ),
          ),
          8.w,
          CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            radius: 24,
            child: IconButton(
              icon: Icon(
                Icons.send_rounded,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 20,
              ),
              onPressed: onSend,
            ),
          ),
        ],
      ),
    );
  }
}
