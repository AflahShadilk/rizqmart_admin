import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/coupon_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/product/product_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/coupons/add_coupon_page.dart';
import 'package:rizqmartadmin/features/auth/presentation/cubit/coupons/coupons_cubit.dart';
import 'widgets/coupon_header_section.dart';
import 'widgets/coupon_search_bar.dart';
import 'widgets/coupon_empty_state.dart';
import 'widgets/coupon_list_content.dart';

class CouponsPage extends StatelessWidget {
  const CouponsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CouponsCubit(),
      child: const _CouponsPageView(),
    );
  }
}

class _CouponsPageView extends StatefulWidget {
  const _CouponsPageView();

  @override
  State<_CouponsPageView> createState() => _CouponsPageViewState();
}

class _CouponsPageViewState extends State<_CouponsPageView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ---------------- Add Offer Dialog ----------------
  void _showAddOfferDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: BlocProvider.of<CouponBloc>(context)),
          BlocProvider.value(value: BlocProvider.of<ProductBloc>(context)),
        ],
        child: const AddCouponPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CouponBloc, CouponsState>(
      listener: (context, state) {
        // ---------------- Snackbar Notifications ----------------
        if (state is LoadingCouponSuccessfulState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.matGreen,
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.read<CouponBloc>().add(LoadingCouponsEvent());
        } else if (state is FailureCouponsState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.matRed,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          // ---------------- Coupons Page AppBar ----------------
          appBar: AppBar(
            title: Text(
              'Offers',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontFamily: 'Inter',
              ),
            ),
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Builder(
            builder: (context) {
              // ---------------- Loading State ----------------
              if (state is LoadingCouponState) {
                return const Center(child: CircularProgressIndicator());
              }

              // ---------------- Loaded State ----------------
              if (state is LoadedCouponsState) {
                final allCoupons = state.coupons;

                // ---------------- Empty State ----------------
                if (allCoupons.isEmpty) {
                  return CouponEmptyState(
                    onAddOffer: () => _showAddOfferDialog(context),
                  );
                }

                return Column(
                  children: [
                    // ---------------- Coupons Page Header ----------------
                    CouponHeaderSection(
                      couponCount: allCoupons.length,
                      onAddOffer: () => _showAddOfferDialog(context),
                    ),

                    // ---------------- Coupon Search Section ----------------
                    CouponSearchBar(controller: _searchController),

                    // ---------------- Coupons List/Grid Section ----------------
                    Expanded(
                      child: CouponListContent(coupons: allCoupons),
                    ),
                  ],
                );
              }

              return const SizedBox();
            },
          ),
        );
      },
    );
  }
}