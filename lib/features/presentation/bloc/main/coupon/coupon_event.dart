import 'package:rizqmartadmin/features/domain/entities/main/coupon_entity.dart';

abstract class CouponEvent {}

class LoadingCouponsEvent extends CouponEvent {}

class LoadedCouponEvent extends CouponEvent {
  final List<CouponEntity> coupons;
  LoadedCouponEvent(this.coupons);
}

class AddingCouponsEvent extends CouponEvent {
  final CouponEntity coupon;
  AddingCouponsEvent(this.coupon);
}

class UpdatingCouponsEvent extends CouponEvent {
  final CouponEntity coupons;
  UpdatingCouponsEvent(this.coupons);
}

class DeletingCouponEvent extends CouponEvent {
  final String id;
  DeletingCouponEvent(this.id);
}