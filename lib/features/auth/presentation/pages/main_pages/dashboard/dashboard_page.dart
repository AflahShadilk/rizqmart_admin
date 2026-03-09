import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/order_recieved_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/dashboard/dashboard_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/dashboard/dashboard_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/dashboard/dashboard_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/order/order_received_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/order/order_received_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/order/order_received_state.dart';
import 'package:rizqmartadmin/widgets/animated_hover_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(const FetchDashboardStatsEvent());
    context.read<OrderReceivedBloc>().add(const FetchNewOrdersEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<DashboardBloc>().add(const FetchDashboardStatsEvent());
          context.read<OrderReceivedBloc>().add(const FetchNewOrdersEvent());
        },
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderSection(theme, colorScheme),
                  40.h,
                  Text(
                    'Business Overview',
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.white : AppColors.dashboardDark1,
                    ),
                  ),
                  20.h,
                  BlocBuilder<DashboardBloc, DashboardState>(
                    builder: (context, state) {
                      if (state is DashboardLoading) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(40),
                            child: CircularProgressIndicator(
                              color: colorScheme.primary,
                            ),
                          ),
                        );
                      }
                      if (state is DashboardError) {
                        return Center(
                          child: Text(
                            'Error: ${state.message}',
                            style: TextStyle(color: colorScheme.error),
                          ),
                        );
                      }
                      if (state is DashboardLoaded) {
                        return LayoutBuilder(builder: (context, constraints) {
                          double width = constraints.maxWidth;
                          int crossAxisCount =
                              width >= 1100 ? 4 : (width >= 700 ? 2 : 1);
                          double childAspectRatio =
                              width >= 1100 ? 2.5 : (width >= 700 ? 2.2 : (width >= 400 ? 2.8 : 2.2));

                          return GridView.count(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 24,
                            mainAxisSpacing: 24,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            childAspectRatio: childAspectRatio,
                            children: [
                              _buildStatCard(
                                theme,
                                'Daily Revenue',
                                '₹${state.stats.dailyRevenue.toStringAsFixed(2)}',
                                Icons.currency_rupee,
                                AppColors.emerald,
                              ),
                              _buildStatCard(
                                theme,
                                'Total Orders',
                                state.stats.totalOrders.toString(),
                                Icons.shopping_bag_outlined,
                                AppColors.chartBlue,
                              ),
                              _buildStatCard(
                                theme,
                                'Pending Orders',
                                state.stats.pendingOrders.toString(),
                                Icons.hourglass_top_rounded,
                                AppColors.amber,
                              ),
                              _buildStatCard(
                                theme,
                                'Total Users',
                                state.stats.totalUsers.toString(),
                                Icons.people_outline,
                                AppColors.purple,
                              ),
                            ],
                          );
                        });
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  40.h,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Orders',
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.white : AppColors.dashboardDark1,
                        ),
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => context.go('/order'),
                        icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                        label: Text(
                          'View All',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  20.h,
                  _buildRecentOrdersOrStatus(theme, colorScheme),
                  40.h,
                  Text(
                    'Quick Access',
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.white : AppColors.dashboardDark1,
                    ),
                  ),
                  20.h,
                  LayoutBuilder(builder: (context, constraints) {
                    double width = constraints.maxWidth;
                    int crossAxisCount =
                        width >= 1100 ? 4 : (width >= 700 ? 3 : 2);
                    // Use a squarer ratio on small screens to give cards more height
                    double aspectRatio = crossAxisCount <= 2 ? (width >= 400 ? 1.2 : 0.9) : 1.6;
                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: crossAxisCount <= 2 ? 16 : 24,
                      mainAxisSpacing: crossAxisCount <= 2 ? 16 : 24,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: aspectRatio,
                      children: [
                        _buildQuickAccessCard(
                          theme,
                          'Add Product',
                          Icons.add_box_outlined,
                          AppColors.chartBlue,
                          () => context.go('/Addproducts'),
                        ),
                        _buildQuickAccessCard(
                          theme,
                          'Manage Orders',
                          Icons.shopping_cart_outlined,
                          AppColors.amber,
                          () => context.go('/order'),
                        ),
                        _buildQuickAccessCard(
                          theme,
                          'Sales Report',
                          Icons.analytics_outlined,
                          AppColors.emerald,
                          () => context.go('/salesReport'),
                        ),
                        _buildQuickAccessCard(
                          theme,
                          'Manage Users',
                          Icons.group_outlined,
                          AppColors.purple,
                          () => context.go('/users'),
                        ),
                      ],
                    );
                  }),
                  32.h,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(ThemeData theme, ColorScheme colorScheme) {
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)] // Deep slate
              : [const Color(0xFF2DD4BF), const Color(0xFF0D9488)], // Calming Teal
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isDark 
                ? AppColors.black.withValues(alpha: 0.3)
                : AppColors.teal.withValues(alpha: 0.2),
            blurRadius: 24,
            offset: const Offset(0, 8),
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
                  'Welcome Back, Admin! 👋',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                10.h,
                Text(
                  'Here is what is happening with your store today.',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: AppColors.white.withValues(alpha: 0.85),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: const Icon(
              Icons.dashboard_rounded,
              color: AppColors.white,
              size: 34,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      ThemeData theme, String title, String value, IconData icon, Color color) {

    return AnimatedHoverCard(
      color: theme.cardTheme.color,
      borderRadius: BorderRadius.circular(20),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            16.w,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      value,
                      style: GoogleFonts.inter(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: theme.textTheme.bodyLarge?.color,
                        letterSpacing: -0.5,
                      ),
                      maxLines: 1,
                    ),
                  ),
                  4.h,
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }

  Widget _buildQuickAccessCard(ThemeData theme, String title, IconData icon,
      Color color, VoidCallback onTap) {
    return AnimatedHoverCard(
      color: theme.cardTheme.color,
      borderRadius: BorderRadius.circular(20),
      padding: const EdgeInsets.all(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: color.withValues(alpha: 0.2),
                ),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            10.h,
            Flexible(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: theme.textTheme.bodyLarge?.color,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentOrdersOrStatus(ThemeData theme, ColorScheme colorScheme) {

    return BlocBuilder<OrderReceivedBloc, OrderReceivedState>(
      builder: (context, state) {
        if (state is OrderReceivedLoading) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: CircularProgressIndicator(color: colorScheme.primary),
            ),
          );
        }

        List<OrderReceivedEntity> orders = [];
        if (state is NewOrdersLoaded) {
          orders = state.orders;
        } else if (state is OrdersByStatusLoaded) {
          orders = state.orders;
        }

        if (orders.isEmpty) {
          if (state is OrderReceivedError) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Could not load orders: ${state.message}',
                style: TextStyle(color: colorScheme.error),
              ),
            );
          }
          return Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.08),
              ),
            ),
            child: Center(
              child: Text(
                'No recent orders yet.',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
            ),
          );
        }

        final recentOrders = orders.take(5).toList();

        return AnimatedHoverCard( 
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          padding: EdgeInsets.zero,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentOrders.length,
                separatorBuilder: (context, index) => Divider(
                  color: colorScheme.outline.withValues(alpha: 0.08),
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  final order = recentOrders[index];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        context.go('/order');
                      },
                      hoverColor: colorScheme.primary.withValues(alpha: 0.03),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                              child: Text(
                                order.userName.isNotEmpty
                                    ? order.userName[0].toUpperCase()
                                    : '?',
                                style: GoogleFonts.inter(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            16.w,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order #${order.orderNumber}',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: theme.textTheme.bodyLarge?.color,
                                    ),
                                  ),
                                  4.h,
                                  Text(
                                    '${order.itemCount} items • ${DateFormat('MMM dd, HH:mm').format(order.createdAt)}',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13,
                                      color: theme.textTheme.bodySmall?.color,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '₹${order.totalAmount.toStringAsFixed(2)}',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                    color: theme.textTheme.bodyLarge?.color,
                                  ),
                                ),
                                8.h,
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(order.orderStatus)
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    order.orderStatus.toUpperCase(),
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: _getStatusColor(order.orderStatus),
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.amber;
      case 'processing':
        return AppColors.chartBlue;
      case 'shipped':
        return AppColors.purple;
      case 'received':
        return AppColors.emerald;
      case 'cancelled':
        return AppColors.chartRed;
      default:
        return AppColors.slate;
    }
  }
}

