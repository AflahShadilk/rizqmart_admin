import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/chat_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/message_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/chat/chat_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/chat/chat_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/chat/chat_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/chat/widgets/chat_window_view.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/chat/widgets/user_name_resolver.dart';

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
  @override
  void initState() {
    super.initState();
    if (widget.chatId.isNotEmpty) {
      context.read<ChatBloc>().add(LoadMessagesEvent(widget.chatId));
    }
  }

  void _sendMessage(String text) {
    final message = MessageEntity(
      senderId: 'admin',
      text: text,
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: UserNameResolver(
          userId: widget.userId,
          orderId: widget.chatId,
          builder: (context, name) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontSize: 16,
                ),
              ),
              Text(
                'Order #${widget.chatId.substring(0, 8).toUpperCase()}',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: AppColors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          final chatsState = state is ChatsLoaded ? state : null;
          
          // Find or create a temporary chat entity for the view
          ChatEntity? chat;
          if (chatsState != null) {
            try {
              chat = chatsState.chats.firstWhere((c) => c.id == widget.chatId);
            } catch (_) {
              chat = ChatEntity(
                id: widget.chatId,
                productName: widget.productName,
                productId: '',
                userId: widget.userId,
                adminId: 'admin',
                lastMessage: '',
                lastMessageSenderRole: '',
                timestamp: DateTime.now(),
              );
            }
          }

          return ChatWindowView(
            chat: chat,
            messages: chatsState?.messages,
            isLoading: chatsState?.isMessagesLoading ?? (state is ChatLoading),
            onSendMessage: _sendMessage,
          );
        },
      ),
    );
  }
}
