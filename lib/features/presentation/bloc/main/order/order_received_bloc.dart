import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/data/data_sources/services/web_messaging_service.dart';
import 'package:rizqmartadmin/features/domain/entities/main/order_recieved_entity.dart';
import 'dart:async';
import 'package:rizqmartadmin/features/domain/usecases/main/order/get_new_order_usecase.dart';
import 'package:rizqmartadmin/features/domain/usecases/main/order/get_order_by_status_usecase.dart';
import 'package:rizqmartadmin/features/domain/usecases/main/order/get_orders_by_user_id_usecase.dart';
import 'package:rizqmartadmin/features/domain/usecases/main/order/mark_order_received_usecase.dart';
import 'package:rizqmartadmin/features/domain/usecases/main/order/update_order_status_usecase.dart';
import 'package:rizqmartadmin/features/domain/usecases/main/payment/get_payment_by_order_id_usecase.dart';
import 'package:rizqmartadmin/features/domain/usecases/main/payment/refund_payment_usecase.dart';
import 'package:rizqmartadmin/features/domain/usecases/main/order/refill_order_stock_usecase.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/order/order_received_event.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/order/order_received_state.dart';

class OrderReceivedBloc extends Bloc<OrderReceivedEvent, OrderReceivedState> {
  final GetNewOrdersUseCase getNewOrdersUseCase;
  final GetOrdersByStatusUseCase getOrdersByStatusUseCase;
  final UpdateOrderStatusUseCase updateOrderStatusUseCase;
  final MarkOrderReceivedUseCase markOrderReceivedUseCase;
  final GetPaymentByOrderIdUseCase getPaymentByOrderIdUseCase;
  final RefundPaymentUseCase refundPaymentUseCase;
  final GetOrdersByUserIdUseCase? getOrdersByUserIdUseCase;
  final RefillOrderStockUseCase? refillOrderStockUseCase;

  OrderReceivedBloc({
    required this.getNewOrdersUseCase,
    required this.getOrdersByStatusUseCase,
    required this.updateOrderStatusUseCase,
    required this.markOrderReceivedUseCase,
    required this.getPaymentByOrderIdUseCase,
    required this.refundPaymentUseCase,
    this.getOrdersByUserIdUseCase,
    this.refillOrderStockUseCase,
  }) : super(const OrderReceivedInitial()) {
    on<FetchNewOrdersEvent>(_onFetchNewOrders);
    on<FetchOrdersByStatusEvent>(_onFetchByStatus);
    on<UpdateOrderStatusEvent>(_onUpdateStatus);
    on<MarkOrderAsReceivedEvent>(_onMarkAsReceived);
    on<NewOrdersStreamUpdate>(_onNewOrdersStreamUpdate);
    on<FetchOrdersByUserIdEvent>(_onFetchOrdersByUserId);

    _subscribeToNewOrders();
  }

  StreamSubscription? _orderSubscription;

  // cached list of all orders for local filtering
  List<OrderReceivedEntity> _allOrders = [];

  void _subscribeToNewOrders() {
    _orderSubscription?.cancel();
    _orderSubscription = getNewOrdersUseCase.callStream().listen(
      (orders) {
        add(NewOrdersStreamUpdate(orders));
      },
      onError: (error) {},
    );
  }

  Future<void> _onNewOrdersStreamUpdate(
    NewOrdersStreamUpdate event,
    Emitter<OrderReceivedState> emit,
  ) async {
    if (state is NewOrdersLoaded) {
      final oldOrders = (state as NewOrdersLoaded).orders;
      final newOrders = event.orders;

      if (newOrders.length > oldOrders.length) {
        final newOrderIds = newOrders.map((o) => o.orderId).toSet();
        final oldOrderIds = oldOrders.map((o) => o.orderId).toSet();
        final addedIds = newOrderIds.difference(oldOrderIds);

        if (addedIds.isNotEmpty) {
          WebMessagingService.triggerLocalNotification(
            'New Order Received',
            'You have received ${addedIds.length} new order(s)!',
            data: {'type': 'order', 'action': 'new'},
          );
        }
      }

      for (var newOrder in newOrders) {
        final oldOrder = oldOrders.where((o) => o.orderId == newOrder.orderId).isNotEmpty
            ? oldOrders.where((o) => o.orderId == newOrder.orderId).first
            : null;

        if (oldOrder != null && oldOrder.orderStatus != newOrder.orderStatus) {
          final status = newOrder.orderStatus.toLowerCase();

          if (status == 'cancelled' || status == 'canceled') {
            WebMessagingService.triggerLocalNotification(
              'Order Cancelled',
              'Order ${newOrder.orderId} has been cancelled by the customer',
              data: {'type': 'order', 'action': 'cancelled', 'orderId': newOrder.orderId},
            );
          } else if (status == 'delivered') {
            WebMessagingService.triggerLocalNotification(
              'Order Delivered',
              'Order ${newOrder.orderId} has been marked as delivered',
              data: {'type': 'order', 'action': 'delivered', 'orderId': newOrder.orderId},
            );
          } else if (status == 'returned' || status == 'return') {
            WebMessagingService.triggerLocalNotification(
              'Order Returned',
              'Order ${newOrder.orderId} has been returned',
              data: {'type': 'order', 'action': 'returned', 'orderId': newOrder.orderId},
            );
          }
        }
      }
    }
    _allOrders = List.from(event.orders);
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
    final result = await getNewOrdersUseCase.call();
    result.fold(
      (failure) => emit(OrderReceivedError(message: failure.message)),
      (orders) {
        _allOrders = List.from(orders);
        emit(NewOrdersLoaded(orders: orders));
      },
    );
  }

