import 'package:file_picker/file_picker.dart';

class AddCouponState {
  final String discountType;
  final DateTime? expiryDate;
  final bool isActive;
  final PlatformFile? pickedImage;
  final String? existingImageUrl;
  final List<String> applicableProductIds;
  final bool isLoading;

  const AddCouponState({
    this.discountType = 'Percentage',
    this.expiryDate,
    this.isActive = true,
    this.pickedImage,
    this.existingImageUrl,
    this.applicableProductIds = const [],
    this.isLoading = false,
  });

  AddCouponState copyWith({
    String? discountType,
    DateTime? expiryDate,
    bool? isActive,
    PlatformFile? pickedImage,
    String? existingImageUrl,
    List<String>? applicableProductIds,
    bool? isLoading,
    bool clearPickedImage = false,
    bool clearExpiryDate = false,
  }) {
    return AddCouponState(
      discountType: discountType ?? this.discountType,
      expiryDate: clearExpiryDate ? null : (expiryDate ?? this.expiryDate),
      isActive: isActive ?? this.isActive,
      pickedImage: clearPickedImage ? null : (pickedImage ?? this.pickedImage),
      existingImageUrl: existingImageUrl ?? this.existingImageUrl,
      applicableProductIds: applicableProductIds ?? this.applicableProductIds,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
