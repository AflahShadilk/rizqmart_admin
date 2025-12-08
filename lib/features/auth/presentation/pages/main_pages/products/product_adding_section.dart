// ignore_for_file: use_build_context_synchronously, deprecated_member_use, prefer_final_fields

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/core/services/cloudinary_services.dart';
import 'package:rizqmartadmin/features/auth/data/model/add_product_model.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/product_model.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/units_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/brand/brand_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/brand/brand_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/category/category_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/category/category_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/category/category_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/product/productadding/form_cubit.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/product/productadding/form_cubit_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/product/product_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/product/product_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/unit/unit_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/unit/unit_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/unit/unit_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/products/widgets/fields_products.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/products/widgets/widgets.dart';
import 'package:rizqmartadmin/features/auth/presentation/validators/text_field_validator.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/buttons/buttons.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/sized_boxes/sized_box.dart';
import 'package:uuid/uuid.dart';

class FormProducts extends StatefulWidget {
  final ProductModel? model;
  const FormProducts({super.key, this.model});

  @override
  State<FormProducts> createState() => _FormProductsState();
}

class _FormProductsState extends State<FormProducts> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _productName = TextEditingController();
  final TextEditingController _description = TextEditingController();
  late FormCubit _formCubit;

  @override
  void initState() {
    super.initState();
    _formCubit = FormCubit();
    context.read<CategoryBloc>().add(LoadingCategoryEvent());

    if (widget.model != null) {
      _formCubit.initializeForEdit(widget.model!);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setupEditMode();
      });
    }
  }

  Future<void> setupEditMode() async {
    final product = widget.model!;
    _productName.text = product.name;
    _description.text = product.description ?? '';

    await context.read<CategoryBloc>().stream.firstWhere(
          (state) => state is CategoryLoadedState,
          orElse: () => throw Exception('Categories failed to load'),
        );

    final categoryState = context.read<CategoryBloc>().state as CategoryLoadedState;
    final category = categoryState.cotegories.firstWhere(
      (cat) => cat.name == product.category,
    );

    _formCubit.selectCategory(category.id);
    context.read<UnitBloc>().add(GetUnitbyCategoryEvent(product.category));

    await context.read<UnitBloc>().stream.firstWhere(
          (state) => state is UnitLoadedState,
        );

    final unitState = context.read<UnitBloc>().state;
    if (unitState is UnitLoadedState) {
      _formCubit.loadEditModeVariants(unitState.unit, product.variantDetails);
    }
  }

  Future<void> pickVariantImage(int variantIndex, int imageIndex) async {
    try {
      final res = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (res != null && res.files.isNotEmpty) {
        final file = res.files.first;
        final result = FilePickerResult([file]);
        final url = await uploadToCloudinary(result);

        if (url != null) {
          _formCubit.updateVariantImage(variantIndex, imageIndex, url);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
    }
  }

  bool validateVariants(FormCubitState formState) {
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

  void handleSaveProduct(FormCubitState formState) {
    if (!_formKey.currentState!.validate()) {
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

    if (!validateVariants(formState)) {
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
      name: _productName.text.trim(),
      description: _description.text.trim(),
      category: categoryNameToSave,
      brand: formState.selectedBrandId ?? '',
      discount: 0.0,
      createdAt: formState.isEditMode ? widget.model!.createdAt : DateTime.now(),
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

    _formKey.currentState!.reset();
    if (!formState.isEditMode) {
      _productName.clear();
      _description.clear();
      _formCubit.reset();
    }

    context.go('/products');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(formState.isEditMode
            ? 'Product updated successfully'
            : 'Product added successfully'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _formCubit,
      child: BlocBuilder<FormCubit, FormCubitState>(
        builder: (context, formState) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                pageHeading(formState.isEditMode ? 'Edit Product' : 'Add New Product'),
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Common_sizedBox_height10(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: WebTextField(
                          label: 'Product name',
                          hintText: 'Enter product name',
                          controller: _productName,
                          keyboardType: TextInputType.name,
                          maxLines: 1,
                          validator: ProductTextValidators.name,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: WebTextArea(
                          label: 'Description',
                          hintText: 'Enter description',
                          controller: _description,
                          maxLines: 10,
                          validator: ProductTextValidators.description,
                        ),
                      ),
                      const SizedBox(height: 20),
                      buildBrandSection(formState),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          buildCategorySection(formState),
                          const SizedBox(width: 20),
                          buildStatusSection(formState),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (formState.selectedCategoryId != null &&
                          formState.selectedCategoryId!.isNotEmpty)
                        buildVariantSection(formState),
                      const SizedBox(height: 20),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SecondaryButton(
                            label: 'Cancel',
                            onPressed: () {
                              context.go('/products');
                            },
                          ),
                          const SizedBox(width: 20),
                          elevatedButtonForSave(
                            text: formState.isEditMode ? 'Update Product' : 'Save Product',
                            onPressed: () => handleSaveProduct(formState),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildBrandSection(FormCubitState formState) {
    return BlocBuilder<BrandBloc, BrandState>(
      builder: (context, state) {
        List<DropdownMenuItem<String>> brandItems = [];

        if (state is BrandLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BrandLoadedState) {
          brandItems = state.brand.map((brand) {
            return DropdownMenuItem<String>(
              value: brand.name,
              child: Text(brand.name),
            );
          }).toList();
        } else if (state is BrandFailureState) {
          return Center(child: Text('Failed to load brands'));
        }

        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.42,
          child: WebTextFields(
            label: 'Brand',
            hintText: 'Select Brand',
            isDropdown: true,
            dropdownItems: brandItems,
            selectedValue: formState.selectedBrandId,
            onDropdownChanged: (value) {
              _formCubit.selectBrand(value!);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a brand';
              }
              return null;
            },
            prefixIcon: Icons.branding_watermark_outlined,
          ),
        );
      },
    );
  }

  Widget buildCategorySection(FormCubitState formState) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        List<DropdownMenuItem<String>> categoryItems = [];

        if (state is CategoryLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CategoryLoadedState) {
          categoryItems = state.cotegories.map((cat) {
            return DropdownMenuItem<String>(
              value: cat.id,
              child: Text(cat.name),
            );
          }).toList();
        } else if (state is CategoryFailureState) {
          return const Center(child: Text('Failed to load categories'));
        }

        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.42,
          child: WebTextFields(
            label: 'Category',
            hintText: 'Select category',
            isDropdown: true,
            dropdownItems: categoryItems,
            selectedValue: formState.selectedCategoryId,
            onDropdownChanged: (value) {
              final categorystate = context.read<CategoryBloc>().state;
              if (categorystate is CategoryLoadedState) {
                try {
                  final selectedCategory = categorystate.cotegories.firstWhere(
                    (cat) => cat.id == value,
                  );
                  _formCubit.selectCategory(value!);
                  context.read<UnitBloc>().add(
                        GetUnitbyCategoryEvent(selectedCategory.name),
                      );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Category not found: $e')),
                  );
                }
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a category';
              }
              return null;
            },
            prefixIcon: Icons.category,
          ),
        );
      },
    );
  }

  Widget buildStatusSection(FormCubitState formState) {
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Status',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 12),
                Switch(
                  value: formState.status,
                  onChanged: (val) {
                    _formCubit.toggleStatus();
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget buildVariantSection(FormCubitState formState) {
    return BlocConsumer<UnitBloc, UnitState>(
      listener: (context, state) {
        if (state is UnitLoadedState && !formState.isEditMode) {
          _formCubit.initializeVariants(state.unit);
        }
      },
      builder: (context, state) {
        if (state is UnitLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UnitFailureState) {
          return Center(child: Text('Error loading variants: ${state.message}'));
        } else if (state is UnitLoadedState) {
          final displayUnits = formState.currentUnits.isEmpty ? state.unit : formState.currentUnits;

          if (displayUnits.isEmpty) {
            return const Center(child: Text('No variants available for this category'));
          }

          return Container(
            width: MediaQuery.of(context).size.width * 0.95,
            decoration: BoxDecoration(
              color: AppColors.charcoal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.lightBlue,
                width: 2,
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product Variants (${displayUnits.length} available)',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blueAccent,
                  ),
                ),
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayUnits.length,
                  itemBuilder: (context, index) {
                    return buildVariantCard(index, displayUnits[index], formState);
                  },
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget buildVariantCard(int index, UnitsEntity unit, FormCubitState formState) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          color: AppColors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Variant ${index + 1}: ${unit.unitName} (${unit.wieght}${unit.unitType})',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Regular Price',
                          hintText: 'e.g., 50',
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: formState.variantPrices[index] ?? '',
                        onChanged: (value) {
                          _formCubit.updateVariantPrice(index, value);
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Selling Price',
                          hintText: 'e.g., 100',
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: formState.variantMrps[index] ?? '',
                        onChanged: (value) {
                          _formCubit.updateVariantMrp(index, value);
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Stock Quantity',
                          hintText: 'e.g., 50',
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: formState.variantStocks[index] ?? '',
                        onChanged: (value) {
                          _formCubit.updateVariantStock(index, value);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: buildVariantImages(index, formState),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildVariantImages(int variantIndex, FormCubitState formState) {
    final images = formState.variantImageUrls[variantIndex] ?? ['', '', ''];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Images',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 10),
        Row(
          children: List.generate(3, (imageIndex) {
            final imageUrl = imageIndex < images.length ? images[imageIndex] : '';
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: GestureDetector(
                  onTap: () => pickVariantImage(variantIndex, imageIndex),
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.gray.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: imageUrl.isNotEmpty
                        ? Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: GestureDetector(
                                  onTap: () {
                                    _formCubit.removeVariantImage(variantIndex, imageIndex);
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: AppColors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(
                                      Icons.close,
                                      color: AppColors.white,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Center(
                            child: Icon(
                              Icons.add_photo_alternate,
                              size: 30,
                              color: AppColors.gray.withOpacity(.4),
                            ),
                          ),
                  ),
                ),
              ),
            );
          }),
        )
      ],
    );
  }

  @override
  void dispose() {
    _productName.dispose();
    _description.dispose();
    _formCubit.close();
    super.dispose();
  }
}