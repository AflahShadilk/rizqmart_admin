import 'package:rizqmartadmin/features/auth/domain/entities/main/order_recieved_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/order_received_repository.dart';

class GetOrdersByUserIdUseCase {
  final OrderReceivedRepository repository;

  GetOrdersByUserIdUseCase({required this.repository});

  Future<List<OrderReceivedEntity>> call(String userId) async {
    return await repository.getOrdersByUserId(userId);
  }
}
