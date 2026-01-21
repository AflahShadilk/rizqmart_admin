import 'package:equatable/equatable.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/chat/chat_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/chat/message_entity.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class LoadChatsEvent extends ChatEvent {}

class LoadMessagesEvent extends ChatEvent {
  final String userId;
  const LoadMessagesEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class SendMessageEvent extends ChatEvent {
  final String userId;
  final MessageEntity message;

  const SendMessageEvent({required this.userId, required this.message});

  @override
  List<Object> get props => [userId, message];
}

class UpdateChatsEvent extends ChatEvent {
  final List<ChatEntity> chats;
  const UpdateChatsEvent(this.chats);
  @override
  List<Object> get props => [chats];
}

class UpdateMessagesEvent extends ChatEvent {
  final List<MessageEntity> messages;
  const UpdateMessagesEvent(this.messages);
  @override
  List<Object> get props => [messages];
}

class ChatErrorEvent extends ChatEvent {
  final String error;
  const ChatErrorEvent(this.error);
  @override
  List<Object> get props => [error];
}
