import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/domain/entities/main/payment_entity.dart';
import 'package:rizqmartadmin/features/domain/repository/main/payment_repository.dart';

class GetPaymentsByStatusUseCase {
  final PaymentRepository repository;

  GetPaymentsByStatusUseCase({required this.repository});

  Future<Either<Failure, List<PaymentEntity>>> call(String status) async {
    return await repository.getPaymentsByStatus(status);
  }
}