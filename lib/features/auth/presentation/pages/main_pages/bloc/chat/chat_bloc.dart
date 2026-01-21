import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/chat_repository.dart'; // Use interface
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
    
    // Internal Events
    on<UpdateChatsEvent>(_onUpdateChats);
    on<UpdateMessagesEvent>(_onUpdateMessages);
    on<ChatErrorEvent>(_onChatError);
  }

  // --- External Event Handlers ---

  void _onLoadChats(LoadChatsEvent event, Emitter<ChatState> emit) {
    emit(ChatLoading());
    try {
      _chatsSubscription?.cancel();
      _chatsSubscription = repository.getChats().listen(
        (chats) => add(UpdateChatsEvent(chats)),
        onError: (error) => add(ChatErrorEvent(error.toString())),
      );
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void _onLoadMessages(LoadMessagesEvent event, Emitter<ChatState> emit) {
    emit(ChatLoading()); 
    // Optimization: In a real app we might check if state is already MessagesLoaded 
    // and keep showing them while loading new ones, or verify userId.
    
    try {
      _messagesSubscription?.cancel();
      _messagesSubscription = repository.getMessages(event.userId).listen(
        (messages) => add(UpdateMessagesEvent(messages)),
        onError: (error) => add(ChatErrorEvent(error.toString())),
      );
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    try {
      await repository.sendMessage(event.userId, event.message);
      // Success: Stream will update UI automatically.
    } catch (e) {
      emit(ChatError("Failed to send: $e"));
    }
  }

  // --- Internal Event Handlers ---

  void _onUpdateChats(UpdateChatsEvent event, Emitter<ChatState> emit) {
    emit(ChatsLoaded(event.chats));
  }

  void _onUpdateMessages(UpdateMessagesEvent event, Emitter<ChatState> emit) {
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
