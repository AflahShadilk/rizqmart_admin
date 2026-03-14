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
        if (totalPages <= 1) return const SizedBox();

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Previous Button
              _PageNavButton(
                icon: Icons.chevron_left_rounded,
                onPressed: pageState.currentPage > 1
                    ? () => context.read<OrderCubit>().previousPage()
                    : null,
              ),

              const SizedBox(width: 8),

              // Page Numbers
              ..._buildPageNumbers(context, pageState, theme),

              const SizedBox(width: 8),

              // Next Button
              _PageNavButton(
                icon: Icons.chevron_right_rounded,
                onPressed: pageState.currentPage < totalPages
                    ? () => context.read<OrderCubit>().nextPage()
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildPageNumbers(
    BuildContext context,
    OrderState state,
    ThemeData theme,
  ) {
    List<Widget> items = [];
    final current = state.currentPage;

    // Smart pagination logic: show first, last, current, and surrounding pages
    if (totalPages <= 7) {
      for (int i = 1; i <= totalPages; i++) {
        items.add(_PageNumberButton(page: i, isSelected: current == i));
      }
    } else {
      // First page
      items.add(_PageNumberButton(page: 1, isSelected: current == 1));

      if (current > 4) {
        items.add(_buildEllipsis(theme));
      }

      // Middle pages
      int start = (current - 1).clamp(2, totalPages - 1);
      int end = (current + 1).clamp(2, totalPages - 1);

      // Adjust to show at least 3 middle pages if possible
      if (current <= 4) end = 5;
      if (current >= totalPages - 3) start = totalPages - 4;

      for (int i = start; i <= end; i++) {
        if (i > 1 && i < totalPages) {
          items.add(_PageNumberButton(page: i, isSelected: current == i));
        }
      }

      if (current < totalPages - 3) {
        items.add(_buildEllipsis(theme));
      }

      // Last page
      items.add(_PageNumberButton(page: totalPages, isSelected: current == totalPages));
    }

    return items;
  }

  Widget _buildEllipsis(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        '...',
        style: TextStyle(
          color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _PageNumberButton extends StatelessWidget {
  final int page;
  final bool isSelected;

  const _PageNumberButton({required this.page, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: () => context.read<OrderCubit>().setPage(page),
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? primary : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? primary : theme.dividerColor.withValues(alpha: 0.1),
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Text(
            page.toString(),
            style: TextStyle(
              color: isSelected ? theme.colorScheme.onPrimary : theme.textTheme.bodyLarge?.color,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

class _PageNavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _PageNavButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: theme.dividerColor.withValues(alpha: 0.1),
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: onPressed != null
              ? theme.colorScheme.primary
              : theme.disabledColor.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
