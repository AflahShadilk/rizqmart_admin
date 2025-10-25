import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/coupon_entity.dart';

class CouponModel extends CouponEntity {
  CouponModel(
      {required String id,
      required String name,
      double? amount,
      double? percentage,
      required double minOrderValue,
      required String imageurl,
      required int usageLimit,
      required bool isActive,
      required DateTime expiryDate})
      : super(
            id: id,
            name: name,
            amount: amount,
            percentage: percentage,
            minOrderValue: minOrderValue,
            imageurl: imageurl,
            usageLimit: usageLimit,
            isActive: isActive,
            expiryDate: expiryDate);

  factory CouponModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CouponModel(
        id: doc.id,
        name: data['name'] ?? '',
        amount: (data['amount'] ?? 0).doDouble(),
        percentage: (data['percentage'] ?? 0).toDouble(),
        minOrderValue: (data['minOrderValue'] ?? 0).toDouble(),
        imageurl: data['imageurl']??'',
        usageLimit: (data['usageLimit'] ?? 0).toInt(),
        isActive: data['isActive'] ?? false,
        expiryDate: (data['expiryDate'] as Timestamp).toDate());
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'percentage': percentage,
      'minOrderValue': minOrderValue,
      'usageLimit': usageLimit,
      'isActive': isActive,
      'expiryDate': expiryDate,
      'createdAt':FieldValue.serverTimestamp()
    };
  }
}
