import 'package:equatable/equatable.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/order_item_entity.dart';

class OrderReceivedEntity extends Equatable {
  final String orderId;
  final String orderNumber;
  final String userId;
  final String userName;
  final String userEmail;
  final String userPhone;
  final double totalAmount;   // totalCost from Firestore
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final String currency;
  final String paymentStatus;
  final String paymentMethod;
  final String? paymentId;
  final String orderStatus;   // status from Firestore
  final String? deliveryMethod;
  final int itemCount;
  final List<OrderItemEntity> items;
  final DateTime createdAt;
  final DateTime? paymentCompletedAt;
  final DateTime? cancelledAt;
  final String deliveryAddress;
  final String? deliveryNotes;
  final String? adminNotes;
  final String? promoCode;

  const OrderReceivedEntity({
    required this.orderId,
    required this.orderNumber,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.totalAmount,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.currency,
    required this.paymentStatus,
    required this.paymentMethod,
    this.paymentId,
    required this.orderStatus,
    this.deliveryMethod,
    required this.itemCount,
    required this.items,
    required this.createdAt,
    this.paymentCompletedAt,
    this.cancelledAt,
    required this.deliveryAddress,
    this.deliveryNotes,
    this.adminNotes,
    this.promoCode,
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
        subtotal,
        deliveryFee,
        discount,
        currency,
        paymentStatus,
        paymentMethod,
        paymentId,
        orderStatus,
        deliveryMethod,
        itemCount,
        items,
        createdAt,
        paymentCompletedAt,
        cancelledAt,
        deliveryAddress,
        deliveryNotes,
        adminNotes,
        promoCode,
      ];
}