// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/product_model.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/brand/brand_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/brand/brand_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/category/category_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/category/category_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/product/productpage/product_page_cubit.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/product/productpage/product_page_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/product/product_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/product/product_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/product/product_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/widgets/search_with_filter.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final TextEditingController _searchController = TextEditingController();
  late ProductsPageCubit _pageCubit;

  @override
  void initState() {
    super.initState();
    _pageCubit = ProductsPageCubit();
    Future.delayed(Duration.zero, () {
      // ignore: use_build_context_synchronously
      context.read<ProductBloc>().add(const LoadingProductEvent());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageCubit.close();
    super.dispose();
  }

  List<Product> searchProducts(List<AddProductEntity> products) {
    return products.map((prd) {
      double price = 0.0;
      if (prd.variantDetails != null && prd.variantDetails!.isNotEmpty) {
        final mrp = prd.variantDetails![0]['mrp'];
        price = (mrp is num) ? mrp.toDouble() : 0.0;
      }
      return Product(
        id: prd.id,
        name: prd.name,
        category: prd.category,
        brand: prd.brand,
        price: price,
      );
    }).toList();
  }

  List<String> getCategory(List<AddProductEntity> products, CategoryState catState) {
    final categoryIds = products.map((p) => p.category).toSet().toList();

    return categoryIds.map((catId) {
      if (catState is CategoryLoadedState) {
        try {
          return catState.cotegories.firstWhere((cat) => cat.id == catId).name;
        } catch (e) {
          return catId;
        }
      }
      return catId;
    }).toSet().toList();
  }

  List<String> getBrand(List<AddProductEntity> products, BrandState brandState) {
    final brandIds = products.map((p) => p.brand).toSet().toList();

    return brandIds.map((brandId) {
      if (brandState is BrandLoadedState) {
        try {
          return brandState.brand.firstWhere((b) => b.id == brandId).name;
        } catch (e) {
          return brandId;
        }
      }
      return brandId;
    }).toSet().toList();
  }

  String getCategoryName(String categoryId, CategoryState state) {
    if (state is CategoryLoadedState) {
      try {
        return state.cotegories.firstWhere((cat) => cat.id == categoryId).name;
      } catch (e) {
        return categoryId;
      }
    }
    return categoryId;
  }

  String getBrandName(String brandId, BrandState state) {
    if (state is BrandLoadedState) {
      try {
        return state.brand.firstWhere((b) => b.id == brandId).name;
      } catch (e) {
        return brandId;
      }
    }
    return brandId;
  }

  List<AddProductEntity> filterProductsbySearch(
    List<AddProductEntity> products,
    String query,
  ) {
    if (query.isEmpty) return products;

    return products
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void showDeleteDialog(BuildContext context, AddProductEntity product) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text(
          'Are you sure you want to delete "${product.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<ProductBloc>().add(
                    DeletingProductEvent(product.id),
                  );

              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Product deleted')),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _pageCubit,
      child: Scaffold(
        backgroundColor: Colors.blueAccent[50],
        body: BlocListener<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is SuccessLoadingState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.green,
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else if (state is FailureLoadingState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.red,
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              List<AddProductEntity> allProducts = [];
              if (state is LoadedProductState) {
                allProducts = state.product;
              }

              return BlocBuilder<ProductsPageCubit, ProductsPageState>(
                builder: (context, pageState) {
                  List<AddProductEntity> productsToDisplay = pageState.filterProducts.isEmpty
                      ? filterProductsbySearch(allProducts, _searchController.text)
                      : pageState.filterProducts;

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
                                    'Products Management',
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.blackHeading,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${allProducts.length} ${allProducts.length == 1 ? 'product' : 'products'} available',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                context.go('/Addproducts');
                              },
                              icon: const Icon(Icons.add_circle_outline, size: 20),
                              label: Text(
                                'Add Product',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 14,
                                ),
                                elevation: 2,
                                shadowColor: AppColors.green.withOpacity(0.3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (allProducts.isNotEmpty)
                        BlocBuilder<CategoryBloc, CategoryState>(
                          builder: (context, catstate) {
                            return BlocBuilder<BrandBloc, BrandState>(
                              builder: (context, brandState) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: SearchWithFilters(
                                    items: searchProducts(allProducts),
                                    categories: getCategory(allProducts, catstate),
                                    brands: getBrand(allProducts, brandState),
                                    showFilters: true,
                                    onResults: (search) {
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        _pageCubit.updateFilterProducts(
                                          allProducts
                                              .where((pr) =>
                                                  search.any((sp) => sp.id == pr.id))
                                              .toList(),
                                        );
                                      });
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      Expanded(
                        child: state is LoadingProductState
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const CircularProgressIndicator(),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Loading products...',
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : state is FailureLoadingState
                                ? Center(
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
                                          'Error: ${state.message}',
                                          style: GoogleFonts.poppins(
                                            color: Colors.red.shade700,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: () {
                                            context
                                                .read<ProductBloc>()
                                                .add(const LoadingProductEvent());
                                          },
                                          child: const Text('Retry'),
                                        ),
                                      ],
                                    ),
                                  )
                                : state is LoadedProductState
                                    ? allProducts.isEmpty
                                        ? Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.shopping_bag_outlined,
                                                  size: 64,
                                                  color: Colors.grey.shade300,
                                                ),
                                                const SizedBox(height: 16),
                                                Text(
                                                  'No products found',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 18,
                                                    color: Colors.grey.shade600,
                                                    fontWeight: FontWeight.w500,
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
                                            itemCount: productsToDisplay.length,
                                            itemBuilder: (context, index) {
                                              final product = productsToDisplay[index];

                                              return ProductCard(
                                                product: product,
                                                categoryState: state,
                                                brandState: state,
                                                onEdit: () {
                                                  context.go('/Addproducts',
                                                      extra: product);
                                                },
                                                onDelete: () {
                                                  showDeleteDialog(context, product);
                                                },
                                                getCategoryName: getCategoryName,
                                                getBrandName: getBrandName,
                                              );
                                            },
                                          )
                                    : const Center(
                                        child: Text('No state available'),
                                      ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final AddProductEntity product;
  final ProductState categoryState;
  final ProductState brandState;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(String, CategoryState) getCategoryName;
  final Function(String, BrandState) getBrandName;

  const ProductCard({
    super.key,
    required this.product,
    required this.categoryState,
    required this.brandState,
    required this.onEdit,
    required this.onDelete,
    required this.getCategoryName,
    required this.getBrandName,
  });

  String getFirstVariantImage() {
    if (product.variantDetails != null && product.variantDetails!.isNotEmpty) {
      final imageUrls = product.variantDetails![0]['imageUrls'] as List?;
      if (imageUrls != null && imageUrls.isNotEmpty) {
        final firstImage = imageUrls.first;
        return (firstImage is String && firstImage.isNotEmpty) ? firstImage : '';
      }
    }
    return '';
  }

  double getFirstVariantPrice() {
    if (product.variantDetails != null && product.variantDetails!.isNotEmpty) {
      final price = product.variantDetails![0]['mrp'];
      return (price is num) ? price.toDouble() : 0.0;
    }
    return 0.0;
  }

  double getTotalQuantity() {
    if (product.variantDetails != null && product.variantDetails!.isNotEmpty) {
      double total = 0;
      for (var variant in product.variantDetails!) {
        final quantity = variant['quantity'];
        if (quantity is num) {
          total += quantity.toDouble();
        }
      }
      return total;
    }
    return 0.0;
  }

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
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade100,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: getFirstVariantImage().isNotEmpty
                    ? Image.network(
                        getFirstVariantImage(),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.image_not_supported);
                        },
                      )
                    : const Icon(Icons.image_not_supported),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackHeading,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '₹${getFirstVariantPrice().toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Stock: ${getTotalQuantity().toInt()}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: product.status == true
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      product.status == true ? 'Active' : 'Inactive',
                      style: TextStyle(
                        fontSize: 12,
                        color: product.status == true ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                  onPressed: onEdit,
                  tooltip: 'Edit Product',
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: onDelete,
                  tooltip: 'Delete Product',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}