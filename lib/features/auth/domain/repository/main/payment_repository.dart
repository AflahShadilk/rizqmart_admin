import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/payment_analitics_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/payment_entity.dart';

abstract class PaymentRepository {
  Future<Either<Failure, List<PaymentEntity>>> getAllPayments();
  Future<Either<Failure, List<PaymentEntity>>> getPaymentsByStatus(String status);
  Future<Either<Failure, List<PaymentEntity>>> getPaymentsByDateRange(DateTime start, DateTime end);
  Future<Either<Failure, PaymentEntity>> getPaymentById(String paymentId);
  Future<Either<Failure, PaymentAnalyticsEntity>> getPaymentAnalytics();
  Future<Either<Failure, void>> refundPayment(String paymentId, double amount);
  Future<Either<Failure, PaymentEntity>> getPaymentByOrderId(String orderId);
}