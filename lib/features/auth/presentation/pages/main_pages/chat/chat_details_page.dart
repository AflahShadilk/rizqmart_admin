// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/message_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/chat/chat_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/chat/chat_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/chat/chat_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/order/order_received_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/order/order_received_state.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';

class ChatDetailsPage extends StatefulWidget {
  final String userId;
  final String userName;

  const ChatDetailsPage({super.key, required this.userId, required this.userName});

  @override
  State<ChatDetailsPage> createState() => _ChatDetailsPageState();
}

class _ChatDetailsPageState extends State<ChatDetailsPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadMessagesEvent(widget.userId));
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final message = MessageEntity(
      senderId: 'admin',
      text: _messageController.text.trim(),
      type: 'text',
      timestamp: DateTime.now(),
    );

    context.read<ChatBloc>().add(SendMessageEvent(chatId: widget.userId, message: message));
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          widget.userName,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.blackHeading),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: AppColors.blackHeading),
      ),
      body: Column(
        children: [
          // Order History Section
          BlocBuilder<OrderReceivedBloc, OrderReceivedState>(
            builder: (context, state) {
              if (state is OrdersByUserIdLoaded && state.orders.isNotEmpty) {
                 return Container(
                   height: 120, 
                   color: Colors.grey.shade50,
                   child: ListView.separated(
                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                     scrollDirection: Axis.horizontal,
                     itemCount: state.orders.length,
                     separatorBuilder: (_, __) => 12.w,
                     itemBuilder: (context, index) {
                       final order = state.orders[index];
                       return Container(
                         width: 250,
                         padding: const EdgeInsets.all(12),
                         decoration: BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.circular(8),
                           border: Border.all(color: Colors.grey.shade200),
                         ),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Text(
                                   order.orderNumber,
                                   style: GoogleFonts.poppins(
                                     fontWeight: FontWeight.bold,
                                     fontSize: 13,
                                   ),
                                 ),
                                 Container(
                                   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                   decoration: BoxDecoration(
                                     color: _getStatusColor(order.orderStatus).withOpacity(0.1),
                                     borderRadius: BorderRadius.circular(4),
                                   ),
                                   child: Text(
                                     order.orderStatus.toUpperCase(),
                                     style: TextStyle(
                                       fontSize: 10,
                                       fontWeight: FontWeight.w600,
                                       color: _getStatusColor(order.orderStatus),
                                     ),
                                   ),
                                 ),
                               ],
                             ),
                             4.h,
                             Text(
                               '${order.itemCount} Items • ${order.currency} ${order.totalAmount}',
                               style: GoogleFonts.poppins(fontSize: 12),
                             ),
                            4.h,
                             Text(
                               DateFormat('MMM d, h:mm a').format(order.createdAt),
                               style: TextStyle(color: Colors.grey, fontSize: 10),
                             ),
                           ],
                         ),
                       );
                     },
                   ),
                 );
              }
              return const SizedBox(); 
            },
          ),
          const Divider(height: 1),
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading && state is! MessagesLoaded) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChatError) {
                  return Center(child: Text("Error: ${state.message}", style: TextStyle(color: Colors.red)));
                } else if (state is MessagesLoaded) {
                  final messages = state.messages;
                  
                  
                  if (messages.isEmpty) {
                     return Center(child: Text("Start a conversation", style: GoogleFonts.poppins(color: Colors.grey)));
                  }
                  
                  return ListView.builder(
                    controller: _scrollController,
                    reverse: true, // Show latest at bottom
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMe = message.senderId == 'admin';
                      
                      return Column(
                        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          // If message has orderId, show text "Order #ID context" or similar
                          if (message.orderId != null)
                            GestureDetector(
                                onTap: () {
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 4, left: isMe ? 0 : 12, right: isMe ? 12 : 0),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.orange.withOpacity(0.3))
                                  ),
                                  child: Text(
                                    'Related to Order',
                                    style: TextStyle(fontSize: 10, color: Colors.orange[800], fontWeight: FontWeight.bold),
                                  ),
                                ),
                            ),

                          Align(
                            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: isMe ? AppColors.darkBlue : Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(12),
                                  topRight: const Radius.circular(12),
                                  bottomLeft: isMe ? const Radius.circular(12) : Radius.zero,
                                  bottomRight: isMe ? Radius.zero : const Radius.circular(12),
                                ),
                                boxShadow: [
                                   BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  )
                                ]
                              ),
                              child: Column(
                                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    message.text,
                                    style: GoogleFonts.poppins(
                                      color: isMe ? Colors.white : Colors.black87,
                                      fontSize: 14,
                                    ),
                                  ),
                                  4.h,
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        DateFormat('h:mm a').format(message.timestamp),
                                        style: TextStyle(
                                          color: isMe ? Colors.white70 : Colors.grey.shade500,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          
          // Input Area
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
                8.w,
                CircleAvatar(
                  backgroundColor: AppColors.darkBlue,
                  radius: 24,
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return Colors.orange;
      case 'processing': return Colors.blue;
      case 'shipped': return Colors.purple;
      case 'delivered': return Colors.green;
      case 'cancelled': return Colors.red;
      case 'received': return Colors.teal;
      default: return Colors.grey;
    }
  }
}
