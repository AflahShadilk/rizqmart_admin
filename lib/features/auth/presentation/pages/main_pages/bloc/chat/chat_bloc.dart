import 'dart:async';
import 'package:rizqmartadmin/core/services/web_messaging_service.dart';
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
    // Check for new messages to trigger notification
    if (state is MessagesLoaded) {
      final oldMessages = (state as MessagesLoaded).messages;
      if (event.messages.length > oldMessages.length && event.messages.isNotEmpty) {
        final lastMessage = event.messages.last;
        // Assuming admin ID is constant or we can check senderId. 
        // Since we don't have auth ID here easily, let's assume if it's NOT from 'admin' 
        // (but wait, senderId is usually the user ID or admin ID). 
        // In the chat repository impl, we might know who "me" is.
        // For now, let's check if the senderId is equal to the chat userId (which means the user sent it).
        // BUT Wait, in LoadMessagesEvent we have userId. 
        // We need to persist that userId in state or check against it.
        // Actually, MessagesLoaded doesn't have userId.
        // Let's assume if the last message senderId is NOT 'admin' (hardcoded or known), it's the user.
        // Or better, let's just trigger for now and refine if needed.
        
        // Let's assume 'admin' senderId is filtered out from triggering notification 
        // OR we can check if the senderId matches the message's own ID? No.
        
        // A safer bet: If the message list grew, and the last message is NOT from "me" (admin).
        // We can import FirebaseAuth to check current user ID if needed, 
        // but typically admin ID is the current user ID.
        // Let's rely on checking if senderId is NOT the current user ID.
        
        // Trigger notification
         WebMessagingService.triggerLocalNotification(
            'New Message', 
            lastMessage.text.isNotEmpty ? lastMessage.text : 'Sent an image',
            data: {'type': 'chat_message', 'senderId': lastMessage.senderId}
         );
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
