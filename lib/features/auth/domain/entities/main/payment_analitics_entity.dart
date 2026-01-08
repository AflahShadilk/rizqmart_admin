import 'package:equatable/equatable.dart';

class PaymentAnalyticsEntity extends Equatable {
  final double totalRevenue;
  final double completedAmount;
  final double pendingAmount;
  final double failedAmount;
  final double refundedAmount;
  final int totalTransactions;
  final int completedCount;
  final int pendingCount;
  final int failedCount;
  final int refundedCount;
  final double successRate;

  const PaymentAnalyticsEntity({
    required this.totalRevenue,
    required this.completedAmount,
    required this.pendingAmount,
    required this.failedAmount,
    required this.refundedAmount,
    required this.totalTransactions,
    required this.completedCount,
    required this.pendingCount,
    required this.failedCount,
    required this.refundedCount,
    required this.successRate,
  });

  @override
  List<Object?> get props => [
        totalRevenue,
        completedAmount,
        pendingAmount,
        failedAmount,
        refundedAmount,
        totalTransactions,
        completedCount,
        pendingCount,
        failedCount,
        refundedCount,
        successRate,
      ];
}
