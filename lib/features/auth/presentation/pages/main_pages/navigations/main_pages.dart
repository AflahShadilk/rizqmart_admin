// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/navigation/drawyer_selected_index_cubit.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/navigations/widgets/appbar.dart';

class MainPages extends StatefulWidget {
  final Widget child;
  const MainPages({super.key, required this.child});

  @override
  State<MainPages> createState() => _MainPagesState();
}

class _MainPagesState extends State<MainPages> {
  final List<Map<String, dynamic>> drawerItems = [
    {'icon': Icons.home, 'title': 'Dashboard', 'route': '/dashBoard'},
    {'icon': Icons.shopping_bag, 'title': 'Products', 'route': '/products'},
    {'icon': Icons.category, 'title': 'Categories', 'route': '/category'},
    {'icon': Icons.select_all, 'title': 'Variants', 'route': '/unitPage'},
    {'icon': Icons.branding_watermark, 'title': 'Brands', 'route': '/brand'},
    {'icon': Icons.bar_chart, 'title': 'Sales Report', 'route': '/sales'},
    {'icon': Icons.people, 'title': 'Users', 'route': '/users'},
    {'icon': Icons.account_balance_wallet, 'title': 'Wallets', 'route': '/wallets'},
    {'icon': Icons.confirmation_num, 'title': 'Coupons', 'route': '/coupons'},
    {'icon': Icons.shopping_cart, 'title': 'Orders', 'route': '/orders'},
  ];

  void onDrawerItemTap(int index) {
    context.read<DrawerSelectedIndexCubit>().setSelectedIndex(index);
    GoRouter.of(context).go(drawerItems[index]['route']);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarRizq(context),
      drawer: BlocBuilder<DrawerSelectedIndexCubit, int>(
        builder: (context, selectedIndex) {
          return Drawer(
            backgroundColor: AppColors.darkBlue,
            child: ListView(
              children: [
                DrawerHeader(
                  child: Text(
                    'Mart Menu',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
                ...drawerItems.asMap().entries.map((entry) {
                  int idx = entry.key;
                  var item = entry.value;
                  return ListTile(
                    leading: Icon(item['icon'], color: Colors.white),
                    title: Text(
                      item['title'],
                      style: GoogleFonts.inter(color: Colors.white),
                    ),
                    selected: selectedIndex == idx,
                    selectedTileColor: AppColors.lightGray.withOpacity(0.2),
                    onTap: () => onDrawerItemTap(idx),
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
      body: widget.child,
    );
  }
}