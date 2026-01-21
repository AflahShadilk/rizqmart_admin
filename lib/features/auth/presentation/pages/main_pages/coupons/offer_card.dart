import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/coupon_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/coupon_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/coupons/add_coupon_page.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/product/product_bloc.dart';

class OfferCard extends StatelessWidget {
  final CouponEntity offer;

  const OfferCard({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            // Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade100,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: offer.imageurl.isNotEmpty
                    ? Image.network(
                        offer.imageurl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.local_offer, color: Colors.grey),
                      )
                    : const Icon(Icons.local_offer, color: Colors.blueAccent, size: 30),
              ),
            ),
            const SizedBox(width: 20),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    offer.name, // Display Name / Code
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackHeading,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.currency_rupee, size: 14, color: Colors.grey.shade600),
                      Text(
                         (offer.percentage ?? 0) > 0 
                            ? '${offer.percentage}% OFF' 
                            : '${offer.amount ?? 0} OFF',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.blueAccent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: offer.isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          offer.isActive ? "Active" : "Inactive",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: offer.isActive ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                   Text(
                    'Min Order: ₹${offer.minOrderValue} | Using: ${offer.usageLimit}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey.shade500,
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
                    // Edit Logic


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
                  icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                  tooltip: 'Edit Offer',
                ),
                IconButton(
                  onPressed: () {
                    // Delete Logic
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Offer'),
                        content: Text('Are you sure you want to delete ${offer.name}?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<CouponBloc>().add(DeletingCouponEvent(offer.id));
                              Navigator.pop(context);
                            },
                            child: const Text('Delete', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
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
