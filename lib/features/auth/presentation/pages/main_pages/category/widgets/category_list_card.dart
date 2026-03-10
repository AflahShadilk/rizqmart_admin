import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/category_model.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/image/shimmer_image.dart';
import 'package:rizqmartadmin/widgets/animated_hover_card.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';

class CategoryListCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryListCard({
    super.key,
    required this.category,
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
              color: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.3),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: category.logoUrl != null && category.logoUrl!.isNotEmpty
                  ? ShimmerImage(
                      imageUrl: category.logoUrl!,
                      width: 60,
                      height: 60,
                      borderRadius: 0,
                    )
                  : Icon(
                      Icons.category_rounded,
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
                  category.name,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (category.variants != null &&
                    category.variants!.isNotEmpty) ...[
                  4.h,
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color:
                          theme.colorScheme.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${category.variants!.length} ${category.variants!.length == 1 ? 'variant' : 'variants'}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ),
                ],
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
              icon: const Icon(Icons.edit_rounded,
                  color: AppColors.chartBlue, size: 16),
              onPressed: onEdit,
              tooltip: 'Edit Category',
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
              icon: const Icon(Icons.delete_outline_rounded,
                  color: AppColors.chartRed, size: 16),
              onPressed: onDelete,
              tooltip: 'Delete Category',
            ),
          ),
        ],
      ),
    );
  }
}
