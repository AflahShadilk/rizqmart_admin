

import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/coupon_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/coupon_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/coupons/add_coupon_page.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/coupons/offer_card.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/product/product_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/coupon/coupons_page_cubit.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/coupon/coupons_page_cubit_state.dart';
import 'package:rizqmartadmin/widgets/global_add_button.dart';
import 'package:rizqmartadmin/widgets/grid_list_toggle.dart';

class CouponsPage extends StatelessWidget {
  const CouponsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CouponsPageCubit(),
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

  List<CouponEntity> _filterCoupons(List<CouponEntity> coupons, String searchQuery) {
    if (searchQuery.isEmpty) return coupons;
    return coupons.where((coupon) {
      return coupon.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

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
          appBar: AppBar(
            title: Text(
              'Offers',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Builder(
            builder: (context) {
              if (state is LoadingCouponState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is LoadedCouponsState) {
                final allCoupons = state.coupons;

                if (allCoupons.isEmpty) {
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
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          24.h,
                          GlobalAddButton(
                            label: 'Add Offer',
                            onPressed: () => _showAddOfferDialog(context),
                          ),
                        ],
                      ),
                    );
                }

                return BlocBuilder<CouponsPageCubit, CouponsPageState>(
                  builder: (context, cubitState) {
                    final displayCoupons = _filterCoupons(allCoupons, cubitState.searchQuery);

                    return Column(
                      children: [
                        // Header Section
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardTheme.color,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Theme.of(context).dividerColor),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Manage Offers',
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).textTheme.bodyLarge?.color,
                                      ),
                                    ),
                                    4.h,
                                    Text(
                                      '${allCoupons.length} ${allCoupons.length == 1 ? 'offer' : 'offers'} available',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: Theme.of(context).textTheme.bodySmall?.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GridListToggle(
                                isGridView: cubitState.isGridView,
                                onToggle: (isGrid) {
                                  context.read<CouponsPageCubit>().toggleView(isGrid);
                                },
                              ),
                              16.w,
                              GlobalAddButton(
                                label: 'Add Offer',
                                onPressed: () => _showAddOfferDialog(context),
                              ),
                            ],
                          ),
                        ),
                        
                        // Search Bar
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              context.read<CouponsPageCubit>().updateSearchQuery(value);
                            },
                            decoration: InputDecoration(
                              hintText: 'Search offers...',
                              hintStyle: GoogleFonts.poppins(color: Theme.of(context).hintColor),
                              prefixIcon: Icon(Icons.search, color: Theme.of(context).iconTheme.color),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Theme.of(context).cardTheme.color,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              suffixIcon: cubitState.searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, color: AppColors.grey),
                                    onPressed: () {
                                      _searchController.clear();
                                      context.read<CouponsPageCubit>().clearSearch();
                                    },
                                  )
                                : null,
                            ),
                          ),
                        ),

                        // List
                        Expanded(
                          child: displayCoupons.isEmpty
                              ? Center(
                                  child: Text(
                                    'No offers match "${cubitState.searchQuery}"',
                                    style: GoogleFonts.poppins(color: Theme.of(context).textTheme.bodyMedium?.color),
                                  ),
                                )
                              : cubitState.isGridView 
                                  ? LayoutBuilder(
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
                                      }
                                    )
                                    : ListView.builder(
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
                                      ),
                        ),
                      ],
                    );
                  },
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