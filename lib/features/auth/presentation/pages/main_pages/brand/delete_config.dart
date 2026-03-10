import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// removed GoogleFonts
import 'package:rizqmartadmin/features/auth/domain/entities/main/brand_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/product_model.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/brand/brand_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/brand/brand_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/product/product_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/product/product_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/product/product_state.dart';

void handleDelete(BuildContext context, BrandEntity brandEntity) {
  
  try {
    final productBloc = context.read<ProductBloc>();
    
    final productState = productBloc.state;

    List<dynamic> products = [];

    if (productState is LoadingProductState) {
      productBloc.add(LoadingProductEvent());
      
      return;
    }
    
    if (productState is LoadedProductState) {
      products = productState.product;
    } else {
      products = [];
    }

    bool isUsed = false;
    
    if (products.isNotEmpty) {
      
      isUsed = products.whereType<AddProductEntity>().any((product) {
        bool matches = product.brand == brandEntity.name;
        return matches;
      });
      
    } else {
    }

    if (isUsed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Cannot delete! This brand is used in products.'),
          backgroundColor: AppColors.matRed,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
      _showDeleteConfirmDialog(context, brandEntity);
    }
  } catch (e) {
    _showDeleteConfirmDialog(context, brandEntity);
  }
}

void _showDeleteConfirmDialog(BuildContext context, BrandEntity brandEntity) {
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
            Icon(Icons.warning_amber_rounded, color: AppColors.matAmber.shade700),
            12.w,
            Text(
              'Delete Brand',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "${brandEntity.name}"? This action cannot be undone.',
          style: TextStyle(fontSize: 14, fontFamily: 'Inter'),
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
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.grey.shade700,
                fontFamily: 'Inter',
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              brandBloc.add(DeleteBrandEvent(brandEntity.id));
              Navigator.pop(dialogContext);
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Brand deleted successfully'),
                  backgroundColor: AppColors.matGreen,
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Text(
              'Delete',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      );
    },
  );
}