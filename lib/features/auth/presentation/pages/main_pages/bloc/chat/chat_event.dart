import 'package:equatable/equatable.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/chat_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/message_entity.dart';


abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class LoadChatsEvent extends ChatEvent {}

class LoadMessagesEvent extends ChatEvent {
  final String chatId;
  const LoadMessagesEvent(this.chatId);

  @override
  List<Object> get props => [chatId];
}

class SendMessageEvent extends ChatEvent {
  final String chatId;
  final MessageEntity message;

  const SendMessageEvent({required this.chatId, required this.message});

  @override
  List<Object> get props => [chatId, message];
}

class UpdateChatsEvent extends ChatEvent {
  final List<ChatEntity> chats;
  const UpdateChatsEvent(this.chats);
  @override
  List<Object> get props => [chats];
}

class UpdateMessagesEvent extends ChatEvent {
  final List<MessageEntity> messages;
  final String chatId; // Added chatId
  const UpdateMessagesEvent(this.messages, this.chatId);
  @override
  List<Object> get props => [messages, chatId];
}

class ChatErrorEvent extends ChatEvent {
  final String error;
  const ChatErrorEvent(this.error);
  @override
  List<Object> get props => [error];
}

class MarkChatAsReadEvent extends ChatEvent {
  final String chatId;
  const MarkChatAsReadEvent(this.chatId);
  @override
  List<Object> get props => [chatId];
}
