import 'package:rizqmartadmin/features/auth/data/data_sources/main/coupon_firestore_source.dart';
import 'package:rizqmartadmin/features/auth/data/model/coupon_model.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/coupon_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/coupons_repository.dart';

class CouponRepositoryImpl implements CouponsRepository {
  final CouponFirestoreSource couponFirestoreSource;
  CouponRepositoryImpl(this.couponFirestoreSource);

  @override
  Stream<List<CouponEntity>> getCoupons() {
    return couponFirestoreSource.getCoupons();
  }

  @override
  Future<void> addCoupons(CouponEntity coupon) async {
    final model = CouponModel(
        id: coupon.id,
        name: coupon.name,
        amount: coupon.amount,
        percentage: coupon.percentage,
        minOrderValue: coupon.minOrderValue,
        imageurl: coupon.imageurl,
        usageLimit: coupon.usageLimit,
        isActive: coupon.isActive,
        expiryDate: coupon.expiryDate);
    await couponFirestoreSource.addCoupons(model);
  }

  @override
  Future<void> updateCoupons(CouponEntity coupon) async {
    final model = CouponModel(
        id: coupon.id,
        name: coupon.name,
        amount: coupon.amount,
        percentage: coupon.percentage,
        minOrderValue: coupon.minOrderValue,
        imageurl: coupon.imageurl,
        usageLimit: coupon.usageLimit,
        isActive: coupon.isActive,
        expiryDate: coupon.expiryDate);
    await couponFirestoreSource.updateCoupons(model);
  }

  @override
  Future<void> delete(String id) async {
    await couponFirestoreSource.deleteCoupons(id);
  }
}
