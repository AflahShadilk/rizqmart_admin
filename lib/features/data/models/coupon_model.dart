import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmartadmin/features/domain/entities/main/coupon_entity.dart';

class CouponModel extends CouponEntity {
  const CouponModel({
    required super.id,
    required super.name,
    super.amount,
    super.percentage,
    required super.minOrderValue,
    required super.imageurl,
    required super.usageLimit,
    required super.isActive,
    required super.expiryDate,
    required super.applicableProductIds,
  });

  factory CouponModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CouponModel(
      id: doc.id,
      name: data['name'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      percentage: (data['percentage'] ?? 0).toDouble(),
      minOrderValue: (data['minOrderValue'] ?? 0).toDouble(),
      imageurl: data['imageurl'] ?? '',
      usageLimit: (data['usageLimit'] ?? 0).toInt(),
      isActive: data['isActive'] ?? false,
      expiryDate: (data['expiryDate'] as Timestamp).toDate(),
      applicableProductIds: List<String>.from(data['applicableProductIds'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'percentage': percentage,
      'minOrderValue': minOrderValue,
      'imageurl': imageurl,
      'usageLimit': usageLimit,
      'isActive': isActive,
      'expiryDate': expiryDate,
      'applicableProductIds': applicableProductIds,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
