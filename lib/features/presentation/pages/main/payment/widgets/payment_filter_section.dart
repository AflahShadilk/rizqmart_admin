import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/core/theme/appcolor.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/payment/payment_bloc.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/payment/payment_event.dart';
import 'package:rizqmartadmin/features/presentation/cubit/payment/payment_cubit.dart';
import 'package:rizqmartadmin/features/presentation/cubit/payment/payment_state.dart';

class PaymentFilterSection extends StatelessWidget {
  const PaymentFilterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final filters = [
      ('all', 'All', Icons.list, AppColors.matBlue),
      ('completed', 'Completed', Icons.check_circle, AppColors.matGreen),
      ('pending', 'Pending', Icons.schedule, AppColors.amber),
      ('failed', 'Failed', Icons.error, AppColors.matRed),
      ('refunded', 'Refunded', Icons.undo, AppColors.purple),
    ];

    return Container(
      color: Theme.of(context).cardTheme.color,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.asMap().entries.map((entry) {
            final index = entry.key;
            final filter = entry.value;

            return BlocBuilder<PaymentCubit, PaymentCubitState>(
              builder: (context, state) {
                final isSelected = state.selectedFilter == filter.$1;

                return Padding(
                  padding: EdgeInsets.only(
                    right: index < filters.length - 1 ? 8 : 0,
                  ),
                  child: FilterChip(
                    avatar: Icon(filter.$3, size: 16),
                    label: Text(filter.$2),
                    selected: isSelected,
                    backgroundColor: AppColors.grey100,
                    selectedColor: filter.$4.withValues(alpha: 0.2),
                    side: BorderSide(
                      color: isSelected ? filter.$4 : AppColors.transparent,
                      width: 1.5,
                    ),
                    labelStyle: TextStyle(
                      color: isSelected ? filter.$4 : AppColors.grey600,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                    onSelected: (selected) {
                      context.read<PaymentCubit>().updateFilter(filter.$1);

                      if (filter.$1 == 'all') {
                        context.read<PaymentBloc>().add(const FetchAllPaymentsEvent());
                      } else {
                        context.read<PaymentBloc>().add(
                          FetchPaymentsByStatusEvent(status: filter.$1),
                        );
                      }
                    },
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
