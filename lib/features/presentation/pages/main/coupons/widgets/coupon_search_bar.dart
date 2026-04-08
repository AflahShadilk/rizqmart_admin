import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/core/theme/appcolor.dart';
import 'package:rizqmartadmin/features/presentation/cubit/coupons/coupons_cubit.dart';
import 'package:rizqmartadmin/features/presentation/cubit/coupons/coupons_state.dart';

class CouponSearchBar extends StatelessWidget {
  final TextEditingController controller;

  const CouponSearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: BlocBuilder<CouponsCubit, CouponsState>(
        builder: (context, state) {
          return TextField(
            controller: controller,
            onChanged: (value) {
              context.read<CouponsCubit>().updateSearchQuery(value);
            },
            decoration: InputDecoration(
              hintText: 'Search offers...',
              hintStyle: TextStyle(
                color: theme.hintColor,
                fontFamily: 'Inter',
              ),
              prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: theme.cardTheme.color,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              suffixIcon: state.searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: AppColors.grey),
                      onPressed: () {
                        controller.clear();
                        context.read<CouponsCubit>().clearSearch();
                      },
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}
