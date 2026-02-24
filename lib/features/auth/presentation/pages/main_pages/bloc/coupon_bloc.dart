import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/coupon_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/coupons_repository.dart';

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