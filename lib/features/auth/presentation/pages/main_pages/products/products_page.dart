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
  List<AddProductEntity> filterProducts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      // ignore: use_build_context_synchronously
      context.read<ProductBloc>().add(LoadingProductEvent());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Product> searchProducts(List<AddProductEntity> products) {
    return products
        .map((prd){
          double price=0.0;
          if(prd.variantDetails!=null&&prd.variantDetails!.isNotEmpty){
            final mrp=prd.variantDetails![0]['mrp'];
            price=(mrp is num)?mrp.toDouble():0.0;
          }
         return Product(
              id: prd.id,
              name: prd.name,
              category: prd.category,
              brand: prd.brand,

              price: price
            );})
        .toList();
         
        
       
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent[50],
      body: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is SuccessLoadingState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is FailureLoadingState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
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

            List<AddProductEntity> productsToDisplay = filterProducts.isEmpty
                ? filterProductsbySearch(allProducts, _searchController.text)
                : filterProducts;
            return Column(
              children: [
                // Header Section
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

                // Search Bar
                

                // Filter Section
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
                                  setState(() {
                                    filterProducts = allProducts
                                        .where((pr) =>
                                            search.any((sp) => sp.id == pr.id))
                                        .toList();
                                  });
                                });
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),

                // Products List
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
                                          .add(LoadingProductEvent());
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

                                        return ProductCardAnimationWrapper(
                                          delay: index * 50,
                                          child: _ProductCard(
                                            product: product,
                                            categoryState: state,
                                            brandState: state,
                                            onEdit: () {
                                              context.go('/Addproducts',
                                                  extra: product);
                                            },
                                            onDelete: () {
                                              _showDeleteDialog(context, product);
                                            },
                                            getCategoryName: getCategoryName,
                                            getBrandName: getBrandName,
                                          ),
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
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, AddProductEntity product) {
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
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatefulWidget {
  final AddProductEntity product;
  final ProductState categoryState;
  final ProductState brandState;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(String, CategoryState) getCategoryName;
  final Function(String, BrandState) getBrandName;

  const _ProductCard({
    required this.product,
    required this.categoryState,
    required this.brandState,
    required this.onEdit,
    required this.onDelete,
    required this.getCategoryName,
    required this.getBrandName,
  });

  @override
  State<_ProductCard> createState() => __ProductCardState();
}

class __ProductCardState extends State<_ProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  String _getFirstVariantImage() {
  if (widget.product.variantDetails != null && 
      widget.product.variantDetails!.isNotEmpty) {
    final imageUrls = widget.product.variantDetails![0]['imageUrls'] as List?;
    if (imageUrls != null && imageUrls.isNotEmpty) {
      final firstImage=imageUrls.first;
      return (firstImage is String&&firstImage.isNotEmpty)?firstImage:'';
    }
  }
  return '';
}

double getFirstVariantPrice(){
  if(widget.product.variantDetails!=null&& widget.product.variantDetails!.isNotEmpty){
    final price=widget.product.variantDetails![0]['mrp'];
    return (price is num)?price.toDouble():0.0;
  }
  return 0.0;
}
double getTotalQuantity() {
  if (widget.product.variantDetails != null && 
      widget.product.variantDetails!.isNotEmpty) {
    double total = 0;
    for (var variant in widget.product.variantDetails!) {
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
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );

    _elevationAnimation = Tween<double>(begin: 2, end: 8).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _hoverController.forward(),
      onExit: (_) => _hoverController.reverse(),
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    blurRadius: 8 + (_elevationAnimation.value * 2),
                    spreadRadius: 1,
                    offset: Offset(0, 2 + (_elevationAnimation.value * 0.3)),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // Product Images---
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade100,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _getFirstVariantImage().isNotEmpty
                            ? Image.network(
                                _getFirstVariantImage(),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.image_not_supported);
                                },
                              )
                            : const Icon(Icons.image_not_supported),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Product Details----
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.name,
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
                              color: widget.product.status == true
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              widget.product.status == true
                                  ? 'Active'
                                  : 'Inactive',
                              style: TextStyle(
                                fontSize: 12,
                                color: widget.product.status == true
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Action Buttons
                    AnimatedOpacity(
                      opacity: _hoverController.value > 0.3 ? 1.0 : 0.7,
                      duration: const Duration(milliseconds: 300),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ScaleTransition(
                            scale: Tween<double>(begin: 1.0, end: 1.1).animate(
                              CurvedAnimation(
                                parent: _hoverController,
                                curve: Curves.easeInOut,
                              ),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.edit_outlined,
                                  color: Colors.blue),
                              onPressed: widget.onEdit,
                              tooltip: 'Edit Product',
                            ),
                          ),
                          const SizedBox(width: 4),
                          ScaleTransition(
                            scale: Tween<double>(begin: 1.0, end: 1.1).animate(
                              CurvedAnimation(
                                parent: _hoverController,
                                curve: Curves.easeInOut,
                              ),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red),
                              onPressed: widget.onDelete,
                              tooltip: 'Delete Product',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProductCardAnimationWrapper extends StatefulWidget {
  final int delay;
  final Widget child;

  const ProductCardAnimationWrapper({
    super.key,
    required this.delay,
    required this.child,
  });

  @override
  State<ProductCardAnimationWrapper> createState() =>
      _ProductCardAnimationWrapperState();
}

class _ProductCardAnimationWrapperState
    extends State<ProductCardAnimationWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    Future.delayed(Duration(milliseconds: 600), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}