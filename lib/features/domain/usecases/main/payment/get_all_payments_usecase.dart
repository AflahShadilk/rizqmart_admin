import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/domain/entities/main/payment_entity.dart';
import 'package:rizqmartadmin/features/domain/repository/main/payment_repository.dart';

class GetAllPaymentsUseCase {
  final PaymentRepository repository;

  GetAllPaymentsUseCase({required this.repository});

  Future<Either<Failure, List<PaymentEntity>>> call() async {
    return await repository.getAllPayments();
  }
}