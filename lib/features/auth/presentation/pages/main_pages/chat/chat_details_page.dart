import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/message_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/chat/chat_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/chat/chat_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/chat/chat_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/chat/widgets/chat_input_field.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/chat/widgets/chat_message_bubble.dart';

class ChatDetailsPage extends StatefulWidget {
  final String chatId; // orderId
  final String productName;
  final String userId;

  const ChatDetailsPage({
    super.key,
    required this.chatId,
    required this.productName,
    required this.userId,
  });

  @override
  State<ChatDetailsPage> createState() => _ChatDetailsPageState();
}

class _ChatDetailsPageState extends State<ChatDetailsPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // ---------------- Load Chat Messages ----------------
    if (widget.chatId.isNotEmpty) {
      context.read<ChatBloc>().add(LoadMessagesEvent(widget.chatId));
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ---------------- Chat Actions ----------------
  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final message = MessageEntity(
      senderId: 'admin',
      text: _messageController.text.trim(),
      type: 'text',
      timestamp: DateTime.now(),
      senderRole: 'admin',
    );

    context.read<ChatBloc>().add(
      SendMessageEvent(
        chatId: widget.chatId,
        message: message,
        userId: widget.userId,
        productName: widget.productName,
      ),
    );
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // ---------------- Chat Page Header ----------------
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.productName.isNotEmpty ? widget.productName : 'Order ${widget.chatId}',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 16,
              ),
            ),
            Text(
              'User: ${widget.userId}',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: AppColors.grey.shade600,
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
      ),
      body: Column(
        children: [
          // ---------------- Chat Messages Section ----------------
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading && state is! MessagesLoaded) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChatError) {
                  return Center(
                    child: Text(
                      "Error: ${state.message}",
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.matRed,
                      ),
                    ),
                  );
                } else if (state is MessagesLoaded) {
                  final messages = state.messages;

                  if (messages.isEmpty) {
                    return Center(
                      child: Text(
                        "Start a conversation",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: AppColors.grey,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    reverse: true, // Show latest at bottom
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return ChatMessageBubble(
                        message: messages[index],
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          
          // ---------------- Message Input Section ----------------
          ChatInputField(
            controller: _messageController,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}
