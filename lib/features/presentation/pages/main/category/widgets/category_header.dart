import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/core/theme/appcolor.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:rizqmartadmin/features/domain/entities/main/category_model.dart';
import 'package:rizqmartadmin/features/presentation/widgets/common/grid_list_toggle.dart';
import 'package:rizqmartadmin/features/presentation/cubit/category/category_cubit.dart';
import 'package:rizqmartadmin/features/presentation/cubit/category/category_state.dart';

class CategoryHeader extends StatelessWidget {
  final List<CategoryModel> categories;
  final Widget addButton;

  const CategoryHeader({
    super.key,
    required this.categories,
    required this.addButton,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, headerConstraints) {
          final isCompact = headerConstraints.maxWidth < 600;

          final icon = Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.amber.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.category_rounded,
              color: AppColors.amber,
              size: 28,
            ),
          );

          final titleColumn = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Categories',
                style: GoogleFonts.inter(
                  fontSize: isCompact ? 20 : 24,
                  fontWeight: FontWeight.w700,
                  color: theme.textTheme.bodyLarge?.color,
                  letterSpacing: -0.5,
                ),
              ),
              4.h,
              Text(
                '${categories.length} ${categories.length == 1 ? 'category' : 'categories'} available',
                style: GoogleFonts.inter(
                  fontSize: isCompact ? 12 : 14,
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
            ],
          );

          final toggleButtons = BlocBuilder<CategoryLayoutCubit, CategoryLayoutState>(
            builder: (context, state) {
              return GridListToggle(
                isGridView: state.isGridView,
                onToggle: (isGrid) {
                  context.read<CategoryLayoutCubit>().toggleViewMode(isGrid);
                },
              );
            },
          );

          if (isCompact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    icon,
                    16.w,
                    Expanded(child: titleColumn),
                  ],
                ),
                16.h,
                Row(
                  children: [
                    toggleButtons,
                    const Spacer(),
                    addButton,
                  ],
                ),
              ],
            );
          }

          return Row(
            children: [
              icon,
              20.w,
              Expanded(child: titleColumn),
              toggleButtons,
              16.w,
              addButton,
            ],
          );
        },
      ),
    );
  }
}
