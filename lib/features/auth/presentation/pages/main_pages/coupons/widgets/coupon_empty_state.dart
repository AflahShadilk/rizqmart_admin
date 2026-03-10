import 'package:flutter/material.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:rizqmartadmin/widgets/global_add_button.dart';

class CouponEmptyState extends StatelessWidget {
  final VoidCallback onAddOffer;

  const CouponEmptyState({super.key, required this.onAddOffer});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_offer_outlined,
            size: 64,
            color: AppColors.grey.shade300,
          ),
          16.h,
          Text(
            'No offers found',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).textTheme.bodyMedium?.color,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
          ),
          24.h,
          GlobalAddButton(
            label: 'Add Offer',
            onPressed: onAddOffer,
          ),
        ],
      ),
    );
  }
}
