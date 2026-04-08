import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:rizqmartadmin/features/presentation/cubit/coupons/coupons_cubit.dart';
import 'package:rizqmartadmin/features/presentation/cubit/coupons/coupons_state.dart';
import 'package:rizqmartadmin/features/presentation/widgets/buttons/global_add_button.dart';
import 'package:rizqmartadmin/features/presentation/widgets/common/grid_list_toggle.dart';

class CouponHeaderSection extends StatelessWidget {
  final int couponCount;
  final VoidCallback onAddOffer;

  const CouponHeaderSection({
    super.key,
    required this.couponCount,
    required this.onAddOffer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manage Offers',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: theme.textTheme.bodyLarge?.color,
                    fontFamily: 'Inter',
                  ),
                ),
                4.h,
                Text(
                  '$couponCount ${couponCount == 1 ? 'offer' : 'offers'} available',
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.textTheme.bodySmall?.color,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          BlocBuilder<CouponsCubit, CouponsState>(
            builder: (context, state) {
              return GridListToggle(
                isGridView: state.isGridView,
                onToggle: (isGrid) {
                  context.read<CouponsCubit>().toggleView(isGrid);
                },
              );
            },
          ),
          16.w,
          GlobalAddButton(
            label: 'Add Offer',
            onPressed: onAddOffer,
          ),
        ],
      ),
    );
  }
}
