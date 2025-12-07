// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/category_model.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/category/category_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/category/category_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/category/category_cubit.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/category/category_cubit_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/category/category_add_edit.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/category/delete_handle.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final TextEditingController _searchController = TextEditingController();
  late CategoryPageCubit _pageCubit;

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

  Widget buildAddButton(BuildContext context, List<CategoryModel> categories) {
    return ElevatedButton.icon(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => BlocProvider.value(
            value: BlocProvider.of<CategoryBloc>(context),
            child: CategoryDialog(
              existingCategories: categories,
            ),
          ),
        );
      },
      icon: const Icon(Icons.add_circle_outline, size: 20),
      label: Text(
        'Add Category',
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 14,
        ),
        elevation: 2,
        shadowColor: Colors.green.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _pageCubit,
      child: BlocConsumer<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state is CategorySuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is CategoryFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: AppColors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Categories',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackHeading,
                ),
              ),
              elevation: 0,
              backgroundColor: AppColors.backgroundColor,
            ),
            backgroundColor: AppColors.backgroundColor,
            body: BlocBuilder<CategoryPageCubit, CategoryPageState>(
              builder: (context, pageState) {
                if (state is CategoryLoadingState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          'Loading categories...',
                          style: GoogleFonts.poppins(
                            color: Colors.grey.shade600,
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
                          Icon(
                            Icons.category_outlined,
                            size: 64,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No categories found',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 24),
                          buildAddButton(context, allCategories),
                        ],
                      ),
                    );
                  }

                  final displayCategories =
                      filterCategories(allCategories, pageState.searchQuery);

                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Manage Categories',
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.blackHeading,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${allCategories.length} ${allCategories.length == 1 ? 'category' : 'categories'} available',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            buildAddButton(context, allCategories),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            _pageCubit.updateSearchQuery(value);
                          },
                          decoration: InputDecoration(
                            hintText: 'Search categories...',
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey.shade400,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: AppColors.charcoal,
                              size: 24,
                            ),
                            suffixIcon: pageState.searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.clear,
                                      color: AppColors.charcoal,
                                      size: 24,
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      _pageCubit.clearSearch();
                                    },
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.blueAccent,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: displayCategories.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search_off,
                                      size: 64,
                                      color: Colors.grey.shade300,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No categories match "${pageState.searchQuery}"',
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                itemCount: displayCategories.length,
                                itemBuilder: (context, index) {
                                  final category = displayCategories[index];

                                  return CategoryCard(
                                    category: category,
                                    onEdit: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => BlocProvider.value(
                                          value: BlocProvider.of<CategoryBloc>(
                                              context),
                                          child: CategoryDialog(
                                            existingCategories: allCategories,
                                            existingCategory: category,
                                          ),
                                        ),
                                      );
                                    },
                                    onDelete: () {
                                      handleDeleteCategory(context, category);
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
                          color: Colors.red.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.error,
                          style: GoogleFonts.poppins(
                            color: Colors.red.shade700,
                            fontSize: 16,
                          ),
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

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.blueAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: category.logoUrl != null && category.logoUrl!.isNotEmpty
                ? Image.network(
                    category.logoUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.category,
                        color: AppColors.blueAccent,
                        size: 24,
                      );
                    },
                  )
                : const Icon(
                    Icons.category,
                    color: AppColors.blueAccent,
                    size: 24,
                  ),
          ),
        ),
        title: Text(
          category.name,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.blackHeading,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.blue),
              onPressed: onEdit,
              tooltip: 'Edit Category',
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: onDelete,
              tooltip: 'Delete Category',
            ),
          ],
        ),
      ),
    );
  }
}