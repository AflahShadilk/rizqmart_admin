import 'package:rizqmartadmin/features/auth/domain/entities/main/payment_analitics_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/payment_repository.dart';

class GetPaymentAnalyticsUseCase {
  final PaymentRepository repository;

  GetPaymentAnalyticsUseCase({required this.repository});

  Future<PaymentAnalyticsEntity> call() async {
    return await repository.getPaymentAnalytics();
  }
}