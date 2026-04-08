// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import 'package:rizqmartadmin/core/theme/appcolor.dart';
import 'package:rizqmartadmin/features/data/data_sources/services/cloudinary_services.dart';
import 'package:rizqmartadmin/features/domain/entities/main/product_model.dart';
import 'package:rizqmartadmin/features/data/models/add_product_model.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/category/category_bloc.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/category/category_state.dart';
import 'package:rizqmartadmin/features/presentation/cubit/products/form_cubit.dart';
import 'package:rizqmartadmin/features/presentation/cubit/products/form_cubit_state.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/product/product_bloc.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/product/product_event.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/unit/unit_bloc.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/unit/unit_event.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/unit/unit_state.dart';

class ProductFormLogic {
  
  static Future<void> setupEditMode({
    required BuildContext context,
    required ProductModel product,
    required TextEditingController productNameController,
    required TextEditingController descriptionController,
    required FormCubit formCubit,
  }) async {
    productNameController.text = product.name;
    descriptionController.text = product.description ?? '';

    await context.read<CategoryBloc>().stream.firstWhere(
          (state) => state is CategoryLoadedState,
          orElse: () => throw Exception('Categories failed to load'),
        );

    final categoryState = context.read<CategoryBloc>().state as CategoryLoadedState;
    final category = categoryState.cotegories.firstWhere(
      (cat) => cat.name == product.category,
    );

    formCubit.selectCategory(category.id);
    context.read<UnitBloc>().add(GetUnitbyCategoryEvent(product.category));

    await context.read<UnitBloc>().stream.firstWhere(
          (state) => state is UnitLoadedState,
        );

    final unitState = context.read<UnitBloc>().state;
    if (unitState is UnitLoadedState) {
      formCubit.loadEditModeVariants(unitState.unit, product.variantDetails);
    }
  }

  static Future<void> pickVariantImage({
    required BuildContext context,
    required FormCubit formCubit,
    required int variantIndex,
    required int imageIndex,
  }) async {
    try {
      final url = await ImageUploadService().pickAndUpload();
      if (url != null) {
        formCubit.updateVariantImage(variantIndex, imageIndex, url);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
      }
    }
  }

  static bool validateVariants({
    required BuildContext context,
    required FormCubitState formState,
  }) {
    if (formState.currentUnits.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one variant')),
      );
      return false;
    }

    bool hasAtLeastOneFilledVariant = false;

    for (int i = 0; i < formState.currentUnits.length; i++) {
      final price = formState.variantPrices[i]?.trim() ?? '';
      final mrp = formState.variantMrps[i]?.trim() ?? '';
      final quantity = formState.variantStocks[i]?.trim() ?? '';

      if (price.isEmpty || mrp.isEmpty || quantity.isEmpty) {
        continue;
      }

      final priceValue = double.tryParse(price);
      if (priceValue == null || priceValue <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Variant ${i + 1}: Price must be greater than 0')),
        );
        return false;
      }

      final mrpValue = double.tryParse(mrp);
      if (mrpValue == null || mrpValue <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Variant ${i + 1}: Selling price must be greater than 0')),
        );
        return false;
      }

      if (mrpValue <= priceValue) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Variant ${i + 1}: Selling price must be > regular price')),
        );
        return false;
      }

      final quantityValue = double.tryParse(quantity);
      if (quantityValue == null || quantityValue <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Variant ${i + 1}: Quantity must be greater than 0')),
        );
        return false;
      }

      final hasImage = (formState.variantImageUrls[i] ?? []).any((img) => img.isNotEmpty);
      if (!hasImage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Variant ${i + 1}: Please upload at least one image')),
        );
        return false;
      }

      hasAtLeastOneFilledVariant = true;
    }

    if (!hasAtLeastOneFilledVariant) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill at least one complete variant')),
      );
      return false;
    }

    return true;
  }

  static void handleSaveProduct({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required FormCubit formCubit,
    required FormCubitState formState,
    required TextEditingController productNameController,
    required TextEditingController descriptionController,
    required ProductModel? originalModel,
  }) {
    if (!formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    if (formState.selectedCategoryId == null || formState.selectedCategoryId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    if (formState.selectedBrandId == null || formState.selectedBrandId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a brand')),
      );
      return;
    }

    if (!validateVariants(context: context, formState: formState)) {
      return;
    }

    List<Map<String, dynamic>> variantDetails = [];

    for (int i = 0; i < formState.currentUnits.length; i++) {
      final price = formState.variantPrices[i]?.trim() ?? '';
      final mrp = formState.variantMrps[i]?.trim() ?? '';
      final quantity = formState.variantStocks[i]?.trim() ?? '';

      if (price.isEmpty || mrp.isEmpty || quantity.isEmpty) {
        continue;
      }

      variantDetails.add({
        'unitId': formState.currentUnits[i].id,
        'unitName': formState.currentUnits[i].unitName,
        'unitType': formState.currentUnits[i].unitType,
        'price': double.tryParse(price) ?? 0.0,
        'mrp': double.tryParse(mrp) ?? 0.0,
        'quantity': double.tryParse(quantity) ?? 0.0,
        'imageUrls': formState.variantImageUrls[i] ?? [],
      });
    }

    final categoryState = context.read<CategoryBloc>().state;
    String categoryNameToSave = formState.selectedCategoryId ?? '';

    if (categoryState is CategoryLoadedState) {
      try {
        final selectedCat = categoryState.cotegories.firstWhere(
          (cat) => cat.id == formState.selectedCategoryId,
        );
        categoryNameToSave = selectedCat.name;
      } catch (e) {
        categoryNameToSave = formState.selectedCategoryId ?? '';
      }
    }

    final product = AddProductEntity(
      id: formState.isEditMode ? formState.productId! : const Uuid().v4(),
      name: productNameController.text.trim(),
      description: descriptionController.text.trim(),
      category: categoryNameToSave,
      brand: formState.selectedBrandId ?? '',
      discount: 0.0,
      createdAt: formState.isEditMode ? originalModel!.createdAt : DateTime.now(),
      updateAt: DateTime.now(),
      features: false,
      status: formState.status,
      variantDetails: variantDetails,
    );

    if (formState.isEditMode) {
      context.read<ProductBloc>().add(UpdatingProductEvent(product));
    } else {
      context.read<ProductBloc>().add(AddingProductEvent(product));
    }

    formKey.currentState!.reset();
    if (!formState.isEditMode) {
      productNameController.clear();
      descriptionController.clear();
      formCubit.reset();
    }

    context.go('/products');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(formState.isEditMode
            ? 'Product updated successfully'
            : 'Product added successfully'),
        backgroundColor: AppColors.matGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
