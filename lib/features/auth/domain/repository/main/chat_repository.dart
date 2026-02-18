import 'package:rizqmartadmin/features/auth/domain/entities/main/chat_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/message_entity.dart';

abstract class ChatRepository {
  Stream<List<ChatEntity>> getChats();
  Stream<List<MessageEntity>> getMessages(String chatId);
  Future<void> sendMessage(String chatId, MessageEntity message);
  Future<void> markChatAsRead(String chatId);
}
