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
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/category/category_state.dart';
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
  Map<int, TextEditingController> _variantPriceController = {};
  Map<int, TextEditingController> _variantMrpController = {};
  Map<int, TextEditingController> _variantStockController = {};
  Map<int, List<String>> _variantImageUrls = {};
  List<UnitsEntity> _currentUnits = [];
  bool _status = true;
  String? selectedBrandId;
  String? selectedCategoryId;
  String? productId;
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    isEditMode = widget.model != null;
    if (isEditMode) {
      editMode();
    }
  }

  Future<void> editMode() async {
    final product = widget.model!;
    productId = product.id;
    _productName.text = product.name;
    _description.text = product.description ?? '';
    _status = product.status ?? true;
    selectedBrandId = product.brand;
    selectedCategoryId = product.category;

    final categoryState = context.read<CategoryBloc>().state;
    if (categoryState is CategoryLoadedState) {
      try {
        final categoryObj = categoryState.cotegories.firstWhere(
          (cat) => cat.name == product.category,
        );
        selectedCategoryId = categoryObj.id;
      } catch (e) {
        selectedCategoryId = null;
      }
    } else {
      selectedCategoryId = null;
    }

    if (product.variantDetails != null && product.variantDetails!.isNotEmpty) {
      _currentUnits = product.variantDetails!.map((detail) {
        return UnitsEntity(
          id: detail['unitId'] ?? '',
          unitName: detail['unitName'] ?? '',
          unitType: detail['unitType'] ?? '',
          wieght: 0,
          category: product.category,
        );
      }).toList();

      _variantPriceController.clear();
      _variantMrpController.clear();
      _variantStockController.clear();
      _variantImageUrls.clear();

      for (int i = 0; i < product.variantDetails!.length; i++) {
        final detail = product.variantDetails![i];

        _variantPriceController[i] = TextEditingController(
          text: detail['price']?.toString() ?? '',
        );
        _variantMrpController[i] = TextEditingController(
          text: detail['mrp']?.toString() ?? '',
        );
        _variantStockController[i] = TextEditingController(
          text: detail['quantity']?.toString() ?? '',
        );
        _variantImageUrls[i] = List<String>.from(detail['imageUrls'] ?? []);
      }
    } else {
      _variantPriceController[0] = TextEditingController(
        text: product.price.toString(),
      );
      _variantMrpController[0] = TextEditingController(
        text: product.mrp.toString(),
      );
      _variantStockController[0] = TextEditingController(
        text: product.quantity.toString(),
      );
      _variantImageUrls[0] = List.from(product.imageUrls);
    }

    setState(() {});
  }

  void initializeVariantForCategory(List<UnitsEntity> units) {
    _variantPriceController.forEach((_, controller) => controller.dispose());
    _variantMrpController.forEach((_, controller) => controller.dispose());
    _variantStockController.forEach((_, controller) => controller.dispose());
    _variantMrpController.clear();
    _variantPriceController.clear();
    _variantStockController.clear();
    _variantImageUrls.clear();

    _currentUnits = units;
    for (int i = 0; i < units.length; i++) {
      _variantPriceController[i] = TextEditingController();
      _variantMrpController[i] = TextEditingController();
      _variantStockController[i] = TextEditingController();
      _variantImageUrls[i] = ['', '', ''];
    }
  }

  Future<void> _pickVariantImage(int variantIndex, int imageIndex) async {
    try {
      final res = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (res != null && res.files.isNotEmpty) {
        final file = res.files.first;
        final result = FilePickerResult([file]);
        final url = await uploadToCloudinary(result);

        setState(() {
          if (_variantImageUrls[variantIndex] != null) {
            _variantImageUrls[variantIndex]![imageIndex] = url ?? '';
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
    }
  }

  bool validateVariants() {
    if (_currentUnits.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category and variants'),
        ),
      );
      return false;
    }

    for (int i = 0; i < _currentUnits.length; i++) {
      final price = _variantPriceController[i]?.text.trim() ?? '';
      final mrp = _variantMrpController[i]?.text.trim() ?? '';
      final quantity = _variantStockController[i]?.text.trim() ?? '';

      if (price.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Variant ${i + 1}: Please enter regular price')),
        );
        return false;
      }

      final priceValue = double.tryParse(price);
      if (priceValue == null || priceValue <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Variant ${i + 1}: Price must be greater than 0'),
          ),
        );
        return false;
      }

      if (mrp.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Variant ${i + 1}: Please enter selling price')),
        );
        return false;
      }

      final mrpValue = double.tryParse(mrp);
      if (mrpValue == null || mrpValue <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Variant ${i + 1}: Selling price must be greater than 0'),
          ),
        );
        return false;
      }

      if (mrpValue <= priceValue) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Variant ${i + 1}: Selling price must be > regular price'),
          ),
        );
        return false;
      }

      if (quantity.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Variant ${i + 1}: Please enter quantity')),
        );
        return false;
      }

      final quantityValue = double.tryParse(quantity);
      if (quantityValue == null || quantityValue <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Variant ${i + 1}: Quantity must be greater than 0'),
          ),
        );
        return false;
      }

      final hasImage = (_variantImageUrls[i] ?? []).any((img) => img.isNotEmpty);
      if (!hasImage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Variant ${i + 1}: Please upload at least one image'),
          ),
        );
        return false;
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          pageHeading(isEditMode ? 'Edit Product' : 'Add New Product'),
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
                BlocBuilder<BrandBloc, BrandState>(
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
                      return Center(
                        child: Text('Failed to load brands'),
                      );
                    }

                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.42,
                      child: WebTextFields(
                        label: 'Brand',
                        hintText: 'Select Brand',
                        isDropdown: true,
                        dropdownItems: brandItems,
                        selectedValue: selectedBrandId,
                        onDropdownChanged: (value) {
                          setState(() => selectedBrandId = value);
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
                ),
                const SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  BlocBuilder<CategoryBloc, CategoryState>(
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
                        return const Center(
                            child: Text('Failed to load categories'));
                      }

                      return SizedBox(
                        width: MediaQuery.of(context).size.width * 0.42,
                        child: WebTextFields(
                          label: 'Category',
                          hintText: 'Select category',
                          isDropdown: true,
                          dropdownItems: categoryItems,
                          selectedValue: selectedCategoryId,
                          onDropdownChanged: (value) {
                            setState(() {
                              selectedCategoryId = value;
                            });
                            final categorystate =
                                context.read<CategoryBloc>().state;
                            if (categorystate is CategoryLoadedState) {
                              try {
                                final selectedCategory = categorystate.cotegories
                                    .firstWhere((cat) => cat.id == value);
                                context
                                    .read<UnitBloc>()
                                    .add(GetUnitbyCategoryEvent(
                                        selectedCategory.name));
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
                  ),
                  const SizedBox(width: 20),
                  Row(
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
                                value: _status,
                                onChanged: (val) {
                                  setState(() {
                                    _status = val;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ]),
                const SizedBox(height: 20),
                if (selectedCategoryId != null &&
                    selectedCategoryId!.isNotEmpty)
                  BlocBuilder<UnitBloc, UnitState>(builder: (context, state) {
                    if (state is UnitLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is UnitFailureState) {
                      return Center(
                          child:
                              Text('Error loading variants: ${state.message}'));
                    } else if (state is UnitLoadedState) {
                      final units = state.unit;
                      if (units.isNotEmpty &&
                          _variantPriceController.length != units.length) {
                        initializeVariantForCategory(units);
                      }
                      if (units.isEmpty) {
                        return const Center(
                            child: Text(
                                'No variants available for this category'));
                      }
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        decoration: BoxDecoration(
                          color: AppColors.blueAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.blueAccent,
                            width: 2,
                          ),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Product Variants (${units.length} available)',
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
                              itemCount: units.length,
                              itemBuilder: (context, index) {
                                final unit = units[index];
                                return _buildVariantCard(index, unit);
                              },
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
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
                      text: isEditMode ? 'Update Product' : 'Save Product',
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please fill all required fields'),
                            ),
                          );
                          return;
                        }

                        if (selectedCategoryId == null ||
                            selectedCategoryId!.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select a category'),
                            ),
                          );
                          return;
                        }

                        if (selectedBrandId == null ||
                            selectedBrandId!.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select a brand'),
                            ),
                          );
                          return;
                        }

                        if (!validateVariants()) {
                          return;
                        }

                        List<Map<String, dynamic>> variantDetails = [];

                        for (int i = 0; i < _currentUnits.length; i++) {
                          variantDetails.add({
                            'unitId': _currentUnits[i].id,
                            'unitName': _currentUnits[i].unitName,
                            'unitType': _currentUnits[i].unitType,
                            'price': double.tryParse(
                                    _variantPriceController[i]?.text ?? '') ??
                                0.0,
                            'mrp': double.tryParse(
                                    _variantMrpController[i]?.text ?? '') ??
                                0.0,
                            'quantity': double.tryParse(
                                    _variantStockController[i]?.text ?? '') ??
                                0.0,
                            'imageUrls': _variantImageUrls[i] ?? [],
                          });
                        }

                        final categoryState =
                            context.read<CategoryBloc>().state;
                        String categoryNameToSave = selectedCategoryId ?? '';

                        if (categoryState is CategoryLoadedState) {
                          try {
                            final selectedCat =
                                categoryState.cotegories.firstWhere(
                              (cat) => cat.id == selectedCategoryId,
                            );
                            categoryNameToSave = selectedCat.name;
                          } catch (e) {
                            categoryNameToSave = selectedCategoryId ?? '';
                          }
                        }

                        double price = double.tryParse(
                                _variantPriceController[0]?.text ?? '') ??
                            0.0;
                        double mrp = double.tryParse(
                                _variantMrpController[0]?.text ?? '') ??
                            0.0;
                        double quantity = double.tryParse(
                                _variantStockController[0]?.text ?? '') ??
                            0.0;

                        final product = AddProductEntity(
                          id: isEditMode
                              ? productId!
                              : const Uuid().v4(),
                          name: _productName.text.trim(),
                          price: price,
                          mrp: mrp,
                          description: _description.text.trim(),
                          category: categoryNameToSave,
                          brand: selectedBrandId ?? '',
                          quantity: quantity,
                          variant: _currentUnits
                              .map((unit) => unit.unitName)
                              .toList(),
                          imageUrls: _variantImageUrls[0] ?? [],
                          createdAt: DateTime.now(),
                          features: false,
                          status: _status,
                          variantDetails: variantDetails,
                        );

                        if (isEditMode) {
                          context.read<ProductBloc>().add(
                              UpdatingProductEvent(product));
                        } else {
                          context.read<ProductBloc>().add(
                              AddingProductEvent(product));
                        }

                        _formKey.currentState!.reset();
                        if (!isEditMode) {
                          setState(() {
                            _productName.clear();
                            _description.clear();
                            _variantPriceController
                                .forEach((_, c) => c.clear());
                            _variantMrpController.forEach((_, c) => c.clear());
                            _variantStockController
                                .forEach((_, c) => c.clear());
                            selectedBrandId = null;
                            selectedCategoryId = null;
                          });
                        }

                        context.go('/products');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isEditMode
                                ? 'Product updated successfully'
                                : 'Product added successfully'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVariantCard(int index, UnitsEntity unit) {
    final priceController = _variantPriceController[index];
    final mrpController = _variantMrpController[index];
    final stockController = _variantStockController[index];

    if (priceController == null ||
        mrpController == null ||
        stockController == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
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
                      WebTextField(
                        label: 'Regular Price',
                        hintText: 'e.g., 50',
                        keyboardType: TextInputType.number,
                        controller: _variantPriceController[index]!,
                      ),
                      const SizedBox(height: 15),
                      WebTextField(
                        label: 'Selling Price',
                        hintText: 'e.g., 100',
                        keyboardType: TextInputType.number,
                        controller: _variantMrpController[index]!,
                      ),
                      const SizedBox(height: 15),
                      WebTextField(
                        label: 'Stock Quantity',
                        hintText: 'e.g., 50',
                        keyboardType: TextInputType.number,
                        controller: _variantStockController[index]!,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildVariantImages(index),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVariantImages(int variantIndex) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text(
        'Images',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      const SizedBox(height: 10),
      Row(
          children: List.generate(2, (imageIndex) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: GestureDetector(
                onTap: () => _pickVariantImage(variantIndex, imageIndex),
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _variantImageUrls[variantIndex]![imageIndex].isNotEmpty
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              _variantImageUrls[variantIndex]![imageIndex],
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _variantImageUrls[variantIndex]![
                                        imageIndex] = '';
                                  });
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
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
                            color: Colors.grey.shade400,
                          ),
                        ),
                )),
          ),
        );
      }))
    ]);
  }

  @override
  void dispose() {
    _productName.dispose();
    _description.dispose();

    _variantPriceController.forEach((_, controller) => controller.dispose());
    _variantMrpController.forEach((_, controller) => controller.dispose());
    _variantStockController.forEach((_, controller) => controller.dispose());

    super.dispose();
  }
}