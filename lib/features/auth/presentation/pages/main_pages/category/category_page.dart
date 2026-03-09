// ignore_for_file: deprecated_member_use

import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/category_model.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/category/category_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/category/category_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/category/adding/category_cubit.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/category/adding/category_cubit_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/category/category_add_edit.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/category/delete_handle.dart';
import 'package:rizqmartadmin/widgets/animated_hover_card.dart';
import 'package:rizqmartadmin/widgets/global_add_button.dart';
import 'package:rizqmartadmin/widgets/grid_list_toggle.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/image/shimmer_image.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final TextEditingController _searchController = TextEditingController();
  late CategoryPageCubit _pageCubit;
  bool isGridView = true;

  @override
  void initState() {
    super.initState();
    _pageCubit = CategoryPageCubit();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageCubit.close();
    super.dispose();
  }

  List<CategoryModel> filterCategories(
    List<CategoryModel> categories,
    String query,
  ) {
    if (query.isEmpty) return categories;
    return categories
        .where((category) =>
            category.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void _showAddDialog(BuildContext context, List<CategoryModel> categories) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<CategoryBloc>(context),
        child: CategoryDialog(existingCategories: categories),
      ),
    );
  }

  void _showEditDialog(
      BuildContext context, List<CategoryModel> allCategories, CategoryModel category) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<CategoryBloc>(context),
        child: CategoryDialog(
          existingCategories: allCategories,
          existingCategory: category,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocProvider.value(
      value: _pageCubit,
      child: BlocConsumer<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state is CategorySuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.matGreen,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is CategoryFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: AppColors.matRed,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: BlocBuilder<CategoryPageCubit, CategoryPageState>(
              builder: (context, pageState) {
                if (state is CategoryLoadingState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: theme.colorScheme.primary,
                        ),
                        16.h,
                        Text(
                          'Loading categories...',
                          style: GoogleFonts.inter(
                            color: theme.textTheme.bodySmall?.color,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is CategoryLoadedState) {
                  final allCategories = state.cotegories;

                  if (allCategories.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.category_outlined,
                              size: 64,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          24.h,
                          Text(
                            'No categories yet',
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                          8.h,
                          Text(
                            'Start by adding your first category.',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              color: theme.textTheme.bodySmall?.color,
                            ),
                          ),
                          24.h,
                          _buildAddButton(context, allCategories, theme),
                        ],
                      ),
                    );
                  }

                  final displayCategories = filterCategories(
                      allCategories, pageState.searchQuery);

                  return Column(
                    children: [
                      // Modern Header Card
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 20),
                        margin: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: theme.cardTheme.color,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: theme.colorScheme.outline
                                .withValues(alpha: 0.1),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black
                                  .withValues(alpha: isDark ? 0.2 : 0.04),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: LayoutBuilder(
                          builder: (context, headerConstraints) {
                            final isCompact =
                                headerConstraints.maxWidth < 600;

                            final icon = Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.amber
                                    .withValues(alpha: 0.15),
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
                                    color:
                                        theme.textTheme.bodyLarge?.color,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                4.h,
                                Text(
                                  '${allCategories.length} ${allCategories.length == 1 ? 'category' : 'categories'} available',
                                  style: GoogleFonts.inter(
                                    fontSize: isCompact ? 12 : 14,
                                    color:
                                        theme.textTheme.bodySmall?.color,
                                  ),
                                ),
                              ],
                            );

                            final toggleButtons = GridListToggle(
                              isGridView: isGridView,
                              onToggle: (isGrid) {
                                setState(() {
                                  isGridView = isGrid;
                                });
                              },
                            );

                            final addButton = _buildAddButton(
                                context, allCategories, theme);

                            if (isCompact) {
                              return Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
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
                      ),

                      // Search Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.cardTheme.color,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: theme.colorScheme.outline
                                  .withValues(alpha: 0.1),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black
                                    .withValues(alpha: isDark ? 0.1 : 0.02),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              _pageCubit.updateSearchQuery(value);
                            },
                            style: GoogleFonts.inter(
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search categories...',
                              hintStyle: GoogleFonts.inter(
                                color: theme.hintColor,
                                fontSize: 14,
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: theme.hintColor,
                                size: 22,
                              ),
                              suffixIcon: pageState.searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.close_rounded,
                                        color: theme.hintColor,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        _searchController.clear();
                                        _pageCubit.clearSearch();
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      16.h,

                      // Content Area
                      Expanded(
                        child: displayCategories.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search_off_rounded,
                                      size: 64,
                                      color: theme.textTheme.bodySmall
                                          ?.color,
                                    ),
                                    16.h,
                                    Text(
                                      'No categories match "${pageState.searchQuery}"',
                                      style: GoogleFonts.inter(
                                        color: theme
                                            .textTheme.bodySmall?.color,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : LayoutBuilder(
                                builder: (context, constraints) {
                                  final isMobile = constraints.maxWidth < 768;

                                  if (!isGridView) {
                                    // List View
                                    return ListView.separated(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isMobile ? 16 : 24,
                                        vertical: 16,
                                      ),
                                      itemCount:
                                          displayCategories.length,
                                      separatorBuilder:
                                          (context, index) => SizedBox(height: isMobile ? 12 : 16),
                                      itemBuilder: (context, index) {
                                        final category =
                                            displayCategories[index];
                                        return Center(
                                          child: ConstrainedBox(
                                            constraints: const BoxConstraints(maxWidth: 900),
                                            child: CategoryListCard(
                                              category: category,
                                              onEdit: () => _showEditDialog(
                                                  context,
                                                  allCategories,
                                                  category),
                                              onDelete: () =>
                                                  handleDeleteCategory(
                                                      context, category),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }

                                  // Grid View Mode: Matches Product Page Sizing
                                  int crossAxisCount = 1;
                                  if (constraints.maxWidth > 1400) {
                                    crossAxisCount = 6;
                                  } else if (constraints.maxWidth > 1100) {
                                    crossAxisCount = 5;
                                  } else if (constraints.maxWidth > 800) {
                                    crossAxisCount = 4;
                                  } else if (constraints.maxWidth > 550) {
                                    crossAxisCount = 2;
                                  }

                                  return GridView.builder(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isMobile ? 16 : 24,
                                      vertical: 16,
                                    ),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      crossAxisSpacing: crossAxisCount == 1 ? 12 : 20,
                                      mainAxisSpacing: crossAxisCount == 1 ? 12 : 20,
                                      childAspectRatio: crossAxisCount == 1 ? 1.2 : 0.72,
                                    ),
                                    itemCount:
                                        displayCategories.length,
                                    itemBuilder: (context, index) {
                                      final category =
                                          displayCategories[index];
                                      return CategoryGridCard(
                                        category: category,
                                        onEdit: () => _showEditDialog(
                                            context,
                                            allCategories,
                                            category),
                                        onDelete: () =>
                                            handleDeleteCategory(
                                                context, category),
                                      );
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                } else if (state is CategoryFailureState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppColors.matRed.withValues(alpha: 0.8),
                        ),
                        20.h,
                        Text(
                          'Failed to load categories',
                          style: GoogleFonts.inter(
                            color: theme.textTheme.bodyLarge?.color,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        8.h,
                        Text(
                          state.error,
                          style: GoogleFonts.inter(
                            color: theme.textTheme.bodySmall?.color,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddButton(
      BuildContext context, List<CategoryModel> categories, ThemeData theme) {
    return GlobalAddButton(
      label: 'Add Category',
      onPressed: () => _showAddDialog(context, categories),
    );
  }
}

// ─── Grid Card ───────────────────────────────────────────────────────────────
class CategoryGridCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryGridCard({
    super.key,
    required this.category,
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
                child: category.logoUrl != null &&
                        category.logoUrl!.isNotEmpty
                    ? SizedBox.expand(
                        child: ShimmerImage(
                          imageUrl: category.logoUrl!,
                          fit: BoxFit.cover,
                          borderRadius: 0,
                        ),
                      )
                    : Center(
                        child: Icon(
                          Icons.category_rounded,
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
                    category.name,
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
                  if (category.variants != null &&
                      category.variants!.isNotEmpty) ...[
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
                            '${category.variants!.length} ${category.variants!.length == 1 ? 'variant' : 'variants'}',
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
                  ],
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
                          tooltip: 'Edit Category',
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
                          tooltip: 'Delete Category',
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

// ─── List Card ───────────────────────────────────────────────────────────────
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
                  child: category.logoUrl != null &&
                          category.logoUrl!.isNotEmpty
                      ? ShimmerImage(
                          imageUrl: category.logoUrl!,
                          width: 60,
                          height: 60,
                          borderRadius: 0,
                        )
                      : Icon(
                          Icons.category_rounded,
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary
                              .withValues(alpha: 0.1),
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