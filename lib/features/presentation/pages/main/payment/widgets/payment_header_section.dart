import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/core/theme/appcolor.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/payment/payment_bloc.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/payment/payment_state.dart';
import 'package:rizqmartadmin/features/presentation/widgets/common/animated_hover_card.dart';

class PaymentHeaderSection extends StatelessWidget {
  const PaymentHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardTheme.color,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, state) {
          if (state is PaymentAnalyticsLoaded) {
            final analytics = state.analytics;
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: PaymentMetricCard(
                        label: 'Total Revenue',
                        value: analytics.totalRevenue.toStringAsFixed(2),
                        color: AppColors.matGreen,
                        icon: Icons.trending_up,
                      ),
                    ),
                    16.w,
                    Expanded(
                      child: PaymentMetricCard(
                        label: 'Success Rate',
                        value: '${analytics.successRate.toStringAsFixed(1)}%',
                        color: AppColors.matBlue,
                        icon: Icons.check_circle,
                      ),
                    ),
                    16.w,
                    Expanded(
                      child: PaymentMetricCard(
                        label: 'Completed',
                        value: '${analytics.completedCount}',
                        color: AppColors.matGreen,
                        icon: Icons.done,
                      ),
                    ),
                    16.w,
                    Expanded(
                      child: PaymentMetricCard(
                        label: 'Pending',
                        value: '${analytics.pendingCount}',
                        color: AppColors.amber,
                        icon: Icons.schedule,
                      ),
                    ),
                  ],
                ),
                16.h,
                Row(
                  children: [
                    Expanded(
                      child: PaymentAmountCard(
                        label: 'Completed Amount',
                        amount: analytics.completedAmount.toStringAsFixed(2),
                        color: AppColors.matGreen,
                      ),
                    ),
                    16.w,
                    Expanded(
                      child: PaymentAmountCard(
                        label: 'Pending Amount',
                        amount: analytics.pendingAmount.toStringAsFixed(2),
                        color: AppColors.amber,
                      ),
                    ),
                    16.w,
                    Expanded(
                      child: PaymentAmountCard(
                        label: 'Refunded Amount',
                        amount: analytics.refundedAmount.toStringAsFixed(2),
                        color: AppColors.purple,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class PaymentMetricCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const PaymentMetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedHoverCard(
      padding: const EdgeInsets.all(16),
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          8.h,
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          4.h,
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class PaymentAmountCard extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;

  const PaymentAmountCard({
    super.key,
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedHoverCard(
      padding: const EdgeInsets.all(16),
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          8.h,
          Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
