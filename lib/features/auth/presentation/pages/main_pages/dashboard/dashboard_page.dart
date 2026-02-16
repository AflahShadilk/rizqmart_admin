// ignore_for_file: deprecated_member_use, unused_local_variable

import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/order_recieved_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/dashboard/dashboard_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/dashboard/dashboard_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/dashboard/dashboard_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/order/order_received_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/order/order_received_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/order/order_received_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/page_decoration/respnsive_page.dart';

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
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
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
                 
                  _buildHeaderSection(),
                  32.h,
    
              
                  const Text(
                    'Business Overview',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  16.h,
                  BlocBuilder<DashboardBloc, DashboardState>(
                    builder: (context, state) {
                      if (state is DashboardLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is DashboardError) {
                        return Center(child: Text('Error: ${state.message}'));
                      }
                      if (state is DashboardLoaded) {
                        return LayoutBuilder(builder: (context, constraints) {
                      double width = constraints.maxWidth;
                      int crossAxisCount = width >= 1100 ? 4 : (width >= 700 ? 2 : 1);
                      double childAspectRatio = width >= 1100 ? 2.2 : (width >= 700 ? 2.0 : 2.8);
                      
                      return GridView.count(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: childAspectRatio,
                        children: [
                          _buildStatCard('Total Revenue', '₹${state.stats.totalRevenue.toStringAsFixed(2)}', Icons.currency_rupee, Colors.green),
                          _buildStatCard('Total Orders', state.stats.totalOrders.toString(), Icons.shopping_bag, Colors.blue),
                          _buildStatCard('Pending Orders', state.stats.pendingOrders.toString(), Icons.hourglass_top, Colors.orange),
                          _buildStatCard('Total Users', state.stats.totalUsers.toString(), Icons.people, Colors.purple),
                        ],
                      );
                    });    
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  32.h,
    
                  // 3. Recent Orders
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Orders',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      TextButton(
                        onPressed: () => context.go('/order'),
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  16.h,
                  _buildRecentOrdersOrStatus(),
                  
                  32.h,
                  
                  // 4. Quick Access Grid (Optional additional navigation)
                   const Text(
                    'Quick Access',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  16.h,
                   LayoutBuilder(builder: (context, constraints) {
                   double width = constraints.maxWidth;
                   int crossAxisCount = width >= 1100 ? 4 : (width >= 700 ? 3 : 2);
                    return GridView.count(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.5,
                    children: [
                      _buildQuickAccessCard('Add Product', Icons.add_box, Colors.blue, () => context.go('/Addproducts')),
                      _buildQuickAccessCard('Manage Orders', Icons.shopping_cart, Colors.orange, () => context.go('/order')),
                      _buildQuickAccessCard('Sales Report', Icons.analytics, Colors.green, () => context.go('/salesReport')),
                      _buildQuickAccessCard('Manage Users', Icons.group, Colors.purple, () => context.go('/users')),
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

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.darkBlue, Colors.blue.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome Back, Admin!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                8.h,
                Text(
                  'Here is what is happening with your store today.',
                  style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.dashboard, color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
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
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                    maxLines: 1,
                  ),
                ),
                2.h,
                Text(
                  title,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
  
  Widget _buildQuickAccessCard(String title, IconData icon, Color color, VoidCallback onTap) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
             border: Border.all(color: Colors.grey.shade200),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              12.h,
              Text(
                title, 
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
  }

  Widget _buildRecentOrdersOrStatus() {
    return BlocBuilder<OrderReceivedBloc, OrderReceivedState>(
      builder: (context, state) {
        if (state is OrderReceivedLoading) {
           return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
        }
        
        List<OrderReceivedEntity> orders = [];
        if (state is NewOrdersLoaded) {
          orders = state.orders;
        } else if (state is OrdersByStatusLoaded) {
           orders = state.orders;
        }

        if (orders.isEmpty) {
           if (state is OrderReceivedError) {
              return Text('Could not load orders: ${state.message}');
           }
           return const Text('No recent orders.');
        }

        // Show top 5 orders
        final recentOrders = orders.take(5).toList();

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
             boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentOrders.length,
            separatorBuilder: (context, index) => Divider(color: Colors.grey.shade100, height: 1),
            itemBuilder: (context, index) {
              final order = recentOrders[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade50,
                  child: Text(
                     order.userName.isNotEmpty ? order.userName[0].toUpperCase() : '?',
                     style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text('Order #${order.orderNumber}', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${order.itemCount} items • ${DateFormat('MMM dd, HH:mm').format(order.createdAt)}'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('₹${order.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    4.h,
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                         color: _getStatusColor(order.orderStatus).withOpacity(0.1),
                         borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        order.orderStatus.toUpperCase(),
                        style: TextStyle(fontSize: 10, color: _getStatusColor(order.orderStatus), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                   // Navigate to order details or order page
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
      case 'pending': return Colors.orange;
      case 'processing': return Colors.blue;
      case 'shipped': return Colors.purple;
      case 'received': return Colors.green;
      case 'cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }
}