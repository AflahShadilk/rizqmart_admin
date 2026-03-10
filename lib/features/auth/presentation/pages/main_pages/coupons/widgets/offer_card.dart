import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/coupon_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/coupon_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/coupons/add_coupon_page.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/product/product_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/image/shimmer_image.dart';
import 'package:rizqmartadmin/widgets/animated_hover_card.dart';

class OfferCard extends StatelessWidget {
  final CouponEntity offer;

  const OfferCard({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: AnimatedHoverCard(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            // Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: theme.colorScheme.surfaceContainerHighest,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: offer.imageurl.isNotEmpty
                    ? ShimmerImage(
                        imageUrl: offer.imageurl,
                        width: 80,
                        height: 80,
                        borderRadius: 12,
                      )
                    : const Icon(Icons.local_offer, color: AppColors.matBlue, size: 30),
              ),
            ),
            20.w,
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    offer.name, 
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.bodyLarge?.color,
                      fontFamily: 'Inter',
                    ),
                  ),
                  4.h,
                  Row(
                    children: [
                      Icon(Icons.currency_rupee, size: 14, color: theme.textTheme.bodyMedium?.color),
                      Text(
                         (offer.percentage ?? 0) > 0 
                            ? '${offer.percentage}% OFF' 
                            : '${offer.amount ?? 0} OFF',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.primary,
                          fontFamily: 'Inter',
                        ),
                      ),
                      12.w,
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: offer.isActive ? AppColors.matGreen.withValues(alpha: 0.1) : AppColors.matRed.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          offer.isActive ? "Active" : "Inactive",
                          style: TextStyle(
                            fontSize: 12,
                            color: offer.isActive ? AppColors.matGreen : AppColors.matRed,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ],
                  ),
                  4.h,
                   Text(
                    'Min Order: ${offer.minOrderValue} | Using: ${offer.usageLimit}',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.textTheme.bodySmall?.color,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
            // Actions
            Row(
              children: [
                IconButton(
                  onPressed: () {
                     showDialog(
                        context: context,
                        builder: (_) => MultiBlocProvider(
                          providers: [
                             BlocProvider.value(value: BlocProvider.of<CouponBloc>(context)),
                             BlocProvider.value(value: BlocProvider.of<ProductBloc>(context)),
                          ],
                          child: AddCouponPage(couponToEdit: offer), 
                        ),
                      );
                  },
                  icon: const Icon(Icons.edit_outlined, color: AppColors.matBlue),
                  tooltip: 'Edit Offer',
                ),
                IconButton(
                  onPressed: () {
                    final couponBloc = context.read<CouponBloc>();
                    showDialog(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: const Text('Delete Offer'),
                        content: Text('Are you sure you want to delete ${offer.name}?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              couponBloc.add(DeletingCouponEvent(offer.id));
                              Navigator.pop(dialogContext);
                            },
                            child: const Text('Delete', style: TextStyle(color: AppColors.matRed)),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete_outline, color: AppColors.matRed),
                  tooltip: 'Delete Offer',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
