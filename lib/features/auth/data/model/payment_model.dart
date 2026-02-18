import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/payment_entity.dart';

class PaymentModel extends PaymentEntity {
  const PaymentModel({
    required super.paymentId,
    required super.orderId,
    required super.userId,
    required super.userName,
    required super.amount,
    required super.currency,
    required super.status,
    required super.method,
    required super.stripePaymentId,
    required super.createdAt,
    super.completedAt,
    super.refundedAmount,
    super.refundedAt,
  });

  factory PaymentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return PaymentModel(
      paymentId: doc.id,
      orderId: data['orderId'] as String? ?? '',
      userId: data['userId'] as String? ?? '',
      userName: data['userName'] as String? ?? 'Unknown',
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      currency: data['currency'] as String? ?? 'INR',
      status: data['status'] as String? ?? 'pending',
      method: data['method'] as String? ?? 'stripe',
      stripePaymentId: data['stripePaymentId'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
      refundedAmount: (data['refundedAmount'] as num?)?.toDouble(),
      refundedAt: (data['refundedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userId': userId,
      'userName': userName,
      'amount': amount,
      'currency': currency,
      'status': status,
      'method': method,
      'stripePaymentId': stripePaymentId,
      'createdAt': Timestamp.fromDate(createdAt),
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'refundedAmount': refundedAmount,
      'refundedAt': refundedAt != null ? Timestamp.fromDate(refundedAt!) : null,
    };
  }
}
