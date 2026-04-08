import 'package:equatable/equatable.dart';
import 'package:rizqmartadmin/features/domain/entities/main/order_recieved_entity.dart';

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

class NewOrdersStreamUpdate extends OrderReceivedEvent {
  final List<OrderReceivedEntity> orders;

  const NewOrdersStreamUpdate(this.orders);

  @override
  List<Object?> get props => [orders];
}

class FetchOrdersByUserIdEvent extends OrderReceivedEvent {
  final String userId;
  const FetchOrdersByUserIdEvent(this.userId);
  @override
  List<Object?> get props => [userId];
}
