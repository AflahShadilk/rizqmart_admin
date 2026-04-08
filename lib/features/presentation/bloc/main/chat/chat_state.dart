import 'package:equatable/equatable.dart';
import 'package:rizqmartadmin/features/domain/entities/main/chat_entity.dart';
import 'package:rizqmartadmin/features/domain/entities/main/message_entity.dart';

abstract class ChatState extends Equatable {
  const ChatState();
  
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatsLoaded extends ChatState {
  final List<ChatEntity> chats;
  final String? selectedChatId;
  final List<MessageEntity>? messages;
  final bool isMessagesLoading;

  const ChatsLoaded({
    required this.chats,
    this.selectedChatId,
    this.messages,
    this.isMessagesLoading = false,
  });

  ChatsLoaded copyWith({
    List<ChatEntity>? chats,
    String? selectedChatId,
    List<MessageEntity>? messages,
    bool? isMessagesLoading,
  }) {
    return ChatsLoaded(
      chats: chats ?? this.chats,
      selectedChatId: selectedChatId ?? this.selectedChatId,
      messages: messages ?? this.messages,
      isMessagesLoading: isMessagesLoading ?? this.isMessagesLoading,
    );
  }

  @override
  List<Object?> get props => [chats, selectedChatId, messages, isMessagesLoading];
}

class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}
