import 'package:rizqmartadmin/features/auth/data/data_sources/main/chat_datasource.dart';
import 'package:rizqmartadmin/features/auth/data/model/message_model.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/chat_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/message_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/chat_repository.dart';

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
  Future<void> sendMessage(String chatId, MessageEntity message) async {
    final messageModel = MessageModel(
      senderId: message.senderId,
      text: message.text,
      type: message.type,
      timestamp: message.timestamp,
    );
    return dataSource.sendMessage(chatId, messageModel);
  }

  @override
  Future<void> markChatAsRead(String chatId) async {
    return dataSource.markChatAsRead(chatId);
  }
}
