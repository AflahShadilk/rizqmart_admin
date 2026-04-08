import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/features/data/error_handler.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/data/data_sources/main/payment_data_source.dart';
import 'package:rizqmartadmin/features/domain/entities/main/payment_analitics_entity.dart';
import 'package:rizqmartadmin/features/domain/entities/main/payment_entity.dart';
import 'package:rizqmartadmin/features/domain/repository/main/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentDataSource dataSource;

  PaymentRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<PaymentEntity>>> getAllPayments() async {
    return ErrorHandler.execute(() => dataSource.getAllPayments());
  }

  @override
  Future<Either<Failure, List<PaymentEntity>>> getPaymentsByStatus(String status) async {
    return ErrorHandler.execute(() => dataSource.getPaymentsByStatus(status));
  }

  @override
  Future<Either<Failure, List<PaymentEntity>>> getPaymentsByDateRange(DateTime start, DateTime end) async {
    return ErrorHandler.execute(() => dataSource.getPaymentsByDateRange(start, end));
  }

  @override
  Future<Either<Failure, PaymentEntity>> getPaymentById(String paymentId) async {
    return ErrorHandler.execute(() => dataSource.getPaymentById(paymentId));
  }

  @override
  Future<Either<Failure, PaymentAnalyticsEntity>> getPaymentAnalytics() async {
    return ErrorHandler.execute(() => dataSource.getPaymentAnalytics());
  }

  @override
  Future<Either<Failure, void>> refundPayment(String paymentId, double amount) async {
    return ErrorHandler.execute(() => dataSource.refundPayment(paymentId, amount));
  }

  @override
  Future<Either<Failure, PaymentEntity>> getPaymentByOrderId(String orderId) async {
    return ErrorHandler.execute(() => dataSource.getPaymentByOrderId(orderId));
  }
}