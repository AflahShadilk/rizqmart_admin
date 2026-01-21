import 'package:rizqmartadmin/features/auth/data/data_sources/main/chat_datasource.dart';
import 'package:rizqmartadmin/features/auth/data/model/chat/message_model.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/chat/chat_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/chat/message_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatDataSource dataSource;

  ChatRepositoryImpl(this.dataSource);

  @override
  Stream<List<ChatEntity>> getChats() {
    return dataSource.getChats();
  }

  @override
  Stream<List<MessageEntity>> getMessages(String userId) {
    return dataSource.getMessages(userId);
  }

  @override
  Future<void> sendMessage(String userId, MessageEntity message) async {
    final messageModel = MessageModel(
      senderId: message.senderId,
      text: message.text,
      type: message.type,
      timestamp: message.timestamp,
    );
    return dataSource.sendMessage(userId, messageModel);
  }
}
