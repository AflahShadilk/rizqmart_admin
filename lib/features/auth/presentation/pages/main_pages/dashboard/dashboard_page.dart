import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
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
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderSection(theme, colorScheme),
                  32.h,
                  Text(
                    'Business Overview',
                    style: theme.textTheme.headlineMedium,
                  ),
                  16.h,
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
                              width >= 1100 ? 2.2 : (width >= 700 ? 2.0 : 2.8);

                          return GridView.count(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            childAspectRatio: childAspectRatio,
                            children: [
                              _buildStatCard(
                                theme,
                                'Daily Revenue',
                                state.stats.dailyRevenue.toStringAsFixed(2),
                                Icons.currency_rupee,
                                const Color(0xFF10B981),
                              ),
                              _buildStatCard(
                                theme,
                                'Total Orders',
                                state.stats.totalOrders.toString(),
                                Icons.shopping_bag_outlined,
                                const Color(0xFF3B82F6),
                              ),
                              _buildStatCard(
                                theme,
                                'Pending Orders',
                                state.stats.pendingOrders.toString(),
                                Icons.hourglass_top_rounded,
                                const Color(0xFFF59E0B),
                              ),
                              _buildStatCard(
                                theme,
                                'Total Users',
                                state.stats.totalUsers.toString(),
                                Icons.people_outline,
                                const Color(0xFF8B5CF6),
                              ),
                            ],
                          );
                        });
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  32.h,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Orders',
                        style: theme.textTheme.headlineMedium,
                      ),
                      TextButton.icon(
                        onPressed: () => context.go('/order'),
                        icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                        label: const Text('View All'),
                      ),
                    ],
                  ),
                  16.h,
                  _buildRecentOrdersOrStatus(theme, colorScheme),
                  32.h,
                  Text(
                    'Quick Access',
                    style: theme.textTheme.headlineMedium,
                  ),
                  16.h,
                  LayoutBuilder(builder: (context, constraints) {
                    double width = constraints.maxWidth;
                    int crossAxisCount =
                        width >= 1100 ? 4 : (width >= 700 ? 3 : 2);
                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 1.5,
                      children: [
                        _buildQuickAccessCard(
                          theme,
                          'Add Product',
                          Icons.add_box_outlined,
                          const Color(0xFF3B82F6),
                          () => context.go('/Addproducts'),
                        ),
                        _buildQuickAccessCard(
                          theme,
                          'Manage Orders',
                          Icons.shopping_cart_outlined,
                          const Color(0xFFF59E0B),
                          () => context.go('/order'),
                        ),
                        _buildQuickAccessCard(
                          theme,
                          'Sales Report',
                          Icons.analytics_outlined,
                          const Color(0xFF10B981),
                          () => context.go('/salesReport'),
                        ),
                        _buildQuickAccessCard(
                          theme,
                          'Manage Users',
                          Icons.group_outlined,
                          const Color(0xFF8B5CF6),
                          () => context.go('/users'),
                        ),
                      ],
                    );
                  }),
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
              : [const Color(0xFF0F172A), const Color(0xFF1E3A5F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back, Admin!',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                8.h,
                Text(
                  'Here is what is happening with your store today.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.dashboard_outlined,
              color: colorScheme.primary,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      ThemeData theme, String title, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          12.w,
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
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                    maxLines: 1,
                  ),
                ),
                2.h,
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 12,
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.15),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            12.h,
            Text(
              title,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: theme.textTheme.bodyLarge?.color,
              ),
              textAlign: TextAlign.center,
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
              padding: const EdgeInsets.all(20),
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
            return Text(
              'Could not load orders: ${state.message}',
              style: TextStyle(color: colorScheme.error),
            );
          }
          return Text(
            'No recent orders.',
            style: theme.textTheme.bodyMedium,
          );
        }

        final recentOrders = orders.take(5).toList();

        return Container(
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.15),
            ),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentOrders.length,
            separatorBuilder: (context, index) => Divider(
              color: colorScheme.outline.withValues(alpha: 0.1),
              height: 1,
            ),
            itemBuilder: (context, index) {
              final order = recentOrders[index];
              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                leading: CircleAvatar(
                  backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                  child: Text(
                    order.userName.isNotEmpty
                        ? order.userName[0].toUpperCase()
                        : '?',
                    style: GoogleFonts.inter(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                title: Text(
                  'Order #${order.orderNumber}',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                subtitle: Text(
                  '${order.itemCount} items • ${DateFormat('MMM dd, HH:mm').format(order.createdAt)}',
                  style: theme.textTheme.bodySmall,
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      order.totalAmount.toStringAsFixed(2),
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    4.h,
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order.orderStatus)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        order.orderStatus.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: _getStatusColor(order.orderStatus),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  context.go('/order');
                },
              );
            },
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'processing':
        return const Color(0xFF3B82F6);
      case 'shipped':
        return const Color(0xFF8B5CF6);
      case 'received':
        return const Color(0xFF10B981);
      case 'cancelled':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF64748B);
    }
  }
}