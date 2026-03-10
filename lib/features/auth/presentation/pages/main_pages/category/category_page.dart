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
import 'package:rizqmartadmin/features/auth/presentation/cubit/category/category_cubit.dart';
import 'package:rizqmartadmin/features/auth/presentation/cubit/category/category_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/category/category_add_edit.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/category/delete_handle.dart';
import 'package:rizqmartadmin/widgets/global_add_button.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/category/widgets/category_header.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/category/widgets/category_search_bar.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/category/widgets/category_grid_card.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/category/widgets/category_list_card.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  // ---------------- Controllers & Cubits ----------------
  
  final TextEditingController _searchController = TextEditingController();
  late CategoryPageCubit _pageCubit;
  late CategoryLayoutCubit _layoutCubit;

  // ---------------- Init State ----------------

  @override
  void initState() {
    super.initState();
    _pageCubit = CategoryPageCubit();
    _layoutCubit = CategoryLayoutCubit();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageCubit.close();
    _layoutCubit.close();
    super.dispose();
  }

  // ---------------- Helper Methods ----------------

  List<CategoryModel> _filterCategories(
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
  
  // ---------------- Build UI ----------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _pageCubit),
        BlocProvider.value(value: _layoutCubit),
      ],
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
                          GlobalAddButton(
                            label: 'Add Category',
                            onPressed: () => _showAddDialog(context, allCategories),
                          ),
                        ],
                      ),
                    );
                  }

                  final displayCategories = _filterCategories(
                      allCategories, pageState.searchQuery);

                  return Column(
                    children: [
                      // ---------------- Category Page Header ----------------
                      CategoryHeader(
                        categories: allCategories,
                        addButton: GlobalAddButton(
                          label: 'Add Category',
                          onPressed: () => _showAddDialog(context, allCategories),
                        ),
                      ),
                      
                      // ---------------- Category Search Section ----------------
                      CategorySearchBar(
                        controller: _searchController,
                        searchQuery: pageState.searchQuery,
                        onChanged: (value) {
                          _pageCubit.updateSearchQuery(value);
                        },
                        onClear: () {
                          _searchController.clear();
                          _pageCubit.clearSearch();
                        },
                      ),
                      16.h,

                      // ---------------- Category Content Area ----------------
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
                            : BlocBuilder<CategoryLayoutCubit, CategoryLayoutState>(
                                builder: (context, layoutState) {
                                  return LayoutBuilder(
                                    builder: (context, constraints) {
                                      final isMobile = constraints.maxWidth < 768;

                                      if (!layoutState.isGridView) {
                                        // ---------------- Category List Section ----------------
                                        return ListView.separated(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: isMobile ? 16 : 24,
                                            vertical: 16,
                                          ),
                                          itemCount: displayCategories.length,
                                          separatorBuilder: (context, index) => 
                                              SizedBox(height: isMobile ? 12 : 16),
                                          itemBuilder: (context, index) {
                                            final category = displayCategories[index];
                                            return Center(
                                              child: ConstrainedBox(
                                                constraints: const BoxConstraints(maxWidth: 900),
                                                child: CategoryListCard(
                                                  category: category,
                                                  onEdit: () => _showEditDialog(
                                                      context, allCategories, category),
                                                  onDelete: () => handleDeleteCategory(
                                                      context, category),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }

                                      // ---------------- Category Grid Items ----------------
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
                                        itemCount: displayCategories.length,
                                        itemBuilder: (context, index) {
                                          final category = displayCategories[index];
                                          return CategoryGridCard(
                                            category: category,
                                            onEdit: () => _showEditDialog(
                                                context, allCategories, category),
                                            onDelete: () => handleDeleteCategory(
                                                context, category),
                                          );
                                        },
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
}
