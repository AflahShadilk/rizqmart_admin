import 'package:equatable/equatable.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/payment_analitics_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/payment_entity.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {
  const PaymentInitial();
}

class PaymentLoading extends PaymentState {
  const PaymentLoading();
}

class AllPaymentsLoaded extends PaymentState {
  final List<PaymentEntity> payments;

  const AllPaymentsLoaded({required this.payments});

  @override
  List<Object?> get props => [payments];
}

class PaymentsByStatusLoaded extends PaymentState {
  final List<PaymentEntity> payments;
  final String status;

  const PaymentsByStatusLoaded({
    required this.payments,
    required this.status,
  });

  @override
  List<Object?> get props => [payments, status];
}

class PaymentAnalyticsLoaded extends PaymentState {
  final PaymentAnalyticsEntity analytics;

  const PaymentAnalyticsLoaded({required this.analytics});

  @override
  List<Object?> get props => [analytics];
}

class PaymentRefunded extends PaymentState {
  final String message;
  final String paymentId;

  const PaymentRefunded({
    required this.message,
    required this.paymentId,
  });

  @override
  List<Object?> get props => [message, paymentId];
}

class PaymentError extends PaymentState {
  final String message;

  const PaymentError({required this.message});

  @override
  List<Object?> get props => [message];
}
  