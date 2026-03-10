import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/chat/chat_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/chat/chat_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/chat/chat_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/chat/widgets/chat_list_item.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  void initState() {
    super.initState();
    // ---------------- Load Chat Data ----------------
    context.read<ChatBloc>().add(LoadChatsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // ---------------- Chat Page Header ----------------
      appBar: AppBar(
        title: Text(
          'Messages',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
      ),
      // ---------------- Conversations List Section ----------------
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  color: AppColors.matRed,
                ),
              ),
            );
          } else if (state is ChatsLoaded) {
            if (state.chats.isEmpty) {
              return Center(
                child: Text(
                  'No messages yet',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Theme.of(context).hintColor,
                  ),
                ),
              );
            }
            return ListView.separated(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 24,
                vertical: 16,
              ),
              itemCount: state.chats.length,
              separatorBuilder: (_, __) => 12.h,
              itemBuilder: (context, index) {
                return ChatListItem(
                  chat: state.chats[index],
                  isMobile: isMobile,
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
