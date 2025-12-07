// ignore_for_file: unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';

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
class SearchWithFilters extends StatefulWidget {
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
  State<SearchWithFilters> createState() => _SearchWithFiltersState();
}

class _SearchWithFiltersState extends State<SearchWithFilters> {
  TextEditingController searchController = TextEditingController();
  String? selectedCategory;
  String? selectedBrand;

  @override
  void initState() {
    super.initState();
    filterResults();
  }

  void filterResults() {
    List<Product> results = widget.items;

    if (searchController.text.isNotEmpty) {
      results = results
          .where((p) => p.name
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    }

    if (selectedCategory != null && selectedCategory != 'All') {
      results = results.where((p) => p.category == selectedCategory).toList();
    }

    if (selectedBrand != null && selectedBrand != 'All') {
      results = results.where((p) => p.brand == selectedBrand).toList();
    }

    widget.onResults(results);
  }

  void clearFilters() {
    setState(() {
      searchController.clear();
      selectedCategory = null;
      selectedBrand = null;
      filterResults();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: searchController,
            onChanged: (_) {
              setState(() => filterResults());
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
                        setState(() => filterResults());
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
            child: Row(
              children: [
                if (widget.categories != null)
                  Expanded(
                    child: DropdownButton<String>(
                      borderRadius: BorderRadius.circular(8),
                      dropdownColor: const Color.fromARGB(255, 158, 174, 183),
                      value: selectedCategory,
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
                        setState(() {
                          selectedCategory = value;
                          filterResults();
                        });
                      },
                    ),
                  ),
                const SizedBox(width: 10),
                if (widget.brands != null)
                  Expanded(
                    child: DropdownButton<String>(
                      borderRadius: BorderRadius.circular(8),
                      dropdownColor: const Color.fromARGB(255, 158, 174, 183),
                      value: selectedBrand,
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
                        setState(() {
                          selectedBrand = value;
                          filterResults();
                        });
                      },
                    ),
                  ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 100,
                  height: 40,
                  child: ElevatedButton.icon(
                      onPressed: () => clearFilters,
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      label: Text('Clear')),
                )
              ],
            ),
          ),
      ],
    );
  }
}