  // filter orders locally from cached list instead of querying Firestore
  Future<void> _onFetchByStatus(
    FetchOrdersByStatusEvent event,
    Emitter<OrderReceivedState> emit,
  ) async {
    if (_allOrders.isEmpty) {
      emit(const OrderReceivedLoading());
      final result = await getNewOrdersUseCase.call();
      result.fold(
        (failure) => emit(OrderReceivedError(message: failure.message)),
        (orders) {
          _allOrders = List.from(orders);
        },
      );
      if (_allOrders.isEmpty) return;
    }
    final filtered = _allOrders
        .where((o) => o.orderStatus.toLowerCase() == event.status.toLowerCase())
        .toList();
    emit(OrdersByStatusLoaded(orders: filtered, status: event.status));
  }

  Future<void> _onUpdateStatus(
    UpdateOrderStatusEvent event,
    Emitter<OrderReceivedState> emit,
  ) async {
    emit(const OrderReceivedLoading());

    if (event.status.toLowerCase() == 'cancelled' ||
        event.status.toLowerCase() == 'rejected' ||
        event.status.toLowerCase() == 'return') {
      if (refillOrderStockUseCase != null) {
        // find the order from cached list for stock refill
        final matchingOrders = _allOrders.where((o) => o.orderId == event.orderId);
        OrderReceivedEntity? orderToRefill = matchingOrders.isNotEmpty ? matchingOrders.first : null;

        if (orderToRefill != null) {
          await refillOrderStockUseCase!.call(orderToRefill);
        }
      }

      final paymentResult = await getPaymentByOrderIdUseCase.call(event.orderId);
      final shouldReturn = paymentResult.fold(
        (failure) {
          emit(OrderReceivedError(message: failure.message));
          return true;
        },
        (payment) => false,
      );
      if (shouldReturn) return;

      paymentResult.fold(
        (_) {},
        (payment) async {
          if (payment.status != 'refunded') {
            final refundResult = await refundPaymentUseCase.call(payment.paymentId, payment.amount);
            refundResult.fold(
              (failure) => emit(OrderReceivedError(message: failure.message)),
              (_) {
                WebMessagingService.triggerLocalNotification(
                  'Order Cancelled',
                  'Order ${event.orderId} has been cancelled, refunded, and stock refilled.',
                  data: {'type': 'order', 'id': event.orderId},
                );
                emit(OrderStatusUpdated(
                  orderId: event.orderId,
                  message: 'Order cancelled, payment refunded, and stock refilled successfully',
                ));
              },
            );
          }
        },
      );
    }

    final updateResult = await updateOrderStatusUseCase.call(event.orderId, event.status);
    updateResult.fold(
      (failure) => emit(OrderReceivedError(message: failure.message)),
      (_) {
        emit(OrderStatusUpdated(orderId: event.orderId, message: 'Order status updated to ${event.status}'));
        add(const FetchNewOrdersEvent());
      },
    );
  }

  Future<void> _onMarkAsReceived(
    MarkOrderAsReceivedEvent event,
    Emitter<OrderReceivedState> emit,
  ) async {
    emit(const OrderReceivedLoading());
    final result = await markOrderReceivedUseCase.call(event.orderId);
    result.fold(
      (failure) => emit(OrderReceivedError(message: failure.message)),
      (_) {
        emit(OrderMarkedAsReceived(orderId: event.orderId, message: 'Order marked as received'));
        WebMessagingService.triggerLocalNotification(
          'Order Received',
          'Order ${event.orderId} has been marked as received.',
          data: {'type': 'order', 'id': event.orderId},
        );
        add(const FetchNewOrdersEvent());
      },
    );
  }

  Future<void> _onFetchOrdersByUserId(
    FetchOrdersByUserIdEvent event,
    Emitter<OrderReceivedState> emit,
  ) async {
    emit(const OrderReceivedLoading());
    if (getOrdersByUserIdUseCase != null) {
      final result = await getOrdersByUserIdUseCase!.call(event.userId);
      result.fold(
        (failure) => emit(OrderReceivedError(message: failure.message)),
        (orders) => emit(OrdersByUserIdLoaded(orders)),
      );
    } else {
      emit(const OrderReceivedError(message: 'UseCase not initialized'));
    }
  }
}