import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/payment/get_all_payments_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/payment/get_payment_analitics_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/payment/get_payment_by_status_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/payment/refund_payment_usecase.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/payment/payment_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/payment/payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final GetAllPaymentsUseCase getAllPaymentsUseCase;
  final GetPaymentsByStatusUseCase getPaymentsByStatusUseCase;
  final GetPaymentAnalyticsUseCase getPaymentAnalyticsUseCase;
  final RefundPaymentUseCase refundPaymentUseCase;

  PaymentBloc({
    required this.getAllPaymentsUseCase,
    required this.getPaymentsByStatusUseCase,
    required this.getPaymentAnalyticsUseCase,
    required this.refundPaymentUseCase,
  }) : super(const PaymentInitial()) {
    on<FetchAllPaymentsEvent>(_onFetchAllPayments);
    on<FetchPaymentsByStatusEvent>(_onFetchByStatus);
    on<FetchPaymentAnalyticsEvent>(_onFetchAnalytics);
    on<RefundPaymentEvent>(_onRefundPayment);
  }

  Future<void> _onFetchAllPayments(
    FetchAllPaymentsEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoading());
    final result = await getAllPaymentsUseCase.call();
    result.fold(
      (failure) => emit(PaymentError(message: failure.message)),
      (payments) => emit(AllPaymentsLoaded(payments: payments)),
    );
  }

  Future<void> _onFetchByStatus(
    FetchPaymentsByStatusEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoading());
    final result = await getPaymentsByStatusUseCase.call(event.status);
    result.fold(
      (failure) => emit(PaymentError(message: failure.message)),
      (payments) => emit(PaymentsByStatusLoaded(payments: payments, status: event.status)),
    );
  }

  Future<void> _onFetchAnalytics(
    FetchPaymentAnalyticsEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoading());
    final result = await getPaymentAnalyticsUseCase.call();
    result.fold(
      (failure) => emit(PaymentError(message: failure.message)),
      (analytics) => emit(PaymentAnalyticsLoaded(analytics: analytics)),
    );
  }

  Future<void> _onRefundPayment(
    RefundPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoading());
    final result = await refundPaymentUseCase.call(event.paymentId, event.amount);
    result.fold(
      (failure) => emit(PaymentError(message: failure.message)),
      (_) {
        emit(PaymentRefunded(message: 'Payment refunded successfully', paymentId: event.paymentId));
        add(const FetchAllPaymentsEvent());
      },
    );
  }
}
