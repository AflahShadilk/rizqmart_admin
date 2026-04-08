import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class FetchAllPaymentsEvent extends PaymentEvent {
  const FetchAllPaymentsEvent();
}

class FetchPaymentsByStatusEvent extends PaymentEvent {
  final String status;

  const FetchPaymentsByStatusEvent({required this.status});

  @override
  List<Object?> get props => [status];
}

class FetchPaymentAnalyticsEvent extends PaymentEvent {
  const FetchPaymentAnalyticsEvent();
}

class RefundPaymentEvent extends PaymentEvent {
  final String paymentId;
  final double amount;

  const RefundPaymentEvent({
    required this.paymentId,
    required this.amount,
  });

  @override
  List<Object?> get props => [paymentId, amount];
}
