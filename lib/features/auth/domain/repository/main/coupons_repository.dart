import 'package:rizqmartadmin/features/auth/domain/entities/main/coupon_entity.dart';

abstract class CouponsRepository {
  Stream<List<CouponEntity>>getCoupons();
  Future<void>addCoupons(CouponEntity couponentity);
  Future<void>updateCoupons(CouponEntity couponEntity);
  Future<void>delete(String id);
}