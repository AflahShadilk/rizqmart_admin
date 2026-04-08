import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/presentation/cubit/search/search_filter_cubit.dart';
import 'package:rizqmartadmin/features/presentation/cubit/search/search_filter_cubit_state.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final isDark = theme.brightness == Brightness.dark;
    
    return BlocListener<SearchFilterCubit, SearchFilterState>(
      listener: (context, state) {
        _filterAndNotify();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: theme.dividerColor.withValues(alpha: 0.1),
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 800; // Determine if we have space for a row layout
            
            Widget searchBox = SizedBox(
              width: isWide ? 300 : double.infinity,
              height: 44, // Slimmer height
              child: TextField(
                controller: searchController,
                onChanged: (_) => _filterAndNotify(),
                style: GoogleFonts.inter(
                  color: theme.textTheme.bodyLarge?.color,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  hintStyle: GoogleFonts.inter(
                    color: theme.hintColor.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            size: 18,
                            color: theme.iconTheme.color?.withValues(alpha: 0.6),
                          ),
                          onPressed: () {
                            searchController.clear();
                            _filterAndNotify();
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: theme.dividerColor.withValues(alpha: 0.2),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: theme.dividerColor.withValues(alpha: 0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                ),
              ),
            );

            Widget filterControls = BlocBuilder<SearchFilterCubit, SearchFilterState>(
              builder: (context, filterState) {
                final hasActiveFilters = (filterState.selectedCategory != null && filterState.selectedCategory != 'All') ||
                                         (filterState.selectedBrand != null && filterState.selectedBrand != 'All') ||
                                         searchController.text.isNotEmpty;
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (widget.categories != null)
                      _buildSlimDropdown(
                        theme,
                        hint: 'Category',
                        value: filterState.selectedCategory,
                        items: ['All Categories', ...widget.categories!],
                        onChanged: (val) => context.read<SearchFilterCubit>().setCategory(val == 'All Categories' ? null : val),
                      ),
                    if (widget.brands != null)
                      _buildSlimDropdown(
                        theme,
                        hint: 'Brand',
                        value: filterState.selectedBrand,
                        items: ['All Brands', ...widget.brands!],
                        onChanged: (val) => context.read<SearchFilterCubit>().setBrand(val == 'All Brands' ? null : val),
                      ),
                    if (hasActiveFilters)
                      SizedBox(
                        height: 40,
                        child: TextButton.icon(
                          onPressed: clearFilters,
                          icon: Icon(
                            Icons.filter_alt_off_rounded,
                            size: 16,
                            color: theme.colorScheme.error,
                          ),
                          label: Text(
                            'Clear',
                            style: GoogleFonts.inter(
                              color: theme.colorScheme.error,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: theme.colorScheme.error.withValues(alpha: 0.1),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            );

            if (isWide) {
              return Row(
                children: [
                  searchBox,
                  16.w,
                  if (widget.showFilters) Expanded(child: filterControls),
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  searchBox,
                  if (widget.showFilters) ...[
                    12.h,
                    filterControls,
                  ],
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildSlimDropdown(ThemeData theme, {required String hint, required String? value, required List<String> items, required Function(String?) onChanged}) {
    return Container(
      width: 150,
      height: 40, // Match search box roughly or slightly shorter
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.2),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          dropdownColor: theme.cardTheme.color,
          value: value,
          hint: Text(
            hint,
            style: GoogleFonts.inter(
              color: theme.hintColor,
              fontSize: 13,
            ),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: theme.iconTheme.color?.withValues(alpha: 0.6),
          ),
          style: GoogleFonts.inter(
            color: theme.textTheme.bodyLarge?.color,
            fontSize: 13,
          ),
          items: items.map((val) => DropdownMenuItem(
                value: val == 'All Categories' || val == 'All Brands' ? null : val, // Ensure 'null' state means literally no filter
                child: Text(val),
              )).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
