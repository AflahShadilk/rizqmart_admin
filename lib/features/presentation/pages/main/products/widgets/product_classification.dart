import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/core/theme/appcolor.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/brand/brand_bloc.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/brand/brand_state.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/category/category_bloc.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/category/category_state.dart';
import 'package:rizqmartadmin/features/presentation/cubit/products/form_cubit.dart';
import 'package:rizqmartadmin/features/presentation/cubit/products/form_cubit_state.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/unit/unit_bloc.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/unit/unit_event.dart';
import 'package:rizqmartadmin/features/presentation/pages/main/products/widgets/fields_products.dart';

// ---------------- Product Brand Section ----------------
class ProductBrandSection extends StatelessWidget {
  final FormCubitState formState;
  
  const ProductBrandSection({super.key, required this.formState});

  @override
  Widget build(BuildContext context) {
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
          width: 320, 
          child: WebTextFields(
            label: 'Brand',
            hintText: 'Select Brand',
            isDropdown: true,
            dropdownItems: brandItems,
            selectedValue: formState.selectedBrandId,
            onDropdownChanged: (value) {
              context.read<FormCubit>().selectBrand(value!);
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
}

// ---------------- Product Category Section ----------------
class ProductCategorySection extends StatelessWidget {
  final FormCubitState formState;

  const ProductCategorySection({super.key, required this.formState});

  @override
  Widget build(BuildContext context) {
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
          width: 320, 
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
                  context.read<FormCubit>().selectCategory(value!);
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
}

// ---------------- Product Status Section ----------------
class ProductStatusSection extends StatelessWidget {
  final FormCubitState formState;

  const ProductStatusSection({super.key, required this.formState});

  @override
  Widget build(BuildContext context) {
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
                  context.read<FormCubit>().toggleStatus();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
