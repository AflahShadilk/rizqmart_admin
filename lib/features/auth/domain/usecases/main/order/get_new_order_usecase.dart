import 'package:rizqmartadmin/features/auth/domain/entities/main/order_recieved_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/order_received_repository.dart';

class GetNewOrdersUseCase {
  final OrderReceivedRepository repository;

  GetNewOrdersUseCase({required this.repository});

  Future<List<OrderReceivedEntity>> call() async {
    return await repository.getNewOrders();
  }

  Stream<List<OrderReceivedEntity>> callStream() {
    return repository.getNewOrdersStream();
  }
}