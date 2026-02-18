import 'package:equatable/equatable.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/order_item_entity.dart';

class OrderReceivedEntity extends Equatable {
  final String orderId;
  final String orderNumber;
  final String userId;
  final String userName;
  final String userEmail;
  final String userPhone;
  final double totalAmount;
  final String currency;
  final String paymentStatus;
  final String orderStatus;
  final int itemCount;
  final List<OrderItemEntity> items;
  final DateTime createdAt;
  final DateTime? paymentCompletedAt;
  final String deliveryAddress;
  final String? deliveryNotes;

  const OrderReceivedEntity({
    required this.orderId,
    required this.orderNumber,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.totalAmount,
    required this.currency,
    required this.paymentStatus,
    required this.orderStatus,
    required this.itemCount,
    required this.items,
    required this.createdAt,
    this.paymentCompletedAt,
    required this.deliveryAddress,
    this.deliveryNotes,
  });

  @override
  List<Object?> get props => [
        orderId,
        orderNumber,
        userId,
        userName,
        userEmail,
        userPhone,
        totalAmount,
        currency,
        paymentStatus,
        orderStatus,
        itemCount,
        items,
        createdAt,
        paymentCompletedAt,
        deliveryAddress,
        deliveryNotes,
      ];
}