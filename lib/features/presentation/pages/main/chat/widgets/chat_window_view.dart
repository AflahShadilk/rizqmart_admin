import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rizqmartadmin/core/theme/appcolor.dart';
import 'package:rizqmartadmin/features/domain/entities/main/chat_entity.dart';
import 'package:rizqmartadmin/features/domain/entities/main/message_entity.dart';
import 'package:rizqmartadmin/features/presentation/pages/main/chat/widgets/chat_input_field.dart';
import 'package:rizqmartadmin/features/presentation/pages/main/chat/widgets/chat_message_bubble.dart';
import 'package:rizqmartadmin/features/presentation/pages/main/chat/widgets/user_name_resolver.dart';

class ChatWindowView extends StatefulWidget {
  final ChatEntity? chat;
  final List<MessageEntity>? messages;
  final bool isLoading;
  final Function(String text) onSendMessage;
  final String? userName; // Optional user name resolved from elsewhere

  const ChatWindowView({
    super.key,
    this.chat,
    this.messages,
    required this.isLoading,
    required this.onSendMessage,
    this.userName,
  });

  @override
  State<ChatWindowView> createState() => _ChatWindowViewState();
}

class _ChatWindowViewState extends State<ChatWindowView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSend() {
    if (_messageController.text.trim().isNotEmpty) {
      widget.onSendMessage(_messageController.text.trim());
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.chat == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_outlined, size: 64, color: AppColors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'Select a conversation to start chatting',
              style: TextStyle(color: AppColors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // ---------------- Chat Header (WhatsApp style) ----------------
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            border: Border(
              bottom: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                child: Icon(Icons.person, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserNameResolver(
                      userId: widget.chat!.userId,
                      orderId: widget.chat!.id,
                      builder: (context, name) => Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Text(
                      'Order #${widget.chat!.id.substring(0, 8).toUpperCase()}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ---------------- Message List ----------------
        Expanded(
          child: widget.isLoading && (widget.messages == null || widget.messages!.isEmpty)
              ? const Center(child: CircularProgressIndicator())
              : (widget.messages == null || widget.messages!.isEmpty)
                  ? Center(
                      child: Text(
                        'Start a conversation',
                        style: TextStyle(color: AppColors.grey.shade500),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      padding: const EdgeInsets.all(16),
                      itemCount: widget.messages!.length,
                      itemBuilder: (context, index) {
                        final message = widget.messages![index];
                        final isFirstOfDate = _isFirstMessageOfDay(index, widget.messages!);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (isFirstOfDate) _buildDateHeader(message.timestamp, theme),
                            ChatMessageBubble(
                              message: message,
                            ),
                          ],
                        );
                      },
                    ),
        ),

        // ---------------- Message Input ----------------
        ChatInputField(
          controller: _messageController,
          onSend: _handleSend,
        ),
      ],
    );
  }

  bool _isFirstMessageOfDay(int index, List<MessageEntity> messages) {
    if (index == messages.length - 1) return true;
    final current = messages[index].timestamp;
    final next = messages[index + 1].timestamp; // messages are reversed, so next is chronologically earlier
    return current.day != next.day || current.month != next.month || current.year != next.year;
  }

  Widget _buildDateHeader(DateTime date, ThemeData theme) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    String label;
    if (messageDate == today) {
      label = 'Today';
    } else if (messageDate == yesterday) {
      label = 'Yesterday';
    } else {
      label = DateFormat('d MMMM yyyy').format(date);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Expanded(child: Divider(color: theme.dividerColor.withOpacity(0.1))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.grey.shade500,
              ),
            ),
          ),
          Expanded(child: Divider(color: theme.dividerColor.withOpacity(0.1))),
        ],
      ),
    );
  }
}
