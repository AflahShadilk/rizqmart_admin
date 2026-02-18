import 'package:rizqmartadmin/features/auth/domain/entities/main/payment_analitics_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/payment_entity.dart';

abstract class PaymentRepository {
  Future<List<PaymentEntity>> getAllPayments();
  Future<List<PaymentEntity>> getPaymentsByStatus(String status);
  Future<List<PaymentEntity>> getPaymentsByDateRange(DateTime start, DateTime end);
  Future<PaymentEntity> getPaymentById(String paymentId);
  Future<PaymentAnalyticsEntity> getPaymentAnalytics();
  Future<void> refundPayment(String paymentId, double amount);
  Future<PaymentEntity> getPaymentByOrderId(String orderId);
}