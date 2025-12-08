import 'package:rizqmartadmin/features/auth/domain/entities/main/units_entity.dart';

class FormCubitState {
  final String? productId;
  final String? selectedBrandId;
  final String? selectedCategoryId;
  final bool status;
  final bool isEditMode;
  final List<UnitsEntity> currentUnits;
  final Map<int, String> variantPrices;
  final Map<int, String> variantMrps;
  final Map<int, String> variantStocks;
  final Map<int, List<String>> variantImageUrls;
  final bool isInitialized;

  const FormCubitState({
    this.productId,
    this.selectedBrandId,
    this.selectedCategoryId,
    this.status = true,
    this.isEditMode = false,
    this.currentUnits = const [],
    this.variantPrices = const {},
    this.variantMrps = const {},
    this.variantStocks = const {},
    this.variantImageUrls = const {},
    this.isInitialized = false,
  });

  FormCubitState copyWith({
    String? productId,
    String? selectedBrandId,
    String? selectedCategoryId,
    bool? status,
    bool? isEditMode,
    List<UnitsEntity>? currentUnits,
    Map<int, String>? variantPrices,
    Map<int, String>? variantMrps,
    Map<int, String>? variantStocks,
    Map<int, List<String>>? variantImageUrls,
    bool? isInitialized,
  }) {
    return FormCubitState(
      productId: productId ?? this.productId,
      selectedBrandId: selectedBrandId ?? this.selectedBrandId,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      status: status ?? this.status,
      isEditMode: isEditMode ?? this.isEditMode,
      currentUnits: currentUnits ?? this.currentUnits,
      variantPrices: variantPrices ?? this.variantPrices,
      variantMrps: variantMrps ?? this.variantMrps,
      variantStocks: variantStocks ?? this.variantStocks,
      variantImageUrls: variantImageUrls ?? this.variantImageUrls,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}