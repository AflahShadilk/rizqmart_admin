import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:rizqmartadmin/features/auth/presentation/cubit/order/order_cubit.dart';
import 'package:rizqmartadmin/features/auth/presentation/cubit/order/order_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/order/order_received_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/order/order_received_event.dart';

class OrderFilterSection extends StatelessWidget {
  const OrderFilterSection({super.key});

  static const _filters = [
    ('all', 'All Orders', Icons.grid_view_rounded, AppColors.grey),
    ('pending', 'Pending', Icons.schedule_rounded, AppColors.amber),
    ('processing', 'Processing', Icons.autorenew_rounded, AppColors.matBlue),
    ('shipped', 'Shipped', Icons.local_shipping_rounded, AppColors.matIndigo),
    ('out for delivery', 'Out for Delivery', Icons.directions_bike_rounded, AppColors.matTeal),
    ('delivered', 'Delivered', Icons.task_alt_rounded, AppColors.matGreen),
    ('received', 'Received', Icons.inventory_rounded, AppColors.matGreen),
    ('cancelled', 'Cancelled', Icons.cancel_rounded, AppColors.matRed),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverPersistentHeader(
      pinned: true,
      delegate: _FilterHeaderDelegate(
        child: Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: theme.scaffoldBackgroundColor.withValues(alpha: 0.9),
                blurRadius: 8,
                spreadRadius: 4,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: BlocBuilder<OrderCubit, OrderState>(
            builder: (context, cubitState) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: _filters.map((filter) {
                    final isSelected = cubitState.selectedFilter == filter.$1;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: InkWell(
                        onTap: () {
                          context.read<OrderCubit>().updateFilter(filter.$1);
                          if (filter.$1 == 'all') {
                            context.read<OrderReceivedBloc>().add(const FetchNewOrdersEvent());
                          } else {
                            context.read<OrderReceivedBloc>().add(FetchOrdersByStatusEvent(status: filter.$1));
                          }
                        },
                        borderRadius: BorderRadius.circular(30),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? filter.$4.withValues(alpha: 0.1) : theme.cardTheme.color,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: isSelected ? filter.$4 : AppColors.grey.shade200,
                              width: isSelected ? 1.5 : 1.0,
                            ),
                            boxShadow: isSelected
                                ? []
                                : [BoxShadow(color: AppColors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2))],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                filter.$3,
                                size: 18,
                                color: isSelected ? filter.$4 : AppColors.grey.shade500,
                              ),
                              8.w,
                              Text(
                                filter.$2,
                                style: TextStyle(
                                  color: isSelected ? filter.$4 : AppColors.grey.shade700,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ---------------- Filter Header Delegate ----------------
class _FilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _FilterHeaderDelegate({required this.child});

  @override
  double get minExtent => 72.0;

  @override
  double get maxExtent => 72.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_FilterHeaderDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}
