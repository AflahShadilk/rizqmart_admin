// ignore_for_file: unnecessary_null_comparison, deprecated_member_use

import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/brand_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/brand/brand_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/brand/brand_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/brand/add_brand_form_web.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/brand/delete_config.dart';
import 'package:rizqmartadmin/widgets/animated_hover_card.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/image/shimmer_image.dart';

// ─── Grid Card ───────────────────────────────────────────────────────────────
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

  // ignore: unused_element
  Widget _actionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        constraints: const BoxConstraints(),
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: color, size: 15),
        onPressed: onTap,
        tooltip: tooltip,
      ),
    );
  }
}

// ─── List Card ───────────────────────────────────────────────────────────────
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
                  color: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.3),
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
                          color: theme.colorScheme.primary
                              .withValues(alpha: 0.5),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: brand.status
                                ? AppColors.emerald.withValues(alpha: 0.1)
                                : AppColors.chartRed
                                    .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                brand.status
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color: brand.status
                                    ? AppColors.emerald
                                    : AppColors.chartRed,
                                size: 14,
                              ),
                              4.w,
                              Text(
                                brand.status ? 'Active' : 'Inactive',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: brand.status
                                      ? AppColors.emerald
                                      : AppColors.chartRed,
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
                  icon: const Icon(Icons.edit_rounded,
                      color: AppColors.chartBlue, size: 16),
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
                  icon: const Icon(Icons.delete_outline_rounded,
                      color: AppColors.chartRed, size: 16),
                  onPressed: onDelete,
                  tooltip: 'Delete Brand',
                ),
              ),
            ],
          ),
    );
  }
}

// Keep backward-compatible class name for any references
class BrandCardWeb extends StatelessWidget {
  final BrandEntity? brand;
  const BrandCardWeb({super.key, this.brand});

  @override
  Widget build(BuildContext context) {
    if (brand == null) return const SizedBox();
    return BrandListCard(
      brand: brand!,
      onEdit: () {
        final brandState = BlocProvider.of<BrandBloc>(context).state;
        final brandList = brandState is BrandLoadedState
            ? (brandState).brand.cast<BrandEntity>()
            : <BrandEntity>[];
        showDialog(
          context: context,
          builder: (_) => BlocProvider.value(
            value: BlocProvider.of<BrandBloc>(context),
            child: AddBrandFormWeb(brands: brand, brandslist: brandList),
          ),
        );
      },
      onDelete: () => handleDelete(context, brand!),
    );
  }
}
