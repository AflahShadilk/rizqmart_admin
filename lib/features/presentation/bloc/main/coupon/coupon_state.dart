import 'package:rizqmartadmin/features/domain/entities/main/coupon_entity.dart';

abstract class CouponsState {}

class LoadingCouponState extends CouponsState {}

class LoadedCouponsState extends CouponsState {
  final List<CouponEntity> coupons;
  LoadedCouponsState(this.coupons);
}

class LoadingCouponSuccessfulState extends CouponsState {
  final String message;
  LoadingCouponSuccessfulState(this.message);
}

class FailureCouponsState extends CouponsState {
  final String message;
  FailureCouponsState(this.message);
}