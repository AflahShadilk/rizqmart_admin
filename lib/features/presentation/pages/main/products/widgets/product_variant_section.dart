import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/core/theme/appcolor.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:rizqmartadmin/features/domain/entities/main/units_entity.dart';
import 'package:rizqmartadmin/features/presentation/cubit/products/form_cubit.dart';
import 'package:rizqmartadmin/features/presentation/cubit/products/form_cubit_state.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/unit/unit_bloc.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/unit/unit_state.dart';
import 'package:rizqmartadmin/features/presentation/pages/main/products/product_form_logic.dart';
import 'package:rizqmartadmin/features/presentation/widgets/image/empty_image_placeholder.dart';
import 'package:rizqmartadmin/features/presentation/widgets/image/shimmer_image.dart';

// ---------------- Product Variant Section ----------------
class ProductVariantSection extends StatelessWidget {
  final FormCubitState formState;

  const ProductVariantSection({super.key, required this.formState});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UnitBloc, UnitState>(
      listener: (context, state) {
        if (state is UnitLoadedState && !formState.isEditMode) {
          context.read<FormCubit>().initializeVariants(state.unit);
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
                  return ProductVariantCard(
                    index: index, 
                    unit: displayUnits[index], 
                    formState: formState,
                  );
                },
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// ---------------- Product Variant Card ----------------
class ProductVariantCard extends StatelessWidget {
  final int index;
  final UnitsEntity unit;
  final FormCubitState formState;

  const ProductVariantCard({
    super.key,
    required this.index,
    required this.unit,
    required this.formState,
  });

  @override
  Widget build(BuildContext context) {
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
                       onChanged: (value) => context.read<FormCubit>().updateVariantPrice(index, value),
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
                       onChanged: (value) => context.read<FormCubit>().updateVariantMrp(index, value),
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
                       onChanged: (value) => context.read<FormCubit>().updateVariantStock(index, value),
                     ),
                     24.h,
                     ProductVariantImages(variantIndex: index, formState: formState),
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
                          onChanged: (value) => context.read<FormCubit>().updateVariantPrice(index, value),
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
                          onChanged: (value) => context.read<FormCubit>().updateVariantMrp(index, value),
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
                          onChanged: (value) => context.read<FormCubit>().updateVariantStock(index, value),
                        ),
                      ],
                    ),
                  ),
                  24.w,
                  Expanded(
                    flex: 6,
                    child: ProductVariantImages(variantIndex: index, formState: formState),
                  ),
                ],
              );
            }
          ),
        ],
      ),
    );
  }
}

// ---------------- Product Variant Images ----------------
class ProductVariantImages extends StatelessWidget {
  final int variantIndex;
  final FormCubitState formState;

  const ProductVariantImages({
    super.key,
    required this.variantIndex,
    required this.formState,
  });

  @override
  Widget build(BuildContext context) {
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
                    formCubit: context.read<FormCubit>(),
                    variantIndex: variantIndex,
                    imageIndex: imageIndex,
                  ),
                  child: Container(
                    height: 120, 
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
                      border: Border.all(
                        color: imageUrl.isEmpty ? theme.dividerColor : theme.colorScheme.primary.withValues(alpha: 0.5),
                        style: imageUrl.isEmpty ? BorderStyle.solid : BorderStyle.solid, 
                        width: imageUrl.isEmpty ? 1 : 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: imageUrl.isNotEmpty
                        ? Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10), 
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
                                    context.read<FormCubit>().removeVariantImage(variantIndex, imageIndex);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.black.withValues(alpha: 0.6),
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
}
