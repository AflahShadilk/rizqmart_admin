import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/domain/entities/main/coupon_entity.dart';
import 'package:rizqmartadmin/features/presentation/cubit/coupons/coupons_cubit.dart';
import 'package:rizqmartadmin/features/presentation/cubit/coupons/coupons_state.dart';
import 'offer_card.dart';

class CouponListContent extends StatelessWidget {
  final List<CouponEntity> coupons;

  const CouponListContent({super.key, required this.coupons});

  List<CouponEntity> _filterCoupons(List<CouponEntity> coupons, String searchQuery) {
    if (searchQuery.isEmpty) return coupons;
    return coupons.where((coupon) {
      return coupon.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CouponsCubit, CouponsState>(
      builder: (context, state) {
        final displayCoupons = _filterCoupons(coupons, state.searchQuery);

        if (displayCoupons.isEmpty) {
          return Center(
            child: Text(
              'No offers match "${state.searchQuery}"',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontFamily: 'Inter',
              ),
            ),
          );
        }

        if (state.isGridView) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: constraints.maxWidth > 1200 ? 3 : (constraints.maxWidth > 800 ? 2 : 1),
                  childAspectRatio: constraints.maxWidth > 800 ? 2.5 : (constraints.maxWidth > 400 ? 3.0 : 2.0),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: displayCoupons.length,
                itemBuilder: (context, index) {
                  return OfferCard(offer: displayCoupons[index]);
                },
              );
            },
          );
        } else {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: displayCoupons.length,
            itemBuilder: (context, index) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: OfferCard(offer: displayCoupons[index]),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
