import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/chat_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/message_entity.dart';

abstract class ChatRepository {
  Stream<List<ChatEntity>> getChats();
  Stream<List<MessageEntity>> getMessages(String chatId);
  Future<Either<Failure, void>> sendMessage(String chatId, MessageEntity message, {String? userId, String? productName});
  Future<Either<Failure, void>> markChatAsRead(String chatId);
}
