import 'package:rizqmartadmin/features/auth/domain/repository/main/payment_repository.dart';

class RefundPaymentUseCase {
  final PaymentRepository repository;

  RefundPaymentUseCase({required this.repository});

  Future<void> call(String paymentId, double amount) async {
    return await repository.refundPayment(paymentId, amount);
  }
}