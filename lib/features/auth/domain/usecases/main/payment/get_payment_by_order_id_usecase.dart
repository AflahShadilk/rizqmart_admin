import 'package:rizqmartadmin/features/auth/domain/entities/main/payment_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/payment_repository.dart';

class GetPaymentByOrderIdUseCase {
  final PaymentRepository repository;

  GetPaymentByOrderIdUseCase({required this.repository});

  Future<PaymentEntity> call(String orderId) async {
    return await repository.getPaymentByOrderId(orderId);
  }
}
