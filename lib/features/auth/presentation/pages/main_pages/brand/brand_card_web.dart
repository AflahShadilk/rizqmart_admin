// ignore_for_file: unnecessary_null_comparison, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/brand_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/product_model.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/brand/brand_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/brand/brand_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/brand/brand_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/product/product_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/product/product_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/product/product_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/brand/add_brand_form_web.dart';

class BrandCardWeb extends StatefulWidget {
  final BrandEntity? brand;

  const BrandCardWeb({super.key, this.brand});

  @override
  State<BrandCardWeb> createState() => _BrandCardWebState();
}

class _BrandCardWebState extends State<BrandCardWeb>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

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

    _elevationAnimation = Tween<double>(begin: 4, end: 16).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _onHoverEnter() {
    _hoverController.forward();
  }

  void _onHoverExit() {
    _hoverController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHoverEnter(),
      onExit: (_) => _onHoverExit(),
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x1A000000),
                    blurRadius: 10 + (_elevationAnimation.value * 2),
                    spreadRadius: 1,
                    offset: Offset(0, 2 + (_elevationAnimation.value * 0.5)),
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.lightBlue.withOpacity(
                              _hoverController.value * 0.3,
                            ),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: widget.brand!.logourl.isNotEmpty
                            ? Image.network(
                                widget.brand!.logourl,
                                width: 100,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 100,
                                    height: 70,
                                    color: Colors.grey.shade200,
                                    child: const Icon(Icons.broken_image,
                                        size: 40, color: Colors.grey),
                                  );
                                },
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    width: 100,
                                    height: 70,
                                    color: Colors.grey.shade200,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(
                                width: 100,
                                height: 70,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.image,
                                    size: 40, color: Colors.grey),
                              ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.brand!.name,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: widget.brand!.status
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AnimatedRotation(
                                  turns: _hoverController.value,
                                  duration: const Duration(milliseconds: 300),
                                  child: Icon(
                                    widget.brand!.status
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color: widget.brand!.status
                                        ? Colors.green
                                        : Colors.red,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  widget.brand!.status ? "Active" : "Inactive",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: widget.brand!.status
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: _hoverController.value > 0.5 ? 1.0 : 0.8,
                      duration: const Duration(milliseconds: 300),
                      child: Row(
                        children: [
                          Tooltip(
                            message: "Edit Brand",
                            child: ScaleTransition(
                              scale:
                                  Tween<double>(begin: 1.0, end: 1.05).animate(
                                CurvedAnimation(
                                  parent: _hoverController,
                                  curve: Curves.easeInOut,
                                ),
                              ),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  final brandState =
                                      BlocProvider.of<BrandBloc>(context).state;
                                  final brandList = brandState
                                          is BrandLoadedState
                                      ? (brandState).brand.cast<BrandEntity>()
                                      : <BrandEntity>[];
                                  showDialog(
                                    context: context,
                                    builder: (_) => BlocProvider.value(
                                      value:
                                          BlocProvider.of<BrandBloc>(context),
                                      child: AddBrandFormWeb(
                                          brands: widget.brand,
                                          brandslist: brandList),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.edit,
                                    color: Colors.white, size: 18),
                                label: const Text(
                                  "Edit",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.blueAccent,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 4,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Tooltip(
                            message: "Delete Brand",
                            child: ScaleTransition(
                              scale:
                                  Tween<double>(begin: 1.0, end: 1.05).animate(
                                CurvedAnimation(
                                  parent: _hoverController,
                                  curve: Curves.easeInOut,
                                ),
                              ),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                   _handleDlete(context, widget.brand!);
                                  
                                },
                                icon: const Icon(Icons.delete,
                                    color: Colors.white, size: 18),
                                label: const Text(
                                  "Delete",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 4,
                                ),
                              ),
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

  void _handleDlete(BuildContext context, BrandEntity brand) {
    try {
      final productB = context.read<ProductBloc>();
      final productState = productB.state;

      List<dynamic> products = [];

      if (productState is LoadingProductState) {
        productB.add(LoadingProductEvent());
        return;
      }

      if (productState is LoadedProductState) {
        products = productState.product ?? [];
      } else {
        products = [];
      }

      bool isUsed = false;

      if (products.isNotEmpty) {
        isUsed = products.whereType<AddProductEntity>().any((product) {
          bool match = product.brand == brand.id;
          return match;
        });
      } else {}
      if (isUsed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                const Text('Cannot delete! This Brand is used in products.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        showDeleteconform(context, brand);
      }
    } catch (e) {
      showDeleteconform(context, brand);
    }
  }

  void showDeleteconform(BuildContext context, BrandEntity brand) {
    final brandBloc = context.read<BrandBloc>();
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.warning_amber_rounded,
                    color: Colors.orange.shade700),
                const SizedBox(width: 12),
                Text(
                  'Delete Brand',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            content: Text(
              'Are you sure you want to delete "${brand.name}"? This action cannot be undone.',
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  brandBloc.add(DeleteBrandEvent(brand.id));
                  Navigator.pop(dialogContext);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Brand deleted successfully'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Text(
                  'Delete',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
