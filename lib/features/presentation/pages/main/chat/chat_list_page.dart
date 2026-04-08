import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rizqmartadmin/core/theme/appcolor.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/chat/chat_bloc.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/chat/chat_event.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/chat/chat_state.dart';
import 'package:rizqmartadmin/features/presentation/pages/main/chat/widgets/chat_list_item.dart';
import 'package:rizqmartadmin/features/domain/entities/main/chat_entity.dart';
import 'package:rizqmartadmin/features/domain/entities/main/message_entity.dart';
import 'package:rizqmartadmin/features/presentation/pages/main/chat/widgets/chat_window_view.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadChatsEvent());
  }

  void _onChatSelected(String chatId) {
    context.read<ChatBloc>().add(LoadMessagesEvent(chatId));
  }

  void _handleSendMessage(String chatId, String text, String userId, String productName) {
    final message = MessageEntity(
      senderId: 'admin',
      text: text,
      type: 'text',
      timestamp: DateTime.now(),
      senderRole: 'admin',
    );

    context.read<ChatBloc>().add(
          SendMessageEvent(
            chatId: chatId,
            message: message,
            userId: userId,
            productName: productName,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: isMobile
          ? AppBar(
              title: const Text('Messages', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 18)),
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            )
          : null, // AppBar handled by split panels or hidden on desktop
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading && state is! ChatsLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ChatsLoaded) {
            if (isMobile) {
              return _buildChatList(state.chats, state.selectedChatId, true);
            }

            return Row(
              children: [
                // ---------------- Left Panel: Chat List (350px) ----------------
                SizedBox(
                  width: 350,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(right: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.1))),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                          child: Text(
                            'Messages',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w800,
                              fontSize: 24,
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                        Expanded(
                          child: _buildChatList(state.chats, state.selectedChatId, false),
                        ),
                      ],
                    ),
                  ),
                ),

                // ---------------- Right Panel: Chat Window (Flexible) ----------------
                Expanded(
                  child: _buildChatWindow(state),
                ),
              ],
            );
          }

          if (state is ChatError) {
            return Center(child: Text('Error: ${state.message}', style: const TextStyle(color: AppColors.matRed)));
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildChatList(List<ChatEntity> chats, String? selectedId, bool isMobile) {
    if (chats.isEmpty) {
      return Center(
        child: Text(
          'No messages yet',
          style: TextStyle(fontFamily: 'Inter', color: Theme.of(context).hintColor),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 12, vertical: 16),
      itemCount: chats.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final chat = chats[index];
        final isSelected = chat.id == selectedId;

        return ChatListItem(
          chat: chat,
          isMobile: isMobile,
          isSelected: !isMobile && isSelected,
          onTap: () {
            if (isMobile) {
              // On mobile, navigate to details page
              context.push('/chat_details', extra: {
                'chatId': chat.id,
                'productName': chat.productName,
                'userId': chat.userId,
              });
            } else {
              _onChatSelected(chat.id);
            }
          },
        );
      },
    );
  }

  Widget _buildChatWindow(ChatsLoaded state) {
    final selectedChat = state.selectedChatId != null ? state.chats.firstWhere((c) => c.id == state.selectedChatId) : null;

    return ChatWindowView(
      chat: selectedChat,
      messages: state.messages,
      isLoading: state.isMessagesLoading,
      onSendMessage: (text) {
        if (selectedChat != null) {
          _handleSendMessage(
            selectedChat.id,
            text,
            selectedChat.userId,
            selectedChat.productName,
          );
        }
      },
    );
  }
}
