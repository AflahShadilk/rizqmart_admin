import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/core/services/web_messaging_service.dart';
import 'dart:async';

import 'package:rizqmartadmin/features/auth/domain/usecases/main/order/get_new_order_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/order/get_order_by_status_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/order/get_orders_by_user_id_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/order/mark_order_received_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/order/update_order_status_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/payment/get_payment_by_order_id_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/payment/refund_payment_usecase.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/order/order_received_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/order/order_received_state.dart';

class OrderReceivedBloc extends Bloc<OrderReceivedEvent, OrderReceivedState> {
  final GetNewOrdersUseCase getNewOrdersUseCase;
  final GetOrdersByStatusUseCase getOrdersByStatusUseCase;
  final UpdateOrderStatusUseCase updateOrderStatusUseCase;
  final MarkOrderReceivedUseCase markOrderReceivedUseCase;
  final GetPaymentByOrderIdUseCase getPaymentByOrderIdUseCase;
  final RefundPaymentUseCase refundPaymentUseCase;
  final GetOrdersByUserIdUseCase? getOrdersByUserIdUseCase;

  OrderReceivedBloc({
    required this.getNewOrdersUseCase,
    required this.getOrdersByStatusUseCase,
    required this.updateOrderStatusUseCase,
    required this.markOrderReceivedUseCase,
    required this.getPaymentByOrderIdUseCase,
    required this.refundPaymentUseCase,
    this.getOrdersByUserIdUseCase,
  }) : super(const OrderReceivedInitial()) {
    on<FetchNewOrdersEvent>(_onFetchNewOrders);
    on<FetchOrdersByStatusEvent>(_onFetchByStatus);
    on<UpdateOrderStatusEvent>(_onUpdateStatus);
    on<MarkOrderAsReceivedEvent>(_onMarkAsReceived);
    on<NewOrdersStreamUpdate>(_onNewOrdersStreamUpdate);
    on<FetchOrdersByUserIdEvent>(_onFetchOrdersByUserId);

    // Subscribe to stream immediately
    _subscribeToNewOrders();
  }

  StreamSubscription? _orderSubscription;

  void _subscribeToNewOrders() {
    _orderSubscription?.cancel();
    _orderSubscription = getNewOrdersUseCase.callStream().listen(
      (orders) {
        add(NewOrdersStreamUpdate(orders));
      },
      onError: (error) {
        // Handle stream error if necessary
      },
    );
  }
  
  Future<void> _onNewOrdersStreamUpdate(
    NewOrdersStreamUpdate event,
    Emitter<OrderReceivedState> emit,
  ) async {
    // Notify if new order added (simple check: compare length or ID)
    // For now, just emitting loaded state which updates UI
    if (state is NewOrdersLoaded) {
       final oldOrders = (state as NewOrdersLoaded).orders;
       if (event.orders.length > oldOrders.length) {
          WebMessagingService.triggerLocalNotification(
            'New Order Received', 
            'You have received a new order!',
            data: {'type': 'order'}
          );
       }
    }
    emit(NewOrdersLoaded(orders: event.orders));
  }

  @override
  Future<void> close() {
    _orderSubscription?.cancel();
    return super.close();
  }

  Future<void> _onFetchNewOrders(
    FetchNewOrdersEvent event,
    Emitter<OrderReceivedState> emit,
  ) async {
    emit(const OrderReceivedLoading());

    try {
      final orders = await getNewOrdersUseCase.call();
      emit(NewOrdersLoaded(orders: orders));
    } catch (e) {
      emit(OrderReceivedError(message: e.toString()));
    }
  }

  Future<void> _onFetchByStatus(
    FetchOrdersByStatusEvent event,
    Emitter<OrderReceivedState> emit,
  ) async {
    emit(const OrderReceivedLoading());

    try {
      final orders = await getOrdersByStatusUseCase.call(event.status);
      emit(OrdersByStatusLoaded(
        orders: orders,
        status: event.status,
      ));
    } catch (e) {
      emit(OrderReceivedError(message: e.toString()));
    }
  }

  Future<void> _onUpdateStatus(
    UpdateOrderStatusEvent event,
    Emitter<OrderReceivedState> emit,
  ) async {
    emit(const OrderReceivedLoading());

    try {
      // Check if status is cancelled or rejected to trigger refund
      if (event.status.toLowerCase() == 'cancelled' || 
          event.status.toLowerCase() == 'rejected' || 
          event.status.toLowerCase() == 'return') {
          
        try {
           final payment = await getPaymentByOrderIdUseCase.call(event.orderId);
           // Only refund if not already refunded
           if (payment.status != 'refunded') {
             await refundPaymentUseCase.call(payment.paymentId, payment.amount);
             WebMessagingService.triggerLocalNotification(
              'Order Cancelled', 
              'Order ${event.orderId} has been cancelled and refunded.',
              data: {'type': 'order', 'id': event.orderId}
             );
             emit(OrderStatusUpdated(
               orderId: event.orderId, 
               message: 'Order cancelled and payment refunded successfully'
             ));
           }
        } catch (e) {
          // Log error but proceed with cancellation? Or fail?
          // User likely wants to know if refund failed.
          emit(OrderReceivedError(message: 'Failed to refund payment: ${e.toString()}'));
          return; 
        }
      }

      await updateOrderStatusUseCase.call(event.orderId, event.status);
      emit(OrderStatusUpdated(
        orderId: event.orderId,
        message: 'Order status updated to ${event.status}',
      ));
      add(const FetchNewOrdersEvent());
    } catch (e) {
      emit(OrderReceivedError(message: e.toString()));
    }
  }

  Future<void> _onMarkAsReceived(
    MarkOrderAsReceivedEvent event,
    Emitter<OrderReceivedState> emit,
  ) async {
    emit(const OrderReceivedLoading());

    try {
      await markOrderReceivedUseCase.call(event.orderId);
      emit(OrderMarkedAsReceived(
        orderId: event.orderId,
        message: 'Order marked as received',
      ));
      WebMessagingService.triggerLocalNotification(
        'Order Received', 
        'Order ${event.orderId} has been marked as received.',
        data: {'type': 'order', 'id': event.orderId}
      );
      add(const FetchNewOrdersEvent());
    } catch (e) {
      emit(OrderReceivedError(message: e.toString()));
    }
  }

  Future<void> _onFetchOrdersByUserId(
    FetchOrdersByUserIdEvent event,
    Emitter<OrderReceivedState> emit,
  ) async {
    emit(const OrderReceivedLoading());
    try {
      if (getOrdersByUserIdUseCase != null) {
        final orders = await getOrdersByUserIdUseCase!.call(event.userId);
        emit(OrdersByUserIdLoaded(orders));
      } else {
        emit(const OrderReceivedError(message: 'UseCase not initialized'));
      }
    } catch (e) {
      emit(OrderReceivedError(message: e.toString()));
    }
  }
}