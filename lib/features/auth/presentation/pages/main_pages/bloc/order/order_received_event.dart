import 'package:equatable/equatable.dart';

abstract class OrderReceivedEvent extends Equatable {
  const OrderReceivedEvent();

  @override
  List<Object?> get props => [];
}

class FetchNewOrdersEvent extends OrderReceivedEvent {
  const FetchNewOrdersEvent();
}

class FetchOrdersByStatusEvent extends OrderReceivedEvent {
  final String status;

  const FetchOrdersByStatusEvent({required this.status});

  @override
  List<Object?> get props => [status];
}

class UpdateOrderStatusEvent extends OrderReceivedEvent {
  final String orderId;
  final String status;

  const UpdateOrderStatusEvent({
    required this.orderId,
    required this.status,
  });

  @override
  List<Object?> get props => [orderId, status];
}

class MarkOrderAsReceivedEvent extends OrderReceivedEvent {
  final String orderId;

  const MarkOrderAsReceivedEvent({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}
