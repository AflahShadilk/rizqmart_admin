import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/order_item_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/order_recieved_entity.dart';

class OrderReceivedModel extends OrderReceivedEntity {
  const OrderReceivedModel({
    required super.orderId,
    required super.orderNumber,
    required super.userId,
    required super.userName,
    required super.userEmail,
    required super.userPhone,
    required super.totalAmount,
    required super.currency,
    required super.paymentStatus,
    required super.orderStatus,
    required super.itemCount,
    required super.items,
    required super.createdAt,
    super.paymentCompletedAt,
    required super.deliveryAddress,
    super.deliveryNotes,
  });

  factory OrderReceivedModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final itemsList = (data['items'] as List<dynamic>?)
            ?.map((item) => OrderItemEntity(
                  productId: item['productId'] as String? ?? '',
                  productName: item['productName'] as String? ?? '',
                  price: (item['price'] as num?)?.toDouble() ?? 0.0,
                  quantity: item['quantity'] as int? ?? 0,
                  imageUrl: item['imageUrl'] as String? ?? '',
                ))
            .toList() ??
        [];

    return OrderReceivedModel(
      orderId: doc.id,
      orderNumber: data['orderNumber'] as String? ?? '',
      userId: data['userId'] as String? ?? '',
      userName: data['userName'] as String? ?? 'Unknown',
      userEmail: data['userEmail'] as String? ?? '',
      userPhone: data['userPhone'] as String? ?? '',
      totalAmount: (data['totalAmount'] as num?)?.toDouble() ?? 0.0,
      currency: data['currency'] as String? ?? 'INR',
      paymentStatus: data['paymentStatus'] as String? ?? 'pending',
      orderStatus: data['status'] as String? ?? 'pending',
      itemCount: itemsList.length,
      items: itemsList,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      paymentCompletedAt: (data['paymentCompletedAt'] as Timestamp?)?.toDate(),
      deliveryAddress: data['deliveryAddress'] as String? ?? '',
      deliveryNotes: data['deliveryNotes'] as String?,
    );
  }
}
