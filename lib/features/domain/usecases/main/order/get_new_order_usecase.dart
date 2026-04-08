import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/domain/entities/main/order_recieved_entity.dart';
import 'package:rizqmartadmin/features/domain/repository/main/order_received_repository.dart';

class GetNewOrdersUseCase {
  final OrderReceivedRepository repository;

  GetNewOrdersUseCase({required this.repository});

  Future<Either<Failure, List<OrderReceivedEntity>>> call() async {
    return await repository.getNewOrders();
  }

  Stream<List<OrderReceivedEntity>> callStream() {
    return repository.getNewOrdersStream();
  }
}