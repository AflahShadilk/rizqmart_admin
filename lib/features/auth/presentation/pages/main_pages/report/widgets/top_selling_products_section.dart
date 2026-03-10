import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/widgets/animated_hover_card.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/sales_report/top_selling_products/top_selling_products_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/sales_report/top_selling_products/top_selling_products_state.dart';

class TopSellingProductsSection extends StatelessWidget {
  const TopSellingProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopSellingProductsBloc, TopSellingProductsState>(
      builder: (context, state) {
        return AnimatedHoverCard(
          padding: const EdgeInsets.all(24),
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.deepPurple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.trending_up_rounded, color: AppColors.deepPurple, size: 20),
                  ),
                  12.w,
                  Expanded(
                    child: Text(
                      'Most Sold Products',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                ],
              ),
              20.h,

              // Content based on state
              if (state is TopSellingProductsLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (state is TopSellingProductsError)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Column(
                      children: [
                        const Icon(Icons.error_outline_rounded, color: AppColors.red300, size: 40),
                        12.h,
                        Text(
                          state.message,
                          style: const TextStyle(color: AppColors.red400, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else if (state is TopSellingProductsLoaded && state.products.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Column(
                      children: [
                        Icon(Icons.inventory_2_outlined, color: AppColors.grey400, size: 40),
                        12.h,
                        Text(
                          'No product sales data for this period',
                          style: TextStyle(color: AppColors.grey500, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                )
              else if (state is TopSellingProductsLoaded)
                ..._buildProductRows(context, state.products)
              else
                const SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildProductRows(BuildContext context, List products) {
    final widgets = <Widget>[];

    // Table header
    widgets.add(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const SizedBox(width: 36),
            Expanded(
              flex: 3,
              child: Text(
                'Product',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                'Qty Sold',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                'Revenue',
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    widgets.add(8.h);

    // Product rows
    for (int i = 0; i < products.length; i++) {
      final product = products[i];
      final rankColor = i == 0
          ? AppColors.gold
          : i == 1
              ? AppColors.silver
              : i == 2
                  ? AppColors.bronze
                  : AppColors.grey400;

      widgets.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
              ),
            ),
          ),
          child: Row(
            children: [
              // Rank badge
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: rankColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${i + 1}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: rankColor,
                  ),
                ),
              ),
              8.w,
              // Product name
              Expanded(
                flex: 3,
                child: Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Quantity sold
              Expanded(
                flex: 1,
                child: Text(
                  '${product.totalSold}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.deepPurple400,
                  ),
                ),
              ),
              // Revenue
              Expanded(
                flex: 1,
                child: Text(
                  '₹${product.totalRevenue.toStringAsFixed(0)}',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.green600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return widgets;
  }
}
