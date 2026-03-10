// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/product_model.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/brand/brand_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/category/category_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/product/product_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/image/shimmer_image.dart';

class ProductGridCard extends StatelessWidget {
  final AddProductEntity product;
  final ProductState categoryState;
  final ProductState brandState;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(String, CategoryState) getCategoryName;
  final Function(String, BrandState) getBrandName;

  const ProductGridCard({
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
    
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
            // ---------------- Image Section Top ----------------
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: getFirstVariantImage().isNotEmpty
                          ? SizedBox.expand(
                              child: ShimmerImage(
                                imageUrl: getFirstVariantImage(),
                                width: double.infinity,
                                height: double.infinity,
                                borderRadius: 0, 
                              ),
                            )
                          : Center(
                              child: Icon(
                                Icons.inventory_2_outlined, 
                                size: 40, 
                                color: AppColors.grey.withValues(alpha: 0.5)
                              ),
                            ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: product.status == true
                            ? AppColors.matGreen.withValues(alpha: 0.9)
                            : AppColors.matRed.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        product.status == true ? 'Active' : 'Inactive',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // ---------------- Details Section Bottom ----------------
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: theme.textTheme.bodyLarge?.color,
                        height: 1.2,
                        fontFamily: 'Inter',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: theme.dividerColor.withValues(alpha:0.1)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.inventory_outlined, size: 12, color: theme.textTheme.bodySmall?.color),
                          4.w,
                          Text(
                            'Stock: ${getTotalQuantity().toInt()}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: theme.textTheme.bodySmall?.color,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                    8.h,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Text(
                            '₹${getFirstVariantPrice().toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.emerald,
                              fontFamily: 'Inter',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // ---------------- Action Buttons Smaller for Grid ----------------
                        Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: AppColors.chartBlue.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.edit_rounded, color: AppColors.chartBlue, size: 14),
                                onPressed: onEdit,
                                tooltip: 'Edit Product',
                              ),
                            ),
                            4.w,
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: AppColors.chartRed.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.chartRed, size: 14),
                                onPressed: onDelete,
                                tooltip: 'Delete Product',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
    );
  }
}
