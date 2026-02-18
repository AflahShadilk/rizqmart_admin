import 'package:rizqmartadmin/features/auth/domain/entities/main/payment_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/payment_repository.dart';

class GetAllPaymentsUseCase {
  final PaymentRepository repository;

  GetAllPaymentsUseCase({required this.repository});

  Future<List<PaymentEntity>> call() async {
    return await repository.getAllPayments();
  }
}