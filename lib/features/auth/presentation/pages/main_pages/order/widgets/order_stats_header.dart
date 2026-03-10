import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/order/order_received_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/order/order_received_state.dart';

class OrderStatsHeader extends StatelessWidget {
  const OrderStatsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: BlocBuilder<OrderReceivedBloc, OrderReceivedState>(
        builder: (context, state) {
          int totalOrders = 0;
          if (state is NewOrdersLoaded) {
            totalOrders = state.orders.length;
          } else if (state is OrdersByStatusLoaded) {
            totalOrders = state.orders.length;
          }

          return Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.matBlue.shade900, AppColors.matIndigo.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.matBlue.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ---------------- Stats Text ----------------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.dashboard_customize_rounded, color: AppColors.white.withValues(alpha: 0.9), size: 20),
                        8.w,
                        Text(
                          'Processing Dashboard',
                          style: TextStyle(
                            color: AppColors.white.withValues(alpha: 0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    16.h,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          totalOrders.toString(),
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 56,
                            height: 1,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        8.w,
                        Text(
                          'Orders',
                          style: TextStyle(
                            color: AppColors.white.withValues(alpha: 0.8),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    8.h,
                    Text(
                      'Ready for fulfillment & processing',
                      style: TextStyle(
                        color: AppColors.white.withValues(alpha: 0.7),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                // ---------------- Stats Icon ----------------
                if (MediaQuery.of(context).size.width > 400)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white.withValues(alpha: 0.2), width: 1.5),
                    ),
                    child: const Icon(
                      Icons.inventory_2_rounded,
                      size: 52,
                      color: AppColors.white,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
