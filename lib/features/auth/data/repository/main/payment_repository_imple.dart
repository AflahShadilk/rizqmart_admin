import 'package:rizqmartadmin/features/auth/data/data_sources/main/payment_data_source.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/payment_analitics_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/payment_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentDataSource dataSource;

  PaymentRepositoryImpl({required this.dataSource});

  @override
  Future<List<PaymentEntity>> getAllPayments() async {
    final models = await dataSource.getAllPayments();
    return models;
  }

  @override
  Future<List<PaymentEntity>> getPaymentsByStatus(String status) async {
    final models = await dataSource.getPaymentsByStatus(status);
    return models;
  }

  @override
  Future<List<PaymentEntity>> getPaymentsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final models = await dataSource.getPaymentsByDateRange(start, end);
    return models;
  }

  @override
  Future<PaymentEntity> getPaymentById(String paymentId) async {
    final model = await dataSource.getPaymentById(paymentId);
    return model;
  }

  @override
  Future<PaymentAnalyticsEntity> getPaymentAnalytics() async {
    final model = await dataSource.getPaymentAnalytics();
    return model;
  }

  @override
  Future<void> refundPayment(String paymentId, double amount) async {
    await dataSource.refundPayment(paymentId, amount);
  }
}