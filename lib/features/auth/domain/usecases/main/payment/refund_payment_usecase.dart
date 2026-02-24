import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/payment_repository.dart';

class RefundPaymentUseCase {
  final PaymentRepository repository;

  RefundPaymentUseCase({required this.repository});

  Future<Either<Failure, void>> call(String paymentId, double amount) async {
    return await repository.refundPayment(paymentId, amount);
  }
}