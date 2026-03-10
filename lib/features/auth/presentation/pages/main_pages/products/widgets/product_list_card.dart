// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/product_model.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/brand/brand_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/category/category_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/product/product_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/image/shimmer_image.dart';

class ProductListCard extends StatelessWidget {
  final AddProductEntity product;
  final ProductState categoryState;
  final ProductState brandState;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(String, CategoryState) getCategoryName;
  final Function(String, BrandState) getBrandName;

  const ProductListCard({
    super.key,
    required this.product,
    required this.categoryState,
    required this.brandState,
    required this.onEdit,
    required this.onDelete,
    required this.getCategoryName,
    required this.getBrandName,
  });

  String getFirstVariantImage() {
    if (product.variantDetails != null && product.variantDetails!.isNotEmpty) {
      final imageUrls = product.variantDetails![0]['imageUrls'] as List?;
      if (imageUrls != null && imageUrls.isNotEmpty) {
        final firstImage = imageUrls.first;
        return (firstImage is String && firstImage.isNotEmpty) ? firstImage : '';
      }
    }
    return '';
  }

  double getFirstVariantPrice() {
    if (product.variantDetails != null && product.variantDetails!.isNotEmpty) {
      final price = product.variantDetails![0]['mrp'];
      return (price is num) ? price.toDouble() : 0.0;
    }
    return 0.0;
  }

  double getTotalQuantity() {
    if (product.variantDetails != null && product.variantDetails!.isNotEmpty) {
      double total = 0;
      for (var variant in product.variantDetails!) {
        final quantity = variant['quantity'];
        if (quantity is num) {
          total += quantity.toDouble();
        }
      }
      return total;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // ---------------- Product List Card Body ----------------
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: theme.colorScheme.surface,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: getFirstVariantImage().isNotEmpty
                      ? ShimmerImage(
                          imageUrl: getFirstVariantImage(),
                          width: 70,
                          height: 70,
                          borderRadius: 0,
                        )
                      : Icon(Icons.image_not_supported, size: 28, color: AppColors.grey.withValues(alpha: 0.5)),
                ),
              ),
              16.w,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.bodyLarge?.color,
                        fontFamily: 'Inter',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.h,
                    Row(
                      children: [
                        Text(
                          '₹${getFirstVariantPrice().toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.emerald,
                            fontFamily: 'Inter',
                          ),
                        ),
                        16.w,
                        Text(
                          'Stock: ${getTotalQuantity().toInt()}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: theme.textTheme.bodySmall?.color,
                            fontFamily: 'Inter',
                          ),
                        ),
                        16.w,
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: product.status == true
                                ? AppColors.matGreen.withValues(alpha: 0.1)
                                : AppColors.matRed.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            product.status == true ? 'Active' : 'Inactive',
                            style: TextStyle(
                              fontSize: 11,
                              color: product.status == true ? AppColors.matGreen : AppColors.matRed,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // ---------------- Action Buttons ----------------
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.chartBlue.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.edit_rounded, color: AppColors.chartBlue, size: 18),
                      onPressed: onEdit,
                      tooltip: 'Edit Product',
                    ),
                  ),
                  8.w,
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.chartRed.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.delete_outline_rounded, color: AppColors.chartRed, size: 18),
                      onPressed: onDelete,
                      tooltip: 'Delete Product',
                    ),
                  ),
                ],
              ),
            ],
          ),
    );
  }
}
