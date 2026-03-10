// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/brand_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/image/shimmer_image.dart';

class BrandGridCard extends StatelessWidget {
  final BrandEntity brand;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BrandGridCard({
    super.key,
    required this.brand,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image area
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: brand.logourl.isNotEmpty
                    ? SizedBox.expand(
                        child: ShimmerImage(
                          imageUrl: brand.logourl,
                          fit: BoxFit.cover,
                          borderRadius: 0,
                        ),
                      )
                    : Center(
                        child: Icon(
                          Icons.branding_watermark_rounded,
                          size: 40,
                          color: AppColors.grey.withValues(alpha: 0.5),
                        ),
                      ),
              ),
            ),
          ),
          // Info area
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    brand.name,
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
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: brand.status
                          ? AppColors.emerald.withValues(alpha: 0.1)
                          : AppColors.chartRed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      brand.status ? 'Active' : 'Inactive',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: brand.status ? AppColors.emerald : AppColors.chartRed,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  8.h,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
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
                          tooltip: 'Edit Brand',
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
                          tooltip: 'Delete Brand',
                        ),
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
