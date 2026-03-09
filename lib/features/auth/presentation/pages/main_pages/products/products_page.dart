import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
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
import 'package:rizqmartadmin/widgets/animated_hover_card.dart';
import 'package:rizqmartadmin/widgets/global_add_button.dart';
import 'package:rizqmartadmin/widgets/grid_list_toggle.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/widgets/search_with_filter.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/image/shimmer_image.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final TextEditingController _searchController = TextEditingController();
  late ProductsPageCubit _pageCubit;
  bool isGridView = true;

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
        title: Text(
          'Delete Product',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to delete "${product.name}"?',
          style: GoogleFonts.inter(),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
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
            child: Text(
              'Delete',
              style: GoogleFonts.inter(
                  color: AppColors.matRed, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocProvider.value(
      value: _pageCubit,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: BlocListener<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is SuccessLoadingState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.matGreen,
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else if (state is FailureLoadingState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.matRed,
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
                      : pageState.filterProducts.where((p) => allProducts.any((ap) => ap.id == p.id)).toList();

                  // Client-side pagination
                  final totalItems = productsToDisplay.length;
                  final totalPages = (totalItems / pageState.itemsPerPage).ceil();
                  final startIndex = (pageState.currentPage - 1) * pageState.itemsPerPage;
                  final endIndex = (startIndex + pageState.itemsPerPage).clamp(0, totalItems);
                  final paginatedProducts = totalItems > 0
                      ? productsToDisplay.sublist(startIndex, endIndex)
                      : <AddProductEntity>[];

                  return Column(
                     children: [
                      Container(
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
                                color: AppColors.blueAccent.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.inventory_2_outlined,
                                color: AppColors.blueAccent,
                                size: 28,
                              ),
                            );
                            
                            final titleColumn = Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Product Catalog',
                                  style: GoogleFonts.inter(
                                    fontSize: isCompact ? 20 : 24,
                                    fontWeight: FontWeight.w700,
                                    color: theme.textTheme.bodyLarge?.color,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                4.h,
                                Text(
                                  '${allProducts.length} ${allProducts.length == 1 ? 'product' : 'products'} available in store',
                                  style: GoogleFonts.inter(
                                    fontSize: isCompact ? 12 : 14,
                                    color: theme.textTheme.bodySmall?.color,
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
                            
                            final addButton = GlobalAddButton(
                              label: 'Add Product',
                              onPressed: () {
                                context.go('/Addproducts');
                              },
                            );
                            
                            if (isCompact) {
                              // Mobile: stacked layout
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
                            
                            // Desktop: single row layout
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
                      if (allProducts.isNotEmpty)
                        BlocBuilder<CategoryBloc, CategoryState>(
                          builder: (context, catstate) {
                            return BlocBuilder<BrandBloc, BrandState>(
                              builder: (context, brandState) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24),
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
                      16.h,
                      Expanded(
                        child: state is LoadingProductState
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(color: theme.colorScheme.primary),
                                    24.h,
                                    Text(
                                      'Loading product catalog...',
                                      style: GoogleFonts.inter(
                                        color: theme.textTheme.bodySmall?.color,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
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
                                          color: AppColors.matRed.withValues(alpha: 0.8),
                                        ),
                                        20.h,
                                        Text(
                                          'Failed to load products',
                                          style: GoogleFonts.inter(
                                            color: theme.textTheme.bodyLarge?.color,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        8.h,
                                        Text(
                                          state.message,
                                          style: GoogleFonts.inter(
                                            color: theme.textTheme.bodySmall?.color,
                                            fontSize: 14,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        24.h,
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            context
                                                .read<ProductBloc>()
                                                .add(const LoadingProductEvent());
                                          },
                                          icon: const Icon(Icons.refresh_rounded),
                                          label: const Text('Try Again'),
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
                                                Container(
                                                  padding: const EdgeInsets.all(24),
                                                  decoration: BoxDecoration(
                                                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.inventory_2_outlined,
                                                    size: 64,
                                                    color: theme.colorScheme.primary,
                                                  ),
                                                ),
                                                24.h,
                                                Text(
                                                  'No products found',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 22,
                                                    color: theme.textTheme.bodyLarge?.color,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                8.h,
                                                Text(
                                                  'Start by adding your first product to the catalog.',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 15,
                                                    color: theme.textTheme.bodySmall?.color,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : LayoutBuilder(
                                            builder: (context, constraints) {
                                              if (!isGridView) {
                                                // List View Mode
                                                return ListView.separated(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 24,
                                                    vertical: 16,
                                                  ),
                                                  itemCount: paginatedProducts.length,
                                                  separatorBuilder: (context, index) => 12.h,
                                                  itemBuilder: (context, index) {
                                                    final product = paginatedProducts[index];
                                                    return ProductListCard(
                                                      product: product,
                                                      categoryState: state,
                                                      brandState: state,
                                                      onEdit: () => context.go('/Addproducts', extra: product),
                                                      onDelete: () => showDeleteDialog(context, product),
                                                      getCategoryName: getCategoryName,
                                                      getBrandName: getBrandName,
                                                    );
                                                  },
                                                );
                                              }

                                              // Grid View Mode: Making cards slightly narrower overall by increasing crossAxisCount
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
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 24,
                                                  vertical: 16,
                                                ),
                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: crossAxisCount,
                                                  crossAxisSpacing: crossAxisCount == 1 ? 12 : 20,
                                                  mainAxisSpacing: crossAxisCount == 1 ? 12 : 20,
                                                  childAspectRatio: crossAxisCount == 1 ? 1.2 : 0.72,
                                                ),
                                                itemCount: paginatedProducts.length,
                                                itemBuilder: (context, index) {
                                                  final product = paginatedProducts[index];
                                                  return ProductGridCard(
                                                    product: product,
                                                    categoryState: state,
                                                    brandState: state,
                                                    onEdit: () => context.go('/Addproducts', extra: product),
                                                    onDelete: () => showDeleteDialog(context, product),
                                                    getCategoryName: getCategoryName,
                                                    getBrandName: getBrandName,
                                                  );
                                                },
                                              );
                                            },
                                          )
                                    : const Center(
                                        child: Text('No state available'),
                                      ),
                      ),
                      // Pagination Bar
                      if (totalPages > 1)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          decoration: BoxDecoration(
                            color: theme.cardTheme.color,
                            border: Border(
                              top: BorderSide(
                                color: theme.dividerColor.withValues(alpha: 0.1),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: pageState.currentPage > 1 
                                      ? theme.colorScheme.primary.withValues(alpha: 0.1)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.chevron_left_rounded),
                                  color: pageState.currentPage > 1 ? theme.colorScheme.primary : theme.disabledColor,
                                  onPressed: pageState.currentPage > 1
                                      ? () => _pageCubit.previousPage()
                                      : null,
                                  tooltip: 'Previous page',
                                ),
                              ),
                              24.w,
                              Column(
                                children: [
                                  Text(
                                    'Page ${pageState.currentPage} of $totalPages',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: theme.textTheme.bodyMedium?.color,
                                    ),
                                  ),
                                  4.h,
                                  Text(
                                    'Showing ${startIndex + 1}–$endIndex of $totalItems',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: theme.textTheme.bodySmall?.color,
                                    ),
                                  ),
                                ],
                              ),
                              24.w,
                              Container(
                                decoration: BoxDecoration(
                                  color: pageState.currentPage < totalPages 
                                      ? theme.colorScheme.primary.withValues(alpha: 0.1)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.chevron_right_rounded),
                                  color: pageState.currentPage < totalPages ? theme.colorScheme.primary : theme.disabledColor,
                                  onPressed: pageState.currentPage < totalPages
                                      ? () => _pageCubit.nextPage(totalItems)
                                      : null,
                                  tooltip: 'Next page',
                                ),
                              ),
                            ],
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

class ProductGridCard extends StatelessWidget {
  final AddProductEntity product;
  final ProductState categoryState;
  final ProductState brandState;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(String, CategoryState) getCategoryName;
  final Function(String, BrandState) getBrandName;

  const ProductGridCard({
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
    final theme = Theme.of(context);
    
    return AnimatedHoverCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
            // Image Section Top
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: getFirstVariantImage().isNotEmpty
                          ? SizedBox.expand(
                              child: ShimmerImage(
                                imageUrl: getFirstVariantImage(),
                                width: double.infinity,
                                height: double.infinity,
                                borderRadius: 0, 
                              ),
                            )
                          : Center(
                              child: Icon(
                                Icons.inventory_2_outlined, 
                                size: 40, 
                                color: AppColors.grey.withValues(alpha: 0.5)
                              ),
                            ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: product.status == true
                            ? AppColors.matGreen.withValues(alpha: 0.9)
                            : AppColors.matRed.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        product.status == true ? 'Active' : 'Inactive',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Details Section Bottom
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: theme.textTheme.bodyLarge?.color,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
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
                            'Stock: ${getTotalQuantity().toInt()}',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: theme.textTheme.bodySmall?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    8.h,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Text(
                            '₹${getFirstVariantPrice().toStringAsFixed(2)}',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.emerald,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Action Buttons Smaller for Grid
                        Row(
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
                                tooltip: 'Edit Product',
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
                                tooltip: 'Delete Product',
                              ),
                            ),
                          ],
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

// Restored horizontal modern List Card
class ProductListCard extends StatelessWidget {
  final AddProductEntity product;
  final ProductState categoryState;
  final ProductState brandState;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(String, CategoryState) getCategoryName;
  final Function(String, BrandState) getBrandName;

  const ProductListCard({
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
    final theme = Theme.of(context);

    return AnimatedHoverCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: theme.colorScheme.surface,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: getFirstVariantImage().isNotEmpty
                      ? ShimmerImage(
                          imageUrl: getFirstVariantImage(),
                          width: 70,
                          height: 70,
                          borderRadius: 0,
                        )
                      : Icon(Icons.image_not_supported, size: 28, color: AppColors.grey.withValues(alpha: 0.5)),
                ),
              ),
              16.w,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.h,
                    Row(
                      children: [
                        Text(
                          '₹${getFirstVariantPrice().toStringAsFixed(2)}',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.emerald,
                          ),
                        ),
                        16.w,
                        Text(
                          'Stock: ${getTotalQuantity().toInt()}',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                        16.w,
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: product.status == true
                                ? AppColors.matGreen.withValues(alpha: 0.1)
                                : AppColors.matRed.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            product.status == true ? 'Active' : 'Inactive',
                            style: TextStyle(
                              fontSize: 11,
                              color: product.status == true ? AppColors.matGreen : AppColors.matRed,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.chartBlue.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.edit_rounded, color: AppColors.chartBlue, size: 18),
                      onPressed: onEdit,
                      tooltip: 'Edit Product',
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
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.delete_outline_rounded, color: AppColors.chartRed, size: 18),
                      onPressed: onDelete,
                      tooltip: 'Delete Product',
                    ),
                  ),
                ],
              ),
            ],
          ),
    );
  }
}