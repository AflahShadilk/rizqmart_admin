import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/domain/repository/main/chat_repository.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/chat/chat_event.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/chat/chat_state.dart';

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
    if (state is! ChatsLoaded) {
      emit(ChatLoading());
    }
    _chatsSubscription?.cancel();
    _chatsSubscription = repository.getChats().listen(
      (chats) => add(UpdateChatsEvent(chats)),
      onError: (error) => add(ChatErrorEvent(error.toString())),
    );
  }

  void _onLoadMessages(LoadMessagesEvent event, Emitter<ChatState> emit) {
    if (state is ChatsLoaded) {
      emit((state as ChatsLoaded).copyWith(
        selectedChatId: event.chatId,
        isMessagesLoading: true,
      ));
    } else {
      emit(ChatLoading());
    }

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
    if (state is ChatsLoaded) {
      emit((state as ChatsLoaded).copyWith(chats: event.chats));
    } else {
      emit(ChatsLoaded(chats: event.chats));
    }
  }

  void _onUpdateMessages(UpdateMessagesEvent event, Emitter<ChatState> emit) {
    if (state is ChatsLoaded) {
      final currentState = state as ChatsLoaded;
      
      // Handle notifications for new messages
      if (currentState.messages != null) {
        final oldMessages = currentState.messages!;
        if (event.messages.length > oldMessages.length && event.messages.isNotEmpty) {
          final lastMessage = event.messages.first; // reverse: true in UI, but Firestore usually returns based on order. 
          // Check senderRole
          if (lastMessage.senderRole != 'admin' && event.chatId == currentState.selectedChatId) {
             // Notification logic here if needed, though usually handled by stream
          }
        }
      }

      emit(currentState.copyWith(
        messages: event.messages,
        isMessagesLoading: false,
        selectedChatId: event.chatId,
      ));
    }
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
