import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/domain/entities/main/payment_entity.dart';
import 'package:rizqmartadmin/features/domain/repository/main/payment_repository.dart';

class GetPaymentByOrderIdUseCase {
  final PaymentRepository repository;

  GetPaymentByOrderIdUseCase({required this.repository});

  Future<Either<Failure, PaymentEntity>> call(String orderId) async {
    return await repository.getPaymentByOrderId(orderId);
  }
}
