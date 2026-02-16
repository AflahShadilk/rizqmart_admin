// ignore_for_file: unnecessary_to_list_in_spreads

import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
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
    return BlocListener<SearchFilterCubit, SearchFilterState>(
      listener: (context, state) {
        _filterAndNotify();
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: (_) {
                _filterAndNotify();
              },
              decoration: InputDecoration(
                hintText: 'Search by name...',
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.charcoal,
                  weight: 30,
                ),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: AppColors.charcoal,
                          weight: 30,
                        ),
                        onPressed: () {
                          searchController.clear();
                          _filterAndNotify();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          // Filter dropdowns
          if (widget.showFilters)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BlocBuilder<SearchFilterCubit, SearchFilterState>(
                builder: (context, filterState) {
                  return Row(
                    children: [
                      if (widget.categories != null)
                        Expanded(
                          child: DropdownButton<String>(
                            borderRadius: BorderRadius.circular(8),
                            dropdownColor: const Color.fromARGB(255, 158, 174, 183),
                            value: filterState.selectedCategory,
                            hint: const Text('Category'),
                            isExpanded: true,
                            items: [
                              const DropdownMenuItem(
                                value: null,
                                child: Text('All Categories'),
                              ),
                              ...widget.categories!
                                  .map((cat) => DropdownMenuItem(
                                        value: cat,
                                        child: Text(cat),
                                      ))
                                  .toList(),
                            ],
                            onChanged: (value) {
                              context.read<SearchFilterCubit>().setCategory(value);
                            },
                          ),
                        ),
                      10.w,
                      if (widget.brands != null)
                        Expanded(
                          child: DropdownButton<String>(
                            borderRadius: BorderRadius.circular(8),
                            dropdownColor: const Color.fromARGB(255, 158, 174, 183),
                            value: filterState.selectedBrand,
                            hint: const Text('Brand'),
                            isExpanded: true,
                            items: [
                              const DropdownMenuItem(
                                value: null,
                                child: Text('All Brands'),
                              ),
                              ...widget.brands!
                                  .map((brand) => DropdownMenuItem(
                                        value: brand,
                                        child: Text(brand),
                                      ))
                                  .toList(),
                            ],
                            onChanged: (value) {
                              context.read<SearchFilterCubit>().setBrand(value);
                            },
                          ),
                        ),
                      10.w,
                      SizedBox(
                        width: 100,
                        height: 40,
                        child: ElevatedButton.icon(
                            onPressed: () => clearFilters(),
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            label: const Text('Clear')),
                      )
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
