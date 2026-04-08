// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:rizqmartadmin/core/theme/appcolor.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:rizqmartadmin/features/domain/entities/main/brand_entity.dart';
import 'package:rizqmartadmin/features/presentation/widgets/common/animated_hover_card.dart';
import 'package:rizqmartadmin/features/presentation/widgets/image/shimmer_image.dart';

class BrandListCard extends StatelessWidget {
  final BrandEntity brand;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BrandListCard({
    super.key,
    required this.brand,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedHoverCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: brand.logourl.isNotEmpty
                  ? ShimmerImage(
                      imageUrl: brand.logourl,
                      width: 60,
                      height: 60,
                      borderRadius: 0,
                    )
                  : Icon(
                      Icons.branding_watermark_rounded,
                      size: 28,
                      color: theme.colorScheme.primary.withValues(alpha: 0.5),
                    ),
            ),
          ),
          16.w,
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  brand.name,
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: brand.status
                            ? AppColors.emerald.withValues(alpha: 0.1)
                            : AppColors.chartRed.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            brand.status ? Icons.check_circle : Icons.cancel,
                            color: brand.status ? AppColors.emerald : AppColors.chartRed,
                            size: 14,
                          ),
                          4.w,
                          Text(
                            brand.status ? 'Active' : 'Inactive',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: brand.status ? AppColors.emerald : AppColors.chartRed,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (brand.description.isNotEmpty) ...[
                      8.w,
                      Flexible(
                        child: Text(
                          brand.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.textTheme.bodySmall?.color,
                            fontFamily: 'Inter',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // Actions
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.chartBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.edit_rounded, color: AppColors.chartBlue, size: 16),
              onPressed: onEdit,
              tooltip: 'Edit Brand',
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
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.delete_outline_rounded, color: AppColors.chartRed, size: 16),
              onPressed: onDelete,
              tooltip: 'Delete Brand',
            ),
          ),
        ],
      ),
    );
  }
}
