// ignore_for_file: use_build_context_synchronously, prefer_final_fields

import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/core/theme/appcolor.dart';
import 'package:rizqmartadmin/features/data/models/add_product_model.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/category/category_bloc.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/category/category_event.dart';
import 'package:rizqmartadmin/features/presentation/cubit/products/form_cubit.dart';
import 'package:rizqmartadmin/features/presentation/cubit/products/form_cubit_state.dart';
import 'package:rizqmartadmin/features/presentation/pages/main/products/widgets/fields_products.dart';
import 'package:rizqmartadmin/features/presentation/validators/text_field_validator.dart';
import 'package:rizqmartadmin/features/presentation/widgets/buttons/buttons.dart';
import 'package:rizqmartadmin/features/presentation/pages/main/products/product_form_logic.dart';
import 'package:rizqmartadmin/features/presentation/pages/main/products/widgets/product_classification.dart';
import 'package:rizqmartadmin/features/presentation/pages/main/products/widgets/product_variant_section.dart';

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
          ProductFormLogic.setupEditMode(
            context: context,
            product: widget.model!,
            productNameController: _productName,
            descriptionController: _description,
            formCubit: _formCubit,
          );
        });
      }
    }
  
  // Custom Card Wrapper for the new form aesthetic
  Widget _buildFormCard(BuildContext context, {required String title, required IconData icon, required Widget child}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: theme.colorScheme.primary, size: 20),
              ),
              12.w,
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
          24.h,
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocProvider.value(
      value: _formCubit,
      child: BlocBuilder<FormCubit, FormCubitState>(
        builder: (context, formState) {
          return SizedBox(
            width: double.infinity,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch, // Allow cards to span full width of the container
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          formState.isEditMode ? Icons.edit_note_rounded : Icons.add_box_rounded,
                          color: theme.colorScheme.primary,
                          size: 28,
                        ),
                      ),
                      20.w,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formState.isEditMode ? 'Edit Product' : 'Add New Product',
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: theme.textTheme.bodyLarge?.color,
                              letterSpacing: -0.5,
                            ),
                          ),
                          4.h,
                          Text(
                            formState.isEditMode ? 'Update product details and variants.' : 'Create a new product for the catalog.',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: theme.textTheme.bodySmall?.color,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  40.h,
                  
                  // ---------------- Basic Information Section ----------------
                  _buildFormCard(
                    context,
                    title: 'Basic Information',
                    icon: Icons.info_outline_rounded,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WebTextField(
                          label: 'Product name',
                          hintText: 'e.g. Premium Organic Apples',
                          controller: _productName,
                          keyboardType: TextInputType.name,
                          maxLines: 1,
                          validator: ProductTextValidators.name,
                        ),
                        20.h,
                        WebTextArea( // Assumes this uses a similar styled decoration internally
                          label: 'Description',
                          hintText: 'Enter a detailed product description...',
                          controller: _description,
                          maxLines: 6,
                          validator: ProductTextValidators.description,
                        ),
                      ],
                    ),
                  ),

                  // ---------------- Classification Section ----------------
                  _buildFormCard(
                    context,
                    title: 'Classification',
                    icon: Icons.category_outlined,
                    child: Wrap(
                      spacing: 24,
                      runSpacing: 24,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        ProductBrandSection(formState: formState),
                        ProductCategorySection(formState: formState),
                        ProductStatusSection(formState: formState),
                      ],
                    ),
                  ),

                  // ---------------- Variants Section ----------------
                  if (formState.selectedCategoryId != null && formState.selectedCategoryId!.isNotEmpty)
                    _buildFormCard(
                      context,
                      title: 'Pricing & Variants',
                      icon: Icons.style_outlined,
                      child: ProductVariantSection(formState: formState),
                    ),
                  
                  40.h,
                  // ---------------- Form Actions Footer ----------------
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                    decoration: BoxDecoration(
                      color: theme.cardTheme.color,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: theme.dividerColor.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () => context.go('/products'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.2)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              color: theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                        ),
                        16.w,
                        elevatedButtonForSave( // Keeps your existing widget but ideally we'd restyle it if we had the code
                          text: formState.isEditMode ? 'Update Product' : 'Save Product',
                          onPressed: () => ProductFormLogic.handleSaveProduct(
                            context: context,
                            formKey: _formKey,
                            formCubit: _formCubit,
                            formState: formState,
                            productNameController: _productName,
                            descriptionController: _description,
                            originalModel: widget.model,
                          ),
                        ),
                      ],
                    ),
                  ),
                  40.h,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /*
  // Adjusted to drop strict width constraints so it flows in the Wrap
  Widget buildBrandSection(FormCubitState formState) {
    return BlocBuilder<BrandBloc, BrandState>(
      builder: (context, state) {
        List<DropdownMenuItem<String>> brandItems = [];

        if (state is BrandLoadingState) {
          return const SizedBox(width: 250, child: Center(child: CircularProgressIndicator()));
        } else if (state is BrandLoadedState) {
          brandItems = state.brand.map((brand) {
            return DropdownMenuItem<String>(
              value: brand.name,
              child: Text(brand.name),
            );
          }).toList();
        } else if (state is BrandFailureState) {
          return const SizedBox(width: 250, child: Center(child: Text('Failed to load brands')));
        }

        return SizedBox(
          width: 320, // Specific width for Wrap layout
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

  // Adjusted to drop strict width constraints so it flows in the Wrap
  Widget buildCategorySection(FormCubitState formState) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        List<DropdownMenuItem<String>> categoryItems = [];

        if (state is CategoryLoadingState) {
           return const SizedBox(width: 250, child: Center(child: CircularProgressIndicator()));
        } else if (state is CategoryLoadedState) {
          categoryItems = state.cotegories.map((cat) {
            return DropdownMenuItem<String>(
              value: cat.id,
              child: Text(cat.name),
            );
          }).toList();
        } else if (state is CategoryFailureState) {
          return const SizedBox(width: 250, child: Center(child: Text('Failed to load categories')));
        }

        return SizedBox(
          width: 320, // Specific width for Wrap layout
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
            prefixIcon: Icons.category_outlined,
          ),
        );
      },
    );
  }

  Widget buildStatusSection(FormCubitState formState) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Visibility Status',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          4.h,
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formState.status ? 'Active' : 'Hidden',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: formState.status ? AppColors.matGreen : theme.hintColor,
                ),
              ),
              8.w,
              Switch(
                value: formState.status,
                activeColor: AppColors.matGreen,
                onChanged: (val) {
                  _formCubit.toggleStatus();
                },
              ),
            ],
          ),
        ],
      ),
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
          return const Center(child: Padding(
            padding: EdgeInsets.all(24.0),
            child: CircularProgressIndicator(),
          ));
        } else if (state is UnitFailureState) {
          return Center(child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text('Error loading variants: ${state.message}'),
          ));
        } else if (state is UnitLoadedState) {
          final displayUnits = formState.currentUnits.isEmpty ? state.unit : formState.currentUnits;

          if (displayUnits.isEmpty) {
            return const Center(child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Text('No variants available for this category'),
            ));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'This category requires ${displayUnits.length} volume variants. Please set pricing and upload images for at least one to activate the product.',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.primary,
                    height: 1.5,
                  ),
                ),
              ),
              24.h,
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayUnits.length,
                separatorBuilder: (context, index) => 16.h,
                itemBuilder: (context, index) {
                  return buildVariantCard(index, displayUnits[index], formState);
                },
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget buildVariantCard(int index, UnitsEntity unit, FormCubitState formState) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3) : AppColors.white,
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.15)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Variant ${index + 1}',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ),
              12.w,
              Text(
                '${unit.unitName} (${unit.wieght}${unit.unitType})',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
          20.h,
          LayoutBuilder(
            builder: (context, constraints) {
              // Stack fields vertically if constraint width is too small (e.g. tablet portrait)
              if (constraints.maxWidth < 600) {
                 return Column(
                  children: [
                     TextFormField(
                       decoration: InputDecoration(
                         labelText: 'Regular Price (₹)',
                         hintText: 'e.g., 50',
                         border: const OutlineInputBorder(),
                         labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
                       ),
                       style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                       keyboardType: TextInputType.number,
                       initialValue: formState.variantPrices[index] ?? '',
                       onChanged: (value) => _formCubit.updateVariantPrice(index, value),
                     ),
                     16.h,
                     TextFormField(
                       decoration: InputDecoration(
                         labelText: 'Selling Price (₹)',
                         hintText: 'e.g., 40',
                         border: const OutlineInputBorder(),
                         labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
                       ),
                       style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                       keyboardType: TextInputType.number,
                       initialValue: formState.variantMrps[index] ?? '',
                       onChanged: (value) => _formCubit.updateVariantMrp(index, value),
                     ),
                     16.h,
                     TextFormField(
                       decoration: InputDecoration(
                         labelText: 'Stock Qty',
                         hintText: 'e.g., 100',
                         border: const OutlineInputBorder(),
                         labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
                       ),
                       style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                       keyboardType: TextInputType.number,
                       initialValue: formState.variantStocks[index] ?? '',
                       onChanged: (value) => _formCubit.updateVariantStock(index, value),
                     ),
                     24.h,
                     buildVariantImages(index, formState),
                  ],
                 );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Regular Price (₹)',
                            hintText: 'e.g. 50',
                            filled: true,
                            fillColor: theme.colorScheme.surface,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
                          ),
                          style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                          keyboardType: TextInputType.number,
                          initialValue: formState.variantPrices[index] ?? '',
                          onChanged: (value) => _formCubit.updateVariantPrice(index, value),
                        ),
                        16.h,
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Selling Price MSRP (₹)',
                            hintText: 'e.g. 40',
                            filled: true,
                            fillColor: theme.colorScheme.surface,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
                          ),
                          style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                          keyboardType: TextInputType.number,
                          initialValue: formState.variantMrps[index] ?? '',
                          onChanged: (value) => _formCubit.updateVariantMrp(index, value),
                        ),
                        16.h,
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Stock Qty',
                            hintText: 'e.g. 100',
                            filled: true,
                            fillColor: theme.colorScheme.surface,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
                          ),
                          style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                          keyboardType: TextInputType.number,
                          initialValue: formState.variantStocks[index] ?? '',
                          onChanged: (value) => _formCubit.updateVariantStock(index, value),
                        ),
                      ],
                    ),
                  ),
                  24.w,
                  Expanded(
                    flex: 6,
                    child: buildVariantImages(index, formState),
                  ),
                ],
              );
            }
          ),
        ],
      ),
    );
  }

  Widget buildVariantImages(int variantIndex, FormCubitState formState) {
    final theme = Theme.of(context);
    final images = formState.variantImageUrls[variantIndex] ?? ['', '', ''];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Images (Max 3)',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13, color: theme.hintColor),
        ),
        12.h,
        Row(
          children: List.generate(3, (imageIndex) {
            final imageUrl = imageIndex < images.length ? images[imageIndex] : '';
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => ProductFormLogic.pickVariantImage(
                    context: context,
                    formCubit: _formCubit,
                    variantIndex: variantIndex,
                    imageIndex: imageIndex,
                  ),
                  child: Container(
                    height: 120, // Taller for better preview
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
                      border: Border.all(
                        color: imageUrl.isEmpty ? theme.dividerColor : theme.colorScheme.primary.withValues(alpha: 0.5),
                        style: imageUrl.isEmpty ? BorderStyle.solid : BorderStyle.solid, // Removed dashed to prevent custom painter need
                        width: imageUrl.isEmpty ? 1 : 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: imageUrl.isNotEmpty
                        ? Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10), // inner radius
                                child: ShimmerImage(
                                  imageUrl: imageUrl,
                                  fit: BoxFit.cover,
                                  borderRadius: 0,
                                ),
                              ),
                              Positioned(
                                top: 6,
                                right: 6,
                                child: GestureDetector(
                                  onTap: () {
                                    _formCubit.removeVariantImage(variantIndex, imageIndex);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.6),
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(6),
                                    child: const Icon(
                                      Icons.close_rounded,
                                      color: AppColors.white,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const EmptyImagePlaceholder(
                            text: 'Upload',
                            iconSize: 28,
                            type: PlaceholderType.product,
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
  */

  @override
  void dispose() {
    _productName.dispose();
    _description.dispose();
    _formCubit.close();
    super.dispose();
  }
}