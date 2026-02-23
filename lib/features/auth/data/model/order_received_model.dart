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
    required super.subtotal,
    required super.deliveryFee,
    required super.discount,
    required super.currency,
    required super.paymentStatus,
    required super.paymentMethod,
    super.paymentId,
    required super.orderStatus,
    super.deliveryMethod,
    required super.itemCount,
    required super.items,
    required super.createdAt,
    super.paymentCompletedAt,
    super.cancelledAt,
    required super.deliveryAddress,
    super.deliveryNotes,
    super.adminNotes,
    super.promoCode,
  });

  factory OrderReceivedModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Parse items — price & mrp are inside variantDetails[variantIndex]
    final itemsList = (data['items'] as List<dynamic>?)
            ?.map((item) {
              final variantIndex = (item['variantIndex'] as num?)?.toInt() ?? 0;
              final variants = item['variantDetails'] as List<dynamic>?;
              final variant =
                  (variants != null && variants.isNotEmpty && variantIndex < variants.length)
                      ? variants[variantIndex] as Map<String, dynamic>
                      : <String, dynamic>{};

              return OrderItemEntity(
                productId: item['id'] ?? item['productId'] ?? '',
                productName: item['name'] ?? item['productName'] ?? 'Unknown Product',
                brand: item['brand'],
                mrp: _parseAmount(variant['mrp'] ?? item['mrp']),
                price: _parseAmount(variant['price'] ?? item['price']),
                quantity: _parseAmount(item['count'] ?? item['quantity'] ?? 0),
                imageUrl: (variant['imageUrls'] is List &&
                        (variant['imageUrls'] as List).isNotEmpty)
                    ? (variant['imageUrls'] as List).first ?? ''
                    : item['imageUrl'] ?? item['image'] ?? '',
                variantId: variant['unitId'] ?? item['variantId'],
                unit: variant['unitName'] ?? item['unit'],
              );
            })
            .toList() ??
        [];

    return OrderReceivedModel(
      orderId: doc.id,
      orderNumber: data['orderNumber'] ?? 'ORD-${doc.id.substring(0, 8)}',
      userId: data['userId'] ?? data['customerId'] ?? '',
      userName: data['userName'] ?? data['customerName'] ?? data['name'] ?? 'Unknown Customer',
      userEmail: data['userEmail'] ?? data['email'] ?? 'N/A',
      userPhone: data['userPhone'] ?? data['phone'] ?? data['phoneNumber'] ?? 'N/A',
      totalAmount: _parseAmount(data['totalCost'] ?? data['totalAmount'] ?? data['total']),
      subtotal: _parseAmount(data['subtotal']),
      deliveryFee: _parseAmount(data['deliveryFee']),
      discount: _parseAmount(data['discount']),
      currency: data['currency'] ?? 'INR',
      paymentStatus: data['paymentStatus'] ?? 'pending',
      paymentMethod: data['paymentMethod'] ?? 'N/A',
      paymentId: data['paymentId'],
      orderStatus: data['status'] ?? data['orderStatus'] ?? 'pending',
      deliveryMethod: data['deliveryMethod'],
      itemCount: itemsList.length,
      items: itemsList,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      paymentCompletedAt: (data['paymentCompletedAt'] as Timestamp?)?.toDate(),
      cancelledAt: (data['cancelledAt'] as Timestamp?)?.toDate(),
      deliveryAddress: data['deliveryAddress'] ?? data['address'] ?? 'Not specified',
      deliveryNotes: data['deliveryNotes'],
      adminNotes: data['adminNotes'],
      promoCode: data['promoCode'],
    );
  }

  static double _parseAmount(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}