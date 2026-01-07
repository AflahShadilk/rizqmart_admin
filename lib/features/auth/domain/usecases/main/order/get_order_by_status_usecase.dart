import 'package:rizqmartadmin/features/auth/domain/entities/main/order_recieved_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/order_received_repository.dart';

class GetOrdersByStatusUseCase {
  final OrderReceivedRepository repository;

  GetOrdersByStatusUseCase({required this.repository});

  Future<List<OrderReceivedEntity>> call(String status) async {
    return await repository.getOrdersByStatus(status);
  }
}