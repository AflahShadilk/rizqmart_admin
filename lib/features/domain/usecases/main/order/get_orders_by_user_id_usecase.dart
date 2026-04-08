import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/domain/entities/main/order_recieved_entity.dart';
import 'package:rizqmartadmin/features/domain/repository/main/order_received_repository.dart';

class GetOrdersByUserIdUseCase {
  final OrderReceivedRepository repository;

  GetOrdersByUserIdUseCase({required this.repository});

  Future<Either<Failure, List<OrderReceivedEntity>>> call(String userId) async {
    return await repository.getOrdersByUserId(userId);
  }
}
