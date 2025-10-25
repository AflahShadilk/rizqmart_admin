// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:rizqmartadmin/core/constants/appcolor.dart';
// import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/coupon_bloc.dart';
// import 'package:rizqmartadmin/features/auth/presentation/widgets/page_decoration/respnsive_page.dart';

// class CouponsPage extends StatefulWidget {
//   const CouponsPage({super.key});

//   @override
//   State<CouponsPage> createState() => _CouponsPageState();
// }

// class _CouponsPageState extends State<CouponsPage> {
//   bool showAddForm = false;
//   @override
//   Widget build(BuildContext context) {
   
//     final double fontSize;
//     final EdgeInsets padding;

//     if (Responsive.isDesktop(context)) {
//       fontSize = 28;
//       padding = const EdgeInsets.symmetric(horizontal: 120, vertical: 40);
//     } else if (Responsive.isTablet(context)) {
//       fontSize = 22;
//       padding = const EdgeInsets.symmetric(horizontal: 48, vertical: 24);
//     } else {
//       fontSize = 18;
//       padding = const EdgeInsets.all(16);
//     }

//     return BlocConsumer<CouponBloc, CouponsState>(
//       listener: (context, state) {
//         if (state is LoadingCouponSuccessfulState) {
//           ScaffoldMessenger.of(context)
//               .showSnackBar(SnackBar(content: Text(state.message)));
//         } else if (state is FailureCouponsState) {
//           ScaffoldMessenger.of(context)
//               .showSnackBar(SnackBar(content: Text(state.message)));
//         }
//       },
//       builder: (context, state) {
//         return Scaffold(
//           backgroundColor: const Color(0xFFF8F9FA),
//           appBar: AppBar(
//             title: Text(
//               'Coupons',
//               style: GoogleFonts.poppins(
//                 color: AppColors.blackHeading,
//                 fontSize: fontSize,
//                 fontWeight: FontWeight.w900,
//               ),
//             ),
//           ),
//           body: Padding(
//             padding: padding,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     ElevatedButton.icon(
//                       icon: Icon(showAddForm ? Icons.close : Icons.add,color: AppColors.lightBlue,),
//                       label: Text(showAddForm ? "Close Form" : "Add Coupon",style: GoogleFonts.poppins(color: AppColors.charcoal,fontSize: 15,fontWeight: FontWeight.w700),),
//                       onPressed: () {
//                         setState(() => showAddForm = !showAddForm);
//                       },
//                     ),
//                   ],
//                 ),
//                 if (showAddForm) const AddBrandFormWeb(),
//                 const SizedBox(height: 10),
//                 Expanded(
//                   child: Builder(
//                     builder: (context) {
//                       if (state is LoadingCouponState) {
//                         return const Center(
//                             child: CircularProgressIndicator());
//                       } else if (state is LoadedCouponsState) {
//                         final brands = state.coupons;
//                         if (brands.isEmpty) {
//                           return const Center(
//                               child: Text('No coupon found.'));
//                         }
//                         return ListView.builder(
//                           itemCount: brands.length,
//                           itemBuilder: (context, index) =>
//                               BrandCardWeb(brand: brands[index]),
//                         );
//                       } else {
//                         return const SizedBox();
//                       }
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }