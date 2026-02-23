import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/search/search_filter_cubit.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/search/search_filter_cubit_state.dart';

// Product model
class Product {
  final String id;
  final String name;
  final String category;
  final String brand;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.brand,
    required this.price,
  });
}

// Reusable search and filter widget
class SearchWithFilters extends StatelessWidget {
  final List<Product> items;
  final Function(List<Product>) onResults;
  final List<String>? categories;
  final List<String>? brands;
  final bool showFilters;

  const SearchWithFilters({
    super.key,
    required this.items,
    required this.onResults,
    this.categories,
    this.brands,
    this.showFilters = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchFilterCubit(),
      child: _SearchWithFiltersView(
        items: items,
        onResults: onResults,
        categories: categories,
        brands: brands,
        showFilters: showFilters,
      ),
    );
  }
}

class _SearchWithFiltersView extends StatefulWidget {
  final List<Product> items;
  final Function(List<Product>) onResults;
  final List<String>? categories;
  final List<String>? brands;
  final bool showFilters;

  const _SearchWithFiltersView({
    required this.items,
    required this.onResults,
    this.categories,
    this.brands,
    this.showFilters = true,
  });

  @override
  State<_SearchWithFiltersView> createState() => _SearchWithFiltersViewState();
}

class _SearchWithFiltersViewState extends State<_SearchWithFiltersView> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filterAndNotify();
  }

  void _filterAndNotify() {
    final filterState = context.read<SearchFilterCubit>().state;
    List<Product> results = widget.items;

    if (searchController.text.isNotEmpty) {
      results = results
          .where((p) => p.name
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    }

    if (filterState.selectedCategory != null && filterState.selectedCategory != 'All') {
      results = results.where((p) => p.category == filterState.selectedCategory).toList();
    }

    if (filterState.selectedBrand != null && filterState.selectedBrand != 'All') {
      results = results.where((p) => p.brand == filterState.selectedBrand).toList();
    }

    widget.onResults(results);
  }

  void clearFilters() {
    searchController.clear();
    context.read<SearchFilterCubit>().clearAll();
    _filterAndNotify();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return BlocListener<SearchFilterCubit, SearchFilterState>(
      listener: (context, state) {
        _filterAndNotify();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardTheme.color ?? theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: theme.dividerColor.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search Input
            TextField(
              controller: searchController,
              onChanged: (_) {
                _filterAndNotify();
              },
              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
              decoration: InputDecoration(
                hintText: 'Search products by name...',
                hintStyle: TextStyle(color: theme.hintColor),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: theme.colorScheme.primary,
                ),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.highlight_remove_rounded,
                          color: theme.iconTheme.color?.withValues(alpha: 0.6),
                        ),
                        onPressed: () {
                          searchController.clear();
                          _filterAndNotify();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.dividerColor.withValues(alpha: 0.2),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.dividerColor.withValues(alpha: 0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            
            // Filter controls
            if (widget.showFilters) ...[
              16.h,
              BlocBuilder<SearchFilterCubit, SearchFilterState>(
                builder: (context, filterState) {
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      // Category Dropdown
                      if (widget.categories != null)
                        Container(
                          width: 160,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: theme.dividerColor.withValues(alpha: 0.2),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              dropdownColor: theme.cardTheme.color,
                              value: filterState.selectedCategory,
                              hint: Text(
                                'Category',
                                style: TextStyle(
                                  color: theme.hintColor,
                                  fontSize: 14,
                                ),
                              ),
                              icon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: theme.iconTheme.color?.withValues(alpha: 0.7),
                              ),
                              style: TextStyle(
                                color: theme.textTheme.bodyLarge?.color,
                                fontSize: 14,
                              ),
                              items: [
                                const DropdownMenuItem(
                                  value: null,
                                  child: Text('All Categories'),
                                ),
                                ...widget.categories!.map((cat) => DropdownMenuItem(
                                      value: cat,
                                      child: Text(cat),
                                    )),
                              ],
                              onChanged: (value) {
                                context.read<SearchFilterCubit>().setCategory(value);
                              },
                            ),
                          ),
                        ),
                      
                      // Brand Dropdown
                      if (widget.brands != null)
                        Container(
                          width: 160,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: theme.dividerColor.withValues(alpha: 0.2),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              dropdownColor: theme.cardTheme.color,
                              value: filterState.selectedBrand,
                              hint: Text(
                                'Brand',
                                style: TextStyle(
                                  color: theme.hintColor,
                                  fontSize: 14,
                                ),
                              ),
                              icon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: theme.iconTheme.color?.withValues(alpha: 0.7),
                              ),
                              style: TextStyle(
                                color: theme.textTheme.bodyLarge?.color,
                                fontSize: 14,
                              ),
                              items: [
                                const DropdownMenuItem(
                                  value: null,
                                  child: Text('All Brands'),
                                ),
                                ...widget.brands!.map((brand) => DropdownMenuItem(
                                      value: brand,
                                      child: Text(brand),
                                    )),
                              ],
                              onChanged: (value) {
                                context.read<SearchFilterCubit>().setBrand(value);
                              },
                            ),
                          ),
                        ),
                      
                      // Flexible space to push clear button to the end
                      const SizedBox(width: 8),
                      
                      // Clear Button
                      if ((filterState.selectedCategory != null && filterState.selectedCategory != 'All') ||
                          (filterState.selectedBrand != null && filterState.selectedBrand != 'All') ||
                          searchController.text.isNotEmpty)
                        TextButton.icon(
                          onPressed: clearFilters,
                          icon: Icon(
                            Icons.filter_alt_off_rounded,
                            size: 18,
                            color: theme.colorScheme.error,
                          ),
                          label: Text(
                            'Clear Filters',
                            style: TextStyle(
                              color: theme.colorScheme.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: theme.colorScheme.error.withValues(alpha: 0.1),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
