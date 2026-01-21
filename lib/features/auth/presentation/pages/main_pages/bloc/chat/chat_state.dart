import 'package:equatable/equatable.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/chat/chat_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/chat/message_entity.dart';

abstract class ChatState extends Equatable {
  const ChatState();
  
  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatsLoaded extends ChatState {
  final List<ChatEntity> chats;
  const ChatsLoaded(this.chats);

  @override
  List<Object> get props => [chats];
}

class MessagesLoaded extends ChatState {
  final List<MessageEntity> messages;
  const MessagesLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class MessageSending extends ChatState {}

class MessageSent extends ChatState {}

class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);

  @override
  List<Object> get props => [message];
}
