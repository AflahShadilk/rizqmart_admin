import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/order/get_new_order_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/order/get_order_by_status_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/order/mark_order_received_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/order/update_order_status_usecase.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/order/order_received_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/order/order_received_state.dart';

class OrderReceivedBloc extends Bloc<OrderReceivedEvent, OrderReceivedState> {
  final GetNewOrdersUseCase getNewOrdersUseCase;
  final GetOrdersByStatusUseCase getOrdersByStatusUseCase;
  final UpdateOrderStatusUseCase updateOrderStatusUseCase;
  final MarkOrderReceivedUseCase markOrderReceivedUseCase;

  OrderReceivedBloc({
    required this.getNewOrdersUseCase,
    required this.getOrdersByStatusUseCase,
    required this.updateOrderStatusUseCase,
    required this.markOrderReceivedUseCase,
  }) : super(const OrderReceivedInitial()) {
    on<FetchNewOrdersEvent>(_onFetchNewOrders);
    on<FetchOrdersByStatusEvent>(_onFetchByStatus);
    on<UpdateOrderStatusEvent>(_onUpdateStatus);
    on<MarkOrderAsReceivedEvent>(_onMarkAsReceived);
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
      add(const FetchNewOrdersEvent());
    } catch (e) {
      emit(OrderReceivedError(message: e.toString()));
    }
  }
}