import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmartadmin/features/data/models/coupon_model.dart';

class CouponFirestoreSource {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('coupons');

  Stream<List<CouponModel>> getCoupons() {
    return collection.orderBy('createdAt', descending: false).snapshots().asyncMap(
        (snap) async {
      final now = DateTime.now();
      final allCoupons = snap.docs.map((doc) => CouponModel.fromFirestore(doc)).toList();

      // Identify expired coupons and delete them from Firestore
      final expiredCoupons = allCoupons.where((c) => c.expiryDate.isBefore(now)).toList();
      if (expiredCoupons.isNotEmpty) {
        final batch = FirebaseFirestore.instance.batch();
        for (final expired in expiredCoupons) {
          batch.delete(collection.doc(expired.id));
        }
        await batch.commit();
      }

      // Return only active (non-expired) coupons to the UI
      return allCoupons.where((c) => !c.expiryDate.isBefore(now)).toList();
    });
  }
  Future<void>addCoupons(CouponModel model)async{
    final docRef = collection.doc();
    final newModel = CouponModel(
      id: docRef.id,
      name: model.name,
      amount: model.amount,
      percentage: model.percentage,
      minOrderValue: model.minOrderValue,
      imageurl: model.imageurl,
      usageLimit: model.usageLimit,
      isActive: model.isActive,
      expiryDate: model.expiryDate,
      applicableProductIds: model.applicableProductIds,
    );
    await docRef.set(newModel.toFirestore());
  }

  Future<void>updateCoupons(CouponModel coupon)async{
    final data = coupon.toFirestore();
    data.remove('createdAt');
    data['updatedAt'] = FieldValue.serverTimestamp();
    await collection.doc(coupon.id).update(data);
  }

  Future<void>deleteCoupons(String id)async{
    await collection.doc(id).delete();
  }
  
}
