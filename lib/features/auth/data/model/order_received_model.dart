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

    // Parse items with proper field names
    final itemsList = (data['items'] as List<dynamic>?)
            ?.map((item) => OrderItemEntity(
                  productId: item['id'] ?? item['productId'] ?? '',
                  productName: item['name'] ?? item['productName'] ?? 'Unknown Product',
                  price: (item['price'] as num?)?.toDouble() ?? 0.0,
                  quantity: (item['count'] ?? item['quantity'] ?? 0)?.toDouble() ?? 0.0,
                  imageUrl: item['imageUrl'] ?? item['image'] ?? '',
                  variantId: item['variantId'] ?? item['variant_id'],
                  unit: item['unit'] ?? item['unitName'],
                ))
            .toList() ??
        [];

    // Get user details with fallback values
    final userName = data['userName'] ?? data['customerName'] ?? data['name'] ?? 'Unknown Customer';
    final userEmail = data['userEmail'] ?? data['email'] ?? 'N/A';
    final userPhone = data['userPhone'] ?? data['phone'] ?? data['phoneNumber'] ?? 'N/A';
    
    // Get delivery address with fallback
    final deliveryAddress = data['deliveryAddress'] ?? data['address'] ?? 'Not specified';
    
    // Get delivery notes
    final deliveryNotes = data['deliveryNotes'] ?? data['notes'];



    return OrderReceivedModel(
      orderId: doc.id,
      orderNumber: data['orderNumber'] ?? 'ORD-${doc.id.substring(0, 8)}',
      userId: data['userId'] ?? data['customerId'] ?? '',
      userName: userName,
      userEmail: userEmail,
      userPhone: userPhone,
      totalAmount: _parseAmount(data['totalAmount'] ?? data['total'] ?? data['totalCost']),
      currency: data['currency'] ?? 'INR',
      paymentStatus: data['paymentStatus'] ?? 'pending',
      orderStatus: data['orderStatus'] ?? data['status'] ?? 'pending',
      itemCount: itemsList.length,
      items: itemsList,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      paymentCompletedAt: (data['paymentCompletedAt'] as Timestamp?)?.toDate(),
      deliveryAddress: deliveryAddress,
      deliveryNotes: deliveryNotes,
    );
  }

  static double _parseAmount(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}