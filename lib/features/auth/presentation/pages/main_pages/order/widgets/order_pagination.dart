import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/cubit/order/order_cubit.dart';
import 'package:rizqmartadmin/features/auth/presentation/cubit/order/order_state.dart';

class OrderPagination extends StatelessWidget {
  final int totalPages;

  const OrderPagination({super.key, required this.totalPages});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, pageState) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: pageState.currentPage > 1
                  ? () => context.read<OrderCubit>().previousPage()
                  : null,
            ),
            ...List.generate(totalPages, (index) {
              final pageNum = index + 1;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                  onPressed: () => context.read<OrderCubit>().setPage(pageNum),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pageState.currentPage == pageNum
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    pageNum.toString(),
                    style: TextStyle(
                      color: pageState.currentPage == pageNum
                          ? theme.colorScheme.onPrimary
                          : theme.textTheme.bodyLarge?.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: pageState.currentPage < totalPages
                  ? () => context.read<OrderCubit>().nextPage()
                  : null,
            ),
          ],
        );
      },
    );
  }
}
