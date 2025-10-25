import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmartadmin/features/auth/data/model/coupon_model.dart';

class CouponFirestoreSource {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('coupons');

  Stream<List<CouponModel>> getCoupons() {
    return collection.orderBy('createdAt', descending: false).snapshots().map(
        (snap) =>
            snap.docs.map((doc) => CouponModel.fromFirestore(doc)).toList());
  }
  Future<void>addCoupons(CouponModel model)async{
    await collection.add(model.toFirestore());
  }
  
  Future<void>updateCoupons(CouponModel coupon)async{
    await collection.doc(coupon.id).update(coupon.toFirestore());
  }

  Future<void>deleteCoupons(String id)async{
    await collection.doc(id).delete();
  }
  
}
