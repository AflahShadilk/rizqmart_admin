import 'package:rizqmartadmin/features/auth/domain/entities/main/chat/chat_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/chat/message_entity.dart';

abstract class ChatRepository {
  Stream<List<ChatEntity>> getChats();
  Stream<List<MessageEntity>> getMessages(String userId);
  Future<void> sendMessage(String userId, MessageEntity message);
}
