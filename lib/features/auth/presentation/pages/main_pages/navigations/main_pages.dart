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
    {'icon': Icons.dashboard_outlined, 'title': 'Dashboard', 'route': '/dashBoard'},
    {'icon': Icons.shopping_bag_outlined, 'title': 'Products', 'route': '/products'},
    {'icon': Icons.category_outlined, 'title': 'Categories', 'route': '/category'},
    {'icon': Icons.tune_outlined, 'title': 'Variants', 'route': '/unitPage'},
    {'icon': Icons.branding_watermark_outlined, 'title': 'Brands', 'route': '/brand'},
    {'icon': Icons.bar_chart_outlined, 'title': 'Sales Report', 'route': '/salesReport'},
    {'icon': Icons.people_outline, 'title': 'Users', 'route': '/users'},
    {'icon': Icons.account_balance_wallet_outlined, 'title': 'Payments', 'route': '/payment'},
    {'icon': Icons.local_offer_outlined, 'title': 'Offers', 'route': '/coupons'},
    {'icon': Icons.shopping_cart_outlined, 'title': 'Orders', 'route': '/order'},
    {'icon': Icons.chat_bubble_outline, 'title': 'Chat', 'route': '/chat'},
    {'icon': Icons.settings_outlined, 'title': 'Settings', 'route': '/settings'},
  ];

  void onDrawerItemTap(int index) {
    context.read<DrawerSelectedIndexCubit>().setSelectedIndex(index);
    GoRouter.of(context).go(drawerItems[index]['route']);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: appBarRizq(context),
      drawer: BlocBuilder<DrawerSelectedIndexCubit, int>(
        builder: (context, selectedIndex) {
          return Drawer(
            backgroundColor: theme.drawerTheme.backgroundColor,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary.withValues(alpha: 0.15),
                        AppColors.transparent,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.storefront_outlined,
                          color: colorScheme.primary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Rizq Mart',
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Admin Panel',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.white60,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: drawerItems.length,
                    itemBuilder: (context, idx) {
                      final item = drawerItems[idx];
                      final isSelected = selectedIndex == idx;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: ListTile(
                          leading: Icon(
                            item['icon'],
                            color: isSelected
                                ? colorScheme.primary
                                : AppColors.white60,
                            size: 22,
                          ),
                          title: Text(
                            item['title'],
                            style: GoogleFonts.inter(
                              color: isSelected
                                  ? colorScheme.primary
                                  : AppColors.white70,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          selected: isSelected,
                          selectedTileColor:
                              colorScheme.primary.withValues(alpha: 0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          dense: true,
                          visualDensity: const VisualDensity(vertical: -1),
                          onTap: () => onDrawerItemTap(idx),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      body: widget.child,
    );
  }
}