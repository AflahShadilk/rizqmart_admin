import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/payment_analitics_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/payment_repository.dart';

class GetPaymentAnalyticsUseCase {
  final PaymentRepository repository;

  GetPaymentAnalyticsUseCase({required this.repository});

  Future<Either<Failure, PaymentAnalyticsEntity>> call() async {
    return await repository.getPaymentAnalytics();
  }
}