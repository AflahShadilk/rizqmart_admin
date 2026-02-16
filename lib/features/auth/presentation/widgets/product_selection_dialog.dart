// ignore_for_file: deprecated_member_use

import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/product/product_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/product/product_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/product/product_selection_cubit.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/product/product_selection_cubit_state.dart';

class ProductSelectionDialog extends StatelessWidget {
  final List<String> potentiallySelectedIds;

  const ProductSelectionDialog({
    super.key,
    required this.potentiallySelectedIds,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductSelectionCubit()..initSelection(potentiallySelectedIds),
      child: const _ProductSelectionDialogView(),
    );
  }
}

class _ProductSelectionDialogView extends StatelessWidget {
  const _ProductSelectionDialogView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductSelectionCubit, ProductSelectionState>(
      builder: (context, selectionState) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: 500,
            height: 600,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Select Applicable Products',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackHeading,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                16.h,
                TextField(
                  onChanged: (value) {
                    context.read<ProductSelectionCubit>().updateSearchQuery(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                16.h,
                Expanded(
                  child: BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      if (state is LoadingProductState) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is LoadedProductState) {
                        final allProducts = state.product;
                        final filteredProducts = allProducts.where((p) {
                          return p.name.toLowerCase().contains(selectionState.searchQuery);
                        }).toList();

                        if (filteredProducts.isEmpty) {
                          return Center(
                            child: Text(
                              'No products found',
                              style: GoogleFonts.poppins(color: Colors.grey),
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            final isSelected = selectionState.selectedIds.contains(product.id);

                            return CheckboxListTile(
                              value: isSelected,
                              onChanged: (bool? value) {
                                context.read<ProductSelectionCubit>().toggleProduct(product.id);
                              },
                              title: Text(
                                product.name,
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                'Category: ${product.category} | Brand: ${product.brand}',
                                style: GoogleFonts.poppins(fontSize: 12),
                              ),
                              secondary: Container(
                                 width: 40,
                                 height: 40,
                                 decoration: BoxDecoration(
                                   color: AppColors.blueAccent.withOpacity(0.1),
                                   borderRadius: BorderRadius.circular(8),
                                 ),
                                 child: const Icon(Icons.inventory_2_outlined, size: 20, color: AppColors.blueAccent),
                              ),
                            );
                          },
                        );
                      } else if (state is FailureLoadingState) {
                        return Center(child: Text('Error: ${state.message}'));
                      }
                      return const SizedBox();
                    },
                  ),
                ),
                16.h,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(color: Colors.grey),
                      ),
                    ),
                    16.w,
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, selectionState.selectedIds);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkBlue,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Confirm Selection',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
