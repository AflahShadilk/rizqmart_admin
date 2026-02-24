import 'dart:async';
import 'package:rizqmartadmin/core/services/web_messaging_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/chat_repository.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/chat/chat_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/chat/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository repository;
  StreamSubscription? _chatsSubscription;
  StreamSubscription? _messagesSubscription;

  ChatBloc(this.repository) : super(ChatInitial()) {
    on<LoadChatsEvent>(_onLoadChats);
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<MarkChatAsReadEvent>(_onMarkChatAsRead);

    on<UpdateChatsEvent>(_onUpdateChats);
    on<UpdateMessagesEvent>(_onUpdateMessages);
    on<ChatErrorEvent>(_onChatError);
  }

  void _onLoadChats(LoadChatsEvent event, Emitter<ChatState> emit) {
    emit(ChatLoading());
    _chatsSubscription?.cancel();
    _chatsSubscription = repository.getChats().listen(
      (chats) => add(UpdateChatsEvent(chats)),
      onError: (error) => add(ChatErrorEvent(error.toString())),
    );
  }

  void _onLoadMessages(LoadMessagesEvent event, Emitter<ChatState> emit) {
    emit(ChatLoading());
    add(MarkChatAsReadEvent(event.chatId));
    _messagesSubscription?.cancel();
    _messagesSubscription = repository.getMessages(event.chatId).listen(
      (messages) => add(UpdateMessagesEvent(messages, event.chatId)),
      onError: (error) => add(ChatErrorEvent(error.toString())),
    );
  }

  Future<void> _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    final result = await repository.sendMessage(
      event.chatId,
      event.message,
      userId: event.userId,
      productName: event.productName,
    );
    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (_) {},
    );
  }

  Future<void> _onMarkChatAsRead(MarkChatAsReadEvent event, Emitter<ChatState> emit) async {
    final result = await repository.markChatAsRead(event.chatId);
    result.fold(
      (_) {},
      (_) {},
    );
  }

  void _onUpdateChats(UpdateChatsEvent event, Emitter<ChatState> emit) {
    emit(ChatsLoaded(event.chats));
  }

  void _onUpdateMessages(UpdateMessagesEvent event, Emitter<ChatState> emit) {
    if (state is MessagesLoaded) {
      final oldMessages = (state as MessagesLoaded).messages;
      if (event.messages.length > oldMessages.length && event.messages.isNotEmpty) {
        final lastMessage = event.messages.last;
        if (lastMessage.senderRole != 'admin') {
          WebMessagingService.triggerLocalNotification(
            'New Message',
            lastMessage.text.isNotEmpty ? lastMessage.text : 'Sent an image',
            data: {'type': 'chat_message', 'senderId': lastMessage.senderId, 'chatId': event.chatId},
          );
        }
      }
    }
    emit(MessagesLoaded(event.messages));
  }

  void _onChatError(ChatErrorEvent event, Emitter<ChatState> emit) {
    emit(ChatError(event.error));
  }

  @override
  Future<void> close() {
    _chatsSubscription?.cancel();
    _messagesSubscription?.cancel();
    return super.close();
  }
}
