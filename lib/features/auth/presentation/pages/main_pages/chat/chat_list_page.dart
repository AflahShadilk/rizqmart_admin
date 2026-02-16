// ignore_for_file: deprecated_member_use

import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/chat/chat_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/chat/chat_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/chat/chat_state.dart';

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

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    if (time.day == now.day && time.month == now.month && time.year == now.year) {
      return DateFormat('h:mm a').format(time);
    } else {
      return DateFormat('MMM d').format(time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Messages',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: AppColors.blackHeading,
          ),
        ),
        elevation: 0,
        backgroundColor: AppColors.backgroundColor,
        iconTheme: const IconThemeData(color: AppColors.blackHeading),
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is ChatsLoaded) {
            if (state.chats.isEmpty) {
              return Center(
                child: Text('No messages yet', style: GoogleFonts.poppins(color: Colors.grey)),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.chats.length,
              separatorBuilder: (_, __) => 12.h,
              itemBuilder: (context, index) {
                final chat = state.chats[index];
                return InkWell(
                  onTap: () {
                    context.push('/chat_details', extra: {
                      'chatId': chat.id, // orderId
                      'productName': chat.productName,
                      'userId': chat.userId,
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: AppColors.darkBlue.withOpacity(0.1),
                        child: const Icon(Icons.shopping_bag_outlined, color: AppColors.darkBlue),
                      ),
                      title: Text(
                        chat.productName.isNotEmpty ? chat.productName : 'Order ${chat.id}',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          2.h,
                          Text(
                            'User: ${chat.userId}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: Colors.grey.shade500,
                              fontSize: 11,
                            ),
                          ),
                          2.h,
                          Text(
                            chat.lastMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(
                        _formatTime(chat.timestamp),
                        style: GoogleFonts.poppins(
                          color: Colors.grey.shade400,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
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
