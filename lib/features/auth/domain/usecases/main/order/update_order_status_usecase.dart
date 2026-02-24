import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/order_received_repository.dart';

class UpdateOrderStatusUseCase {
  final OrderReceivedRepository repository;

  UpdateOrderStatusUseCase({required this.repository});

  Future<Either<Failure, void>> call(String orderId, String status) async {
    return await repository.updateOrderStatus(orderId, status);
  }
}
