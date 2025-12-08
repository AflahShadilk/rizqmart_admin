import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/auth/data/model/add_product_model.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/units_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/product/productadding/form_cubit_state.dart';



class FormCubit extends Cubit<FormCubitState> {
  FormCubit() : super(const FormCubitState());

  void initializeForEdit(ProductModel product) {
    emit(state.copyWith(
      productId: product.id,
      selectedBrandId: product.brand,
      status: product.status ?? true,
      isEditMode: true,
    ));
  }

  void selectCategory(String categoryId) {
    emit(state.copyWith(selectedCategoryId: categoryId));
  }

  void selectBrand(String brandId) {
    emit(state.copyWith(selectedBrandId: brandId));
  }

  void toggleStatus() {
    emit(state.copyWith(status: !state.status));
  }

  void initializeVariants(List<UnitsEntity> units) {
    if (state.isEditMode && state.isInitialized) {
      return;
    }

    final Map<int, String> prices = {};
    final Map<int, String> mrps = {};
    final Map<int, String> stocks = {};
    final Map<int, List<String>> images = {};

    for (int i = 0; i < units.length; i++) {
      prices[i] = '';
      mrps[i] = '';
      stocks[i] = '';
      images[i] = ['', '', ''];
    }

    emit(state.copyWith(
      currentUnits: units,
      variantPrices: prices,
      variantMrps: mrps,
      variantStocks: stocks,
      variantImageUrls: images,
      isInitialized: true,
    ));
  }

  void updateVariantPrice(int index, String value) {
    final updated = Map<int, String>.from(state.variantPrices);
    updated[index] = value;
    emit(state.copyWith(variantPrices: updated));
  }

  void updateVariantMrp(int index, String value) {
    final updated = Map<int, String>.from(state.variantMrps);
    updated[index] = value;
    emit(state.copyWith(variantMrps: updated));
  }

  void updateVariantStock(int index, String value) {
    final updated = Map<int, String>.from(state.variantStocks);
    updated[index] = value;
    emit(state.copyWith(variantStocks: updated));
  }

  void updateVariantImage(int variantIndex, int imageIndex, String imageUrl) {
    final updated = Map<int, List<String>>.from(state.variantImageUrls);
    final imageList = List<String>.from(updated[variantIndex] ?? ['', '', '']);
    imageList[imageIndex] = imageUrl;
    updated[variantIndex] = imageList;
    emit(state.copyWith(variantImageUrls: updated));
  }

  void removeVariantImage(int variantIndex, int imageIndex) {
    final updated = Map<int, List<String>>.from(state.variantImageUrls);
    final imageList = List<String>.from(updated[variantIndex] ?? ['', '', '']);
    imageList[imageIndex] = '';
    updated[variantIndex] = imageList;
    emit(state.copyWith(variantImageUrls: updated));
  }

  void loadEditModeVariants(List<UnitsEntity> allUnits, dynamic variantDetails) {
    final Map<int, String> prices = {};
    final Map<int, String> mrps = {};
    final Map<int, String> stocks = {};
    final Map<int, List<String>> images = {};

    final savedVariants = <String, Map<String, dynamic>>{};
    if (variantDetails != null) {
      for (var variant in variantDetails) {
        savedVariants[variant['unitId']] = variant;
      }
    }

    for (int i = 0; i < allUnits.length; i++) {
      final unit = allUnits[i];
      final saved = savedVariants[unit.id];

      prices[i] = saved?['price']?.toString() ?? '';
      mrps[i] = saved?['mrp']?.toString() ?? '';
      stocks[i] = saved?['quantity']?.toString() ?? '';

      final List<String> imageList = saved != null
          ? List<String>.from(saved['imageUrls'] ?? [])
          : [];
      while (imageList.length < 3) {
        imageList.add('');
      }
      images[i] = imageList.take(3).toList();
    }

    emit(state.copyWith(
      currentUnits: allUnits,
      variantPrices: prices,
      variantMrps: mrps,
      variantStocks: stocks,
      variantImageUrls: images,
      isInitialized: true,
    ));
  }

  void reset() {
    emit(const FormCubitState());
  }
}