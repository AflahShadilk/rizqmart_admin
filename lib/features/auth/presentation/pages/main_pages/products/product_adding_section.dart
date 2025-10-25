// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/core/services/cloudinary_services.dart';
import 'package:rizqmartadmin/features/auth/data/model/add_product_model.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/product_model.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/brand/brand_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/brand/brand_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/category/category_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/category/category_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/category/category_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/product/product_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/product/product_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/products/widgets/fields_products.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/products/widgets/image_picker_file.dart';
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
  final TextEditingController _price = TextEditingController();
  final TextEditingController _mrp = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _stockKey = TextEditingController();
  bool _status = true;
  String? selectedBrandId;
  String? selectedCategoryId;
  List<String> selectedVariant = ['', ''];
  List<String> imageUrls = ["", ""];
  List<bool> isUploading = [false, false];
  String? productId;
  bool isLoading = false;
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
    _price.text = product.price.toString();
    _mrp.text = product.mrp.toString();
    _description.text = product.description!;
    _stockKey.text = product.quantity.toString();

    _status = product.status!;
    selectedBrandId = product.brand;
    selectedCategoryId = product.category;
    selectedVariant = List.from(product.variant);
    imageUrls = List.from(product.imageUrls);
    setState(() {});
  }

  Future<void> _pickImage(int imageIndex) async {
    setState(() {
      isUploading[imageIndex] = true;
    });
    try {
      final res = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (res != null && res.files.isNotEmpty) {
        final file = res.files.first;
        final result = FilePickerResult([file]);
        final url = await uploadToCloudinary(
          result,
        );
        setState(() {
          while (imageUrls.length <= imageIndex) {
            imageUrls.add('');
          }
          imageUrls[imageIndex] = url!;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to upload image: $e')));
    } finally {
      setState(() {
        isUploading[imageIndex] = false;
      });
    }
  }

// remove imge
  void removeImage(int imageIndex) {
    setState(() {
      if (imageIndex < imageUrls.length) {
        imageUrls[imageIndex] = '';
      }
    });
  }

  bool validateImage() {
    if (imageUrls.isEmpty || imageUrls.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload at least 1 images')),
      );
      return false;
    }
    if (imageUrls[0].isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload 1 images')),
      );
      return false;
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

                WebTextField(
                  label: 'Product name',
                  hintText: 'Enter product name',
                  controller: _productName,
                  keyboardType: TextInputType.name,
                  maxLines: 1,
                  validator: ProductTextValidators.name,
                ),
                const SizedBox(height: 20),
                WebTextField(
                  label: 'Mrp Price',
                  hintText: 'Enter price',
                  controller: _mrp,
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  validator: ProductTextValidators.price,
                ),
                const SizedBox(height: 20),
                WebTextField(
                  label: 'Price',
                  hintText: 'Enter price',
                  controller: _price,
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  validator: ProductTextValidators.price,
                ),
                const SizedBox(height: 20),
                WebTextArea(
                  label: 'Description',
                  hintText: 'Enter description',
                  controller: _description,
                  maxLines: 10,
                  validator: ProductTextValidators.description,
                ),
                const SizedBox(height: 20),

                //-----------------             -------Brand
                BlocBuilder<BrandBloc, BrandState>(
                  builder: (context, state) {
                    List<DropdownMenuItem<String>> brandItems = [];

                    if (state is BrandLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is BrandLoadedState) {
                      brandItems = state.brand.map((brand) {
                        return DropdownMenuItem<String>(
                          value: brand.id,
                          child: Text(brand.name),
                        );
                      }).toList();
                    } else if (state is BrandFailureState) {
                      return Center(
                        child: Text('Failed to load brands'),
                      );
                    }

                    return SizedBox(
                      width: MediaQuery.of(context).size.width*0.42,
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
                //                                  --------- category section
                const SizedBox(
                  height: 20,
                ),
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(
                    child: BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, state) {
                        List<DropdownMenuItem<String>> categoryItems = [];

                        if (state is CategoryLoadingState) {
                          return const Center(
                              child: CircularProgressIndicator());
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

                        return WebTextFields(
                          label: 'Category',
                          hintText: 'Select category',
                          isDropdown: true,
                          dropdownItems: categoryItems,
                          selectedValue: selectedCategoryId,
                          onDropdownChanged: (value) {
                            setState(() {
                              selectedCategoryId = value;
                              if (!isEditMode) {
                                selectedVariant = ['', ''];
                              }
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a category';
                            }
                            return null;
                          },
                          prefixIcon: Icons.category,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, state) {
                    List<String> variants1 = [];
                    if (state is CategoryLoadedState &&
                        selectedCategoryId != null) {
                      try {
                        final selectedCategory = state.cotegories.firstWhere(
                          (cat) => cat.id == selectedCategoryId,
                        );
                        variants1 =
                            sortVariant(selectedCategory.variants ?? []);
                      } catch (e) {
                        variants1 = [];
                      }
                    } else if (state is CategoryFailureState) {
                      return const Center(
                          child: Text('Failed to load variants'));
                    }

                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: WebTextFields(
                                label: 'Variant',
                                hintText: selectedCategoryId == null
                                    ? 'Select category first'
                                    : 'Select variant',
                                isDropdown: true,
                                dropdownItems: variants1.map((variant) {
                                  return DropdownMenuItem<String>(
                                    value: variant,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(variant),
                                        IconButton(
                                            onPressed: () {
                                              showDeleteVariantDialog(
                                                  context, variant);
                                            },
                                            icon: const Icon(
                                              Icons.cancel,
                                              color: AppColors.red,
                                            )),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                selectedItemBuilder: (context) {
                                  return variants1.map((variant) {
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        variant,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList();
                                },
                                selectedValue: selectedVariant[0].isNotEmpty
                                    ? selectedVariant[0]
                                    : null,
                                onDropdownChanged: (val) {
                                  setState(() {
                                    selectedVariant[0] = val ?? '';
                                  });
                                },
                                validator: (val) {
                                  if (selectedCategoryId == null) {
                                    return 'Please select Category';
                                  }
                                  if (val == null || val.isEmpty) {
                                    return 'Please select variant';
                                  }
                                  return null;
                                },
                                prefixIcon: Icons.widgets_outlined,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: WebTextFields(
                                label: 'Variant (Optional)',
                                hintText: selectedCategoryId == null
                                    ? 'Select category'
                                    : 'Select variant',
                                isDropdown: true,
                                dropdownItems: variants1.map((vari) {
                                  return DropdownMenuItem<String>(
                                    value: vari,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(vari),
                                        IconButton(
                                            onPressed: () {
                                              showDeleteVariantDialog(
                                                  context, vari);
                                            },
                                            icon: Icon(
                                              Icons.cancel,
                                              color: AppColors.red,
                                            ))
                                      ],
                                    ),
                                  );
                                }).toList(),
                                selectedItemBuilder: (context) {
                                  return variants1.map((variant) {
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        variant,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList();
                                },
                                selectedValue: selectedVariant[1].isNotEmpty
                                    ? selectedVariant[1]
                                    : null,
                                onDropdownChanged: (val) {
                                  setState(() {
                                    selectedVariant[1] = val ?? '';
                                  });
                                },
                                validator: (val) {
                                  return null;
                                },
                                prefixIcon: Icons.widgets_outlined,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: IconButton(
                                onPressed: () {
                                  if (selectedCategoryId == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Please select a category first"),
                                      ),
                                    );
                                    return;
                                  }
                                  _showAddVariantDialog(context);
                                },
                                icon: const Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.blue,
                                ),
                                tooltip: 'Add new variant',
                              ),
                            )
                          ],
                        ),
                      ],
                    );
                  }))
                ]),
                //--------
                const SizedBox(height: 20),
                //----------------------------Quantity
                Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                   
                      width: MediaQuery.of(context).size.width*0.42,
                      child: WebTextField(
                        label: 'Stock',
                        hintText: 'Enter product quantity',
                        controller: _stockKey,
                        keyboardType: const TextInputType.numberWithOptions(),
                        validator: ProductTextValidators.stock,
                      ),
                    ),
                    Row(
                                          
                                          children: [
                    const Text('Status:'),
                    const SizedBox(width: 8),
                    Switch(
                      focusColor: Colors.green,
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

                const SizedBox(height: 20),
                //-------------------       Image field
                imageAddingSection(
                    isUploading: isUploading,
                    imageUrls: imageUrls,
                    onPickImage: (index) => _pickImage(index),
                    onRemoveImage: (index) {
                      setState(() {
                        imageUrls[index] = '';
                      });
                    }),

                //--------

                const SizedBox(height: 40),
                Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SecondaryButton(
                          label: 'Cancel',
                          onPressed: () {
                            context.go('/products');
                          },
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        elevatedButtonForSave(
                            text:
                                isEditMode ? 'Update Product' : 'Save Product',
                            onPressed: () {
                              if (imageUrls.isEmpty || imageUrls[0].isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Please atleast 1 image')),
                                );
                                return;
                              }
                              if (!_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Please fill all required fields')),
                                );
                                return;
                              }
                              if (double.parse(_mrp.text) <=
                                  double.parse(_price.text)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Please try to add price more than actual price')),
                                );
                                return;
                              }
                              if (selectedCategoryId == null ||
                                  selectedCategoryId!.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Please select a category')),
                                );
                                return;
                              }
                              if (selectedBrandId == null ||
                                  selectedBrandId!.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Please select a brand')),
                                );
                                return;
                              }
                              if (selectedVariant.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Please select a variant')),
                                );
                                return;
                              }
                              if (_formKey.currentState!.validate()) {
                                final product = AddProductEntity(
                                  id: isEditMode
                                      ? productId!
                                      : const Uuid().v4(),
                                  name: _productName.text.trim(),
                                  price: double.tryParse(_price.text.trim()) ??
                                      0.0,
                                  mrp: double.tryParse(_mrp.text.trim()) ?? 0.0,
                                  description: _description.text.trim(),
                                  category: selectedCategoryId!,
                                  brand: selectedBrandId!,
                                  quantity:
                                      double.tryParse(_stockKey.text.trim()) ??
                                          0.0,
                                  variant: selectedVariant,
                                  imageUrls: imageUrls,
                                  createdAt: DateTime.now(),
                                  features: false,
                                  status: _status,
                                );
                                if (isEditMode) {
                                  context
                                      .read<ProductBloc>()
                                      .add(UpdatingProductEvent(product));
                                } else {
                                  context
                                      .read<ProductBloc>()
                                      .add(AddingProductEvent(product));
                                }

                                _formKey.currentState!.reset();
                                if (!isEditMode) {
                                  setState(() {
                                    imageUrls = ["", ""];
                                    _productName.clear();
                                    _price.clear();
                                    _mrp.clear();
                                    _description.clear();
                                    _stockKey.clear();
                                    selectedBrandId = null;
                                    selectedCategoryId = null;
                                    selectedVariant = ['', ''];
                                  });
                                }
                                context.go('/products');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(isEditMode
                                        ? 'Product updating successful'
                                        : 'Product added successfully'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            }),
                      ],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _productName.dispose();
    _price.dispose();
    _description.dispose();
    _stockKey.dispose();
    super.dispose();
  }

  // add new variant show dialoge
  void _showAddVariantDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Add New Variant"),
          content: SizedBox(
            width: 400,
            child: TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Enter variant name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.dispose();
                Navigator.of(dialogContext).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final newVariant = controller.text.trim();

                if (newVariant.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter a variant name"),
                    ),
                  );
                  return;
                }

                if (selectedCategoryId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please select a category first"),
                    ),
                  );
                  return;
                }

                context.read<CategoryBloc>().add(
                      AddVariantEvent(selectedCategoryId!, newVariant),
                    );

                controller.dispose();
                Navigator.of(dialogContext).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Variant added successfully"),
                  ),
                );
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    ).then((_) {
      controller.dispose();
    });
  }

  //Delete variant :

  void showDeleteVariantDialog(BuildContext context, String variant) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Delete Variant"),
          content: Text("Are you sure you want to delete '$variant'?"),
          actions: [
            SecondaryButton(
                label: 'cancel',
                onPressed: () => Navigator.of(dialogContext).pop()),
            DangerButton(
                label: 'Delete',
                onPressed: () {
                  context.read<CategoryBloc>().add(
                        DeleteVariantEvent(selectedCategoryId!, variant),
                      );

                  Navigator.of(dialogContext).pop();

                  setState(() {
                    if (selectedVariant.contains(variant)) {
                      selectedVariant = ['', ''];
                    }
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Variant deleted successfully")),
                  );
                })
          ],
        );
      },
    );
  }

  List<String> sortVariant(List<String> variants) {
    final sortedVariants = variants.toList();

    sortedVariants.sort((a, b) {
      final numA = int.tryParse(a.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      final numB = int.tryParse(b.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      return numA.compareTo(numB);
    });

    return sortedVariants;
  }
}
