import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/features/data/error_handler.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/data/data_sources/main/chat_datasource.dart';
import 'package:rizqmartadmin/features/data/models/message_model.dart';
import 'package:rizqmartadmin/features/domain/entities/main/chat_entity.dart';
import 'package:rizqmartadmin/features/domain/entities/main/message_entity.dart';
import 'package:rizqmartadmin/features/domain/repository/main/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatDataSource dataSource;

  ChatRepositoryImpl(this.dataSource);

  @override
  Stream<List<ChatEntity>> getChats() {
    return dataSource.getChats();
  }

  @override
  Stream<List<MessageEntity>> getMessages(String chatId) {
    return dataSource.getMessages(chatId);
  }

  @override
  Future<Either<Failure, void>> sendMessage(String chatId, MessageEntity message, {String? userId, String? productName}) async {
    final messageModel = MessageModel(
      senderId: message.senderId,
      text: message.text,
      type: message.type,
      timestamp: message.timestamp,
      orderId: message.orderId,
      senderRole: message.senderRole,
    );
    return ErrorHandler.execute(() => dataSource.sendMessage(
      chatId,
      messageModel,
      userId: userId,
      productName: productName,
    ));
  }

  @override
  Future<Either<Failure, void>> markChatAsRead(String chatId) async {
    return ErrorHandler.execute(() => dataSource.markChatAsRead(chatId));
  }
}
