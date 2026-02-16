import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/coupon_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/coupon/add_coupon_cubit_state.dart';

class AddCouponCubit extends Cubit<AddCouponState> {
  AddCouponCubit() : super(const AddCouponState());

  void initEditMode(CouponEntity coupon) {
    final discountType = (coupon.percentage ?? 0) > 0 ? 'Percentage' : 'Fixed Amount';
    emit(AddCouponState(
      discountType: discountType,
      expiryDate: coupon.expiryDate,
      isActive: coupon.isActive,
      existingImageUrl: coupon.imageurl,
      applicableProductIds: List.from(coupon.applicableProductIds),
    ));
  }

  void setDiscountType(String type) {
    emit(state.copyWith(discountType: type));
  }

  void setExpiryDate(DateTime date) {
    emit(state.copyWith(expiryDate: date));
  }

  void setActive(bool active) {
    emit(state.copyWith(isActive: active));
  }

  void setPickedImage(PlatformFile image) {
    emit(state.copyWith(pickedImage: image));
  }

  void setApplicableProducts(List<String> ids) {
    emit(state.copyWith(applicableProductIds: ids));
  }

  void setLoading(bool loading) {
    emit(state.copyWith(isLoading: loading));
  }
}
