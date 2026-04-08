import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/domain/entities/main/coupon_entity.dart';
import 'package:rizqmartadmin/features/domain/repository/main/coupons_repository.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/coupon/coupon_event.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/coupon/coupon_state.dart';

class CouponBloc extends Bloc<CouponEvent, CouponsState> {
  final CouponsRepository couponsRepository;
  StreamSubscription<List<CouponEntity>>? subscription;
  CouponBloc({required this.couponsRepository}) : super(LoadingCouponState()) {
    on<LoadingCouponsEvent>(loadingCoupons);
    on<LoadedCouponEvent>(loadedCoupons);
    on<AddingCouponsEvent>(addingCoupon);
    on<UpdatingCouponsEvent>(updateCoupons);
    on<DeletingCouponEvent>(deleteCoupons);
    add(LoadingCouponsEvent());
  }

  void loadingCoupons(LoadingCouponsEvent event, Emitter<CouponsState> emit) {
    emit(LoadingCouponState());
    subscription?.cancel();
    subscription = couponsRepository.getCoupons().listen((coupons) {
      add(LoadedCouponEvent(coupons));
    });
  }

  void loadedCoupons(LoadedCouponEvent event, Emitter<CouponsState> emit) {
    emit(LoadedCouponsState(event.coupons));
  }

  Future<void> addingCoupon(AddingCouponsEvent event, Emitter<CouponsState> emit) async {
    final result = await couponsRepository.addCoupons(event.coupon);
    result.fold(
      (failure) => emit(FailureCouponsState(failure.message)),
      (_) => emit(LoadingCouponSuccessfulState('Creating new coupon successfully')),
    );
  }

  Future<void> updateCoupons(UpdatingCouponsEvent event, Emitter<CouponsState> emit) async {
    final result = await couponsRepository.updateCoupons(event.coupons);
    result.fold(
      (failure) => emit(FailureCouponsState(failure.message)),
      (_) => emit(LoadingCouponSuccessfulState('Updating coupon successfully')),
    );
  }

  Future<void> deleteCoupons(DeletingCouponEvent event, Emitter<CouponsState> emit) async {
    final result = await couponsRepository.delete(event.id);
    result.fold(
      (failure) => emit(FailureCouponsState(failure.message)),
      (_) => emit(LoadingCouponSuccessfulState('Deleting coupon successfully')),
    );
  }

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }
}