import 'package:equatable/equatable.dart';

class PaymentEntity extends Equatable {
  final String paymentId;
  final String orderId;
  final String userId;
  final String userName;
  final double amount;
  final String currency;
  final String status; 
  final String method;
  final String stripePaymentId;
  final DateTime createdAt;
  final DateTime? completedAt;
  final double? refundedAmount;
  final DateTime? refundedAt;

  const PaymentEntity({
    required this.paymentId,
    required this.orderId,
    required this.userId,
    required this.userName,
    required this.amount,
    required this.currency,
    required this.status,
    required this.method,
    required this.stripePaymentId,
    required this.createdAt,
    this.completedAt,
    this.refundedAmount,
    this.refundedAt,
  });

  @override
  List<Object?> get props => [
        paymentId,
        orderId,
        userId,
        userName,
        amount,
        currency,
        status,
        method,
        stripePaymentId,
        createdAt,
        completedAt,
        refundedAmount,
        refundedAt,
      ];
}
