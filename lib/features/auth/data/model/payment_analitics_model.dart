import 'package:rizqmartadmin/features/auth/domain/entities/main/payment_analitics_entity.dart';

class PaymentAnalyticsModel extends PaymentAnalyticsEntity {
  const PaymentAnalyticsModel({
    required super.totalRevenue,
    required super.completedAmount,
    required super.pendingAmount,
    required super.failedAmount,
    required super.refundedAmount,
    required super.totalTransactions,
    required super.completedCount,
    required super.pendingCount,
    required super.failedCount,
    required super.refundedCount,
    required super.successRate,
  });
}