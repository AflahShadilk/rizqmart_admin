import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/coupon_entity.dart';

abstract class CouponsRepository {
  Stream<List<CouponEntity>> getCoupons();
  Future<Either<Failure, void>> addCoupons(CouponEntity couponentity);
  Future<Either<Failure, void>> updateCoupons(CouponEntity couponEntity);
  Future<Either<Failure, void>> delete(String id);
}