// ignore_for_file: unnecessary_null_comparison

import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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

    return AnimatedHoverCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
            // Image area
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.3),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: brand.logourl.isNotEmpty
                      ? ShimmerImage(
                          imageUrl: brand.logourl,
                          fit: BoxFit.cover,
                          borderRadius: 0,
                        )
                      : Center(
                          child: Icon(
                            Icons.branding_watermark_rounded,
                            size: 40,
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.4),
                          ),
                        ),
                ),
              ),
            ),
            // Info area
            Expanded(
              flex: 2,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      brand.name,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.h,
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: brand.status
                            ? AppColors.emerald.withValues(alpha: 0.1)
                            : AppColors.chartRed.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        brand.status ? 'Active' : 'Inactive',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: brand.status
                              ? AppColors.emerald
                              : AppColors.chartRed,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _actionButton(
                          icon: Icons.edit_rounded,
                          color: AppColors.chartBlue,
                          onTap: onEdit,
                          tooltip: 'Edit',
                        ),
                        6.w,
                        _actionButton(
                          icon: Icons.delete_outline_rounded,
                          color: AppColors.chartRed,
                          onTap: onDelete,
                          tooltip: 'Delete',
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
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.bodyLarge?.color,
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
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: brand.status
                                      ? AppColors.emerald
                                      : AppColors.chartRed,
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
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: theme.textTheme.bodySmall?.color,
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
