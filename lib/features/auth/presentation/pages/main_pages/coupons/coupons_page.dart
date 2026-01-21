import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/coupon_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/coupon_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/coupons/add_coupon_page.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/coupons/offer_card.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/product/product_bloc.dart';

class CouponsPage extends StatefulWidget {
  const CouponsPage({super.key});

  @override
  State<CouponsPage> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CouponEntity> _filterCoupons(List<CouponEntity> coupons) {
    if (_searchQuery.isEmpty) return coupons;
    return coupons.where((coupon) {
      return coupon.name.toLowerCase().contains(_searchQuery.toLowerCase());
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
        child: const AddCouponPage(), // No couponToEdit passed for adding
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
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          // Refresh list after success
          context.read<CouponBloc>().add(LoadingCouponsEvent());
        } else if (state is FailureCouponsState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
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
                color: AppColors.blackHeading,
              ),
            ),
            elevation: 0,
            backgroundColor: AppColors.backgroundColor,
          ),
          backgroundColor: AppColors.backgroundColor,
          body: Builder(
            builder: (context) {
              if (state is LoadingCouponState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is LoadedCouponsState) {
                final allCoupons = state.coupons;
                final displayCoupons = _filterCoupons(allCoupons);

                if (allCoupons.isEmpty) {
                   return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.local_offer_outlined,
                            size: 64,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No offers found',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () => _showAddOfferDialog(context),
                            icon: const Icon(Icons.add_circle_outline),
                            label: const Text('Add Offer'),
                             style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                          ),
                        ],
                      ),
                    );
                }

                return Column(
                  children: [
                    // Header Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
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
                                    color: AppColors.blackHeading,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${allCoupons.length} ${allCoupons.length == 1 ? 'offer' : 'offers'} available',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _showAddOfferDialog(context),
                            icon: const Icon(Icons.add_circle_outline, size: 20),
                            label: Text(
                              'Add Offer',
                              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 2,
                            ),
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
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search offers...',
                          hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400),
                          prefixIcon: const Icon(Icons.search, color: AppColors.charcoal),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: Colors.grey),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
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
                                'No offers match "$_searchQuery"',
                                style: GoogleFonts.poppins(color: Colors.grey.shade600),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              itemCount: displayCoupons.length,
                              itemBuilder: (context, index) {
                                return OfferCard(offer: displayCoupons[index]);
                              },
                            ),
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