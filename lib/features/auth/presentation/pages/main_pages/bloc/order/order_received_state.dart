import 'package:equatable/equatable.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/order_recieved_entity.dart';

abstract class OrderReceivedState extends Equatable {
  const OrderReceivedState();

  @override
  List<Object?> get props => [];
}

class OrderReceivedInitial extends OrderReceivedState {
  const OrderReceivedInitial();
}

class OrderReceivedLoading extends OrderReceivedState {
  const OrderReceivedLoading();
}

class NewOrdersLoaded extends OrderReceivedState {
  final List<OrderReceivedEntity> orders;

  const NewOrdersLoaded({required this.orders});

  @override
  List<Object?> get props => [orders];
}

class OrdersByStatusLoaded extends OrderReceivedState {
  final List<OrderReceivedEntity> orders;
  final String status;

  const OrdersByStatusLoaded({
    required this.orders,
    required this.status,
  });

  @override
  List<Object?> get props => [orders, status];
}

class OrderStatusUpdated extends OrderReceivedState {
  final String orderId;
  final String message;

  const OrderStatusUpdated({
    required this.orderId,
    required this.message,
  });

  @override
  List<Object?> get props => [orderId, message];
}

class OrderMarkedAsReceived extends OrderReceivedState {
  final String orderId;
  final String message;

  const OrderMarkedAsReceived({
    required this.orderId,
    required this.message,
  });

  @override
  List<Object?> get props => [orderId, message];
}

class OrderReceivedError extends OrderReceivedState {
  final String message;

  const OrderReceivedError({required this.message});

  @override
  List<Object?> get props => [message];
}
