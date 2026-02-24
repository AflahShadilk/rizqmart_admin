import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/error_handler.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
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
  Future<Either<Failure, void>> addCoupons(CouponEntity coupon) async {
    final model = CouponModel(
        id: coupon.id,
        name: coupon.name,
        amount: coupon.amount,
        percentage: coupon.percentage,
        minOrderValue: coupon.minOrderValue,
        imageurl: coupon.imageurl,
        usageLimit: coupon.usageLimit,
        isActive: coupon.isActive,
        expiryDate: coupon.expiryDate,
        applicableProductIds: coupon.applicableProductIds);
    return ErrorHandler.execute(() => couponFirestoreSource.addCoupons(model));
  }

  @override
  Future<Either<Failure, void>> updateCoupons(CouponEntity coupon) async {
    final model = CouponModel(
        id: coupon.id,
        name: coupon.name,
        amount: coupon.amount,
        percentage: coupon.percentage,
        minOrderValue: coupon.minOrderValue,
        imageurl: coupon.imageurl,
        usageLimit: coupon.usageLimit,
        isActive: coupon.isActive,
        expiryDate: coupon.expiryDate,
        applicableProductIds: coupon.applicableProductIds);
    return ErrorHandler.execute(() => couponFirestoreSource.updateCoupons(model));
  }

  @override
  Future<Either<Failure, void>> delete(String id) async {
    return ErrorHandler.execute(() => couponFirestoreSource.deleteCoupons(id));
  }
}
