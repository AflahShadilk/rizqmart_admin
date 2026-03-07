// ignore_for_file: curly_braces_in_flow_control_structures, unused_local_variable

import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/order_recieved_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/order/order_received_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/order/order_received_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/order/order_received_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/order/print_order.dart';
import 'package:go_router/go_router.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/page_decoration/respnsive_page.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/order/order_page_cubit.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/order/order_page_cubit_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/order/order_status_dialog_cubit.dart';

class OrderReceivedPage extends StatelessWidget {
  const OrderReceivedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderPageCubit(),
      child: const _OrderReceivedPageView(),
    );
  }
}

class _OrderReceivedPageView extends StatefulWidget {
  const _OrderReceivedPageView();

  @override
  State<_OrderReceivedPageView> createState() => _OrderReceivedPageViewState();
}

class _OrderReceivedPageViewState extends State<_OrderReceivedPageView> {
  late OrderReceivedBloc _orderBloc;
  late PageController _pageController;
  int itemsPerPage = 12;

  @override
  void initState() {
    super.initState();
    _orderBloc = context.read<OrderReceivedBloc>();
    _pageController = PageController();
    _orderBloc.add(const FetchNewOrdersEvent());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        toolbarHeight: 70,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.matBlue.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.shopping_cart,
                color: AppColors.matBlue.shade700,
                size: 24,
              ),
            ),
            12.w,
             Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Received',
                  style: TextStyle(
                    color: theme.textTheme.bodyLarge?.color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Manage incoming orders',
                  style: TextStyle(
                    color: theme.textTheme.bodySmall?.color,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              icon: Icon(Icons.refresh, color: AppColors.matBlue.shade700),
              tooltip: 'Refresh',
              onPressed: () {
                _orderBloc.add(const FetchNewOrdersEvent());
              },
            ),
          ),
        ],
      ),
      body: BlocListener<OrderReceivedBloc, OrderReceivedState>(
        listener: (context, state) {
          if (state is OrderStatusUpdated) {
            showSnackBar(context, state.message, AppColors.matBlueAccent);
          } else if (state is OrderMarkedAsReceived) {
            showSnackBar(context, state.message, AppColors.matGreen);
          } else if (state is OrderReceivedError) {
            showSnackBar(context, 'Error: ${state.message}', AppColors.matRed);
          }
        },
        child: Container(
          color: theme.scaffoldBackgroundColor,
        child: Container(
          color: theme.scaffoldBackgroundColor,
          child: CustomScrollView(
            slivers: [
              // 1. Top Stats Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: BlocBuilder<OrderReceivedBloc, OrderReceivedState>(
                    builder: (context, state) {
                      int totalOrders = 0;
                      if (state is NewOrdersLoaded) {
                        totalOrders = state.orders.length;
                      } else if (state is OrdersByStatusLoaded) {
                        totalOrders = state.orders.length;
                      }

                      // Modern Gradient Stats Card
                      return Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.matBlue.shade900, AppColors.matBlue.shade500],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.matBlue.withValues(alpha: 0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.white.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'Processing Dashboard',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                16.h,
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      totalOrders.toString(),
                                      style: const TextStyle(
                                        color: AppColors.white,
                                        fontSize: 48,
                                        height: 1,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    8.w,
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 6),
                                      child: Text(
                                        'Orders to process',
                                        style: TextStyle(
                                          color: AppColors.white70,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                8.h,
                                Text(
                                  'Payments verified & ready for fulfillment',
                                  style: TextStyle(
                                    color: AppColors.white.withValues(alpha: 0.6),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.analytics_outlined,
                                size: 48,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              // 2. Filters Section
              SliverToBoxAdapter(
                child: Container(
                  color: theme.cardTheme.color,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  margin: const EdgeInsets.only(bottom: 24),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ('all', 'All Orders', Icons.list, AppColors.matBlue),
                        ('pending', 'Pending', Icons.hourglass_bottom, AppColors.amber),
                        ('processing', 'Processing', Icons.build, AppColors.matBlue),
                        ('shipped', 'Shipped', Icons.local_shipping, AppColors.matIndigo),
                        ('out for delivery', 'Out for Delivery', Icons.directions_bike, AppColors.matTeal),
                        ('delivered', 'Delivered', Icons.done_all, AppColors.matGreen[800]),
                        ('received', 'Received', Icons.check_circle, AppColors.matGreen),
                        ('cancelled', 'Cancelled', Icons.cancel, AppColors.matRed),
                      ]
                          .asMap()
                          .entries
                          .map((entry) {
                        final index = entry.key;
                        final filters = [
                          ('all', 'All Orders', Icons.list, AppColors.matBlue),
                          ('pending', 'Pending', Icons.hourglass_bottom, AppColors.amber),
                          ('processing', 'Processing', Icons.build, AppColors.matBlue),
                          ('shipped', 'Shipped', Icons.local_shipping, AppColors.matIndigo),
                          ('out for delivery', 'Out for Delivery', Icons.directions_bike, AppColors.matTeal),
                          ('delivered', 'Delivered', Icons.done_all, AppColors.matGreen[800]),
                          ('received', 'Received', Icons.check_circle, AppColors.matGreen),
                          ('cancelled', 'Cancelled', Icons.cancel, AppColors.matRed),
                        ];
                        final filter = entry.value;
                        final isSelected = context.watch<OrderPageCubit>().state.selectedFilter == filter.$1;
                        
                        // Modern Filter Chip look
                        return Padding(
                          padding: EdgeInsets.only(right: index < filters.length - 1 ? 12 : 0),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            child: FilterChip(
                              avatar: Icon(filter.$3, size: 16, color: isSelected ? filter.$4 : AppColors.grey[500]),
                              label: Text(filter.$2),
                              selected: isSelected,
                              backgroundColor: AppColors.white,
                              selectedColor: filter.$4!.withValues(alpha: 0.08),
                              elevation: isSelected ? 0 : 2,
                              pressElevation: 0,
                              shadowColor: AppColors.black.withValues(alpha: 0.05),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                                side: BorderSide(
                                  color: isSelected ? filter.$4! : AppColors.grey[200]!,
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              showCheckmark: false,
                              labelPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              labelStyle: TextStyle(
                                color: isSelected ? filter.$4 : AppColors.grey[700],
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                fontSize: 13,
                              ),
                              onSelected: (selected) {
                                context.read<OrderPageCubit>().updateFilter(filter.$1);

                                if (filter.$1 == 'all') {
                                  _orderBloc.add(const FetchNewOrdersEvent());
                                } else {
                                  _orderBloc.add(
                                    FetchOrdersByStatusEvent(status: filter.$1),
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

              // 3. Grid/List of Orders
              BlocBuilder<OrderReceivedBloc, OrderReceivedState>(
                builder: (context, state) {
                  if (state is OrderReceivedLoading) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             CircularProgressIndicator(),
                             SizedBox(height: 16),
                             Text('Loading orders...'),
                          ],
                        ),
                      ),
                    );
                  }

                  List<OrderReceivedEntity> orders = [];
                  if (state is NewOrdersLoaded) {
                    orders = state.orders;
                  } else if (state is OrdersByStatusLoaded) {
                    orders = state.orders;
                  } else if (state is OrderReceivedError) {
                     return SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 48, color: AppColors.matRed[300]),
                            const SizedBox(height: 16),
                            Text('Error: ${state.message}', style: const TextStyle(color: AppColors.matRed)),
                          ],
                        ),
                      ),
                    );
                  }

                  if (orders.isEmpty) {
                     return SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox, size: 64, color: AppColors.grey[300]),
                            const SizedBox(height: 16),
                            Text('No orders found', style: TextStyle(color: AppColors.grey[600], fontSize: 16)),
                          ],
                        ),
                      ),
                    );
                  }

                  // Pagination Logic Handled by Cubit
                  final cubit = context.read<OrderPageCubit>();
                  final currentPage = context.watch<OrderPageCubit>().state.currentPage;
                  
                  List<OrderReceivedEntity> paginatedOrders = cubit.getPaginatedList(orders, itemsPerPage);

                  final isMobile = MediaQuery.of(context).size.width < 768;

                  if (isMobile) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
                            child: orderCardMobile(paginatedOrders[index]),
                          );
                        },
                        childCount: paginatedOrders.length,
                      ),
                    );
                  } else {
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: MediaQuery.of(context).size.width > 1400 ? 4 : 3,
                          childAspectRatio: 0.95, // Standard card ratio (between 0.75 and 1.5)
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return orderCardDesktop(paginatedOrders[index]);
                          },
                          childCount: paginatedOrders.length,
                        ),
                      ),
                    );
                  }
                },
              ),

              // 4. Pagination Footer
               BlocBuilder<OrderReceivedBloc, OrderReceivedState>(
                builder: (context, state) {
                   List<OrderReceivedEntity> orders = [];
                  if (state is NewOrdersLoaded) orders = state.orders;
                  else if (state is OrdersByStatusLoaded) orders = state.orders;
                  
                  if (orders.isEmpty) return const SliverToBoxAdapter(child: SizedBox());

                  final totalPages = context.read<OrderPageCubit>().getTotalPages(orders.length, itemsPerPage);
                  
                  if (totalPages <= 1) return const SliverToBoxAdapter(child: SizedBox(height: 32));

                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 32, bottom: 32),
                      child: paginationWidget(totalPages),
                    ),
                  );
                }
               ),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget paginationWidget(int totalPages) {
    final theme = Theme.of(context);
    return BlocBuilder<OrderPageCubit, OrderPageState>(
      builder: (context, pageState) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: pageState.currentPage > 1
                  ? () {
                      context.read<OrderPageCubit>().previousPage();
                    }
                  : null,
            ),
            ...List.generate(totalPages, (index) {
              final pageNum = index + 1;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                  onPressed: () {
                    context.read<OrderPageCubit>().setPage(pageNum);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        pageState.currentPage == pageNum ? theme.colorScheme.primary : theme.colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    pageNum.toString(),
                    style: TextStyle(
                      color: pageState.currentPage == pageNum ? theme.colorScheme.onPrimary : theme.textTheme.bodyLarge?.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: pageState.currentPage < totalPages
                  ? () {
                      context.read<OrderPageCubit>().nextPage();
                    }
                  : null,
            ),
          ],
        );
      },
    );
  }

  /// Mobile view for an individual order card with modern shadows and layouts
  Widget orderCardMobile(OrderReceivedEntity order) {
    return Container(
      decoration: BoxDecoration(
        color:AppColors.white,
        borderRadius: BorderRadius.circular(Responsive.scaleRadius(context, 14)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.grey.shade100, width: 1.5),
      ),
      child: Padding(
        padding: EdgeInsets.all(Responsive.scaleSpacing(context, 16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${order.orderNumber}',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: Responsive.scaleFont(context, 14),
                          color: AppColors.black87,
                        ),
                      ),
                      SizedBox(height: Responsive.scaleSpacing(context, 4)),
                      Text(
                        order.userName,
                        style: TextStyle(
                          fontSize: Responsive.scaleFont(context, 12),
                          color: AppColors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.scaleSpacing(context, 10),
                    vertical: Responsive.scaleSpacing(context, 4),
                  ),
                  decoration: BoxDecoration(
                    color: getStatusColor(order.orderStatus).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Responsive.scaleRadius(context, 6)),
                    border: Border.all(
                      color: getStatusColor(order.orderStatus).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    order.orderStatus.toUpperCase(),
                    style: TextStyle(
                      fontSize: Responsive.scaleFont(context, 9),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: getStatusColor(order.orderStatus),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Responsive.scaleSpacing(context, 12)),
            Container(height: 1, color: AppColors.grey.shade100),
            SizedBox(height: Responsive.scaleSpacing(context, 12)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₹${order.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: Responsive.scaleFont(context, 16),
                        color: AppColors.matGreen.shade700,
                      ),
                    ),
                    SizedBox(height: Responsive.scaleSpacing(context, 4)),
                    Text(
                      '${order.itemCount} items • ${DateFormat('dd MMM').format(order.createdAt)}',
                      style: TextStyle(
                        fontSize: Responsive.scaleFont(context, 11),
                        color: AppColors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => showDetailsModal(context, order),
                  icon: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.matBlue),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.matBlue.withValues(alpha: 0.05),
                    padding: const EdgeInsets.all(10),
                  ),
                ),
              ],
            ),
            SizedBox(height: Responsive.scaleSpacing(context, 12)),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (order.userId.isNotEmpty) {
                        context.push('/chat_details', extra: {
                          'chatId': order.orderId,
                          'userId': order.userId,
                          'productName': 'Order ${order.orderNumber}',
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Cannot chat: User ID missing')),
                        );
                      }
                    },
                    icon: Icon(Icons.chat_bubble_rounded, size: Responsive.scaleFont(context, 14), color: AppColors.matBlue.shade700),
                    label: Text('Chat', style: TextStyle(fontSize: Responsive.scaleFont(context, 11), color: AppColors.matBlue.shade700, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.matBlue.shade50,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: Responsive.scaleSpacing(context, 10)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                SizedBox(width: Responsive.scaleSpacing(context, 10)),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => showStatusDialog(context, order.orderId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.matBlue.shade600,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: Responsive.scaleSpacing(context, 10)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      'Update',
                      style: TextStyle(fontSize: Responsive.scaleFont(context, 11), color: AppColors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Desktop view for an individual order card with modern hover-ready aesthetics
  Widget orderCardDesktop(OrderReceivedEntity order) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(Responsive.scaleRadius(context, 14)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.grey.shade100, width: 1.5),
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: () => showDetailsModal(context, order),
          borderRadius: BorderRadius.circular(Responsive.scaleRadius(context, 14)),
          hoverColor: AppColors.matBlue.withValues(alpha: 0.02),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(Responsive.scaleSpacing(context, 16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order #${order.orderNumber}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: Responsive.scaleFont(context, 13),
                                  color: AppColors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: Responsive.scaleSpacing(context, 4)),
                              Text(
                                order.userName,
                                style: TextStyle(
                                  fontSize: Responsive.scaleFont(context, 11),
                                  color: AppColors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Responsive.scaleSpacing(context, 8),
                            vertical: Responsive.scaleSpacing(context, 4),
                          ),
                          decoration: BoxDecoration(
                            color: getStatusColor(order.orderStatus).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(Responsive.scaleRadius(context, 6)),
                            border: Border.all(
                              color: getStatusColor(order.orderStatus).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            order.orderStatus.toUpperCase(),
                            style: TextStyle(
                              fontSize: Responsive.scaleFont(context, 8),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              color: getStatusColor(order.orderStatus),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Responsive.scaleSpacing(context, 8)),
                    Container(height: 1, color: AppColors.grey.shade100),
                    SizedBox(height: Responsive.scaleSpacing(context, 8)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '₹${order.totalAmount.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: Responsive.scaleFont(context, 16),
                                color: AppColors.matGreen.shade700,
                              ),
                            ),
                            SizedBox(height: Responsive.scaleSpacing(context, 4)),
                            Text(
                              '${order.itemCount} items',
                              style: TextStyle(
                                fontSize: Responsive.scaleFont(context, 10),
                                color: AppColors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          DateFormat('dd MMM, HH:mm').format(order.createdAt),
                          style: TextStyle(
                            fontSize: Responsive.scaleFont(context, 9),
                            color:AppColors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: Responsive.scaleSpacing(context, 8)),
                Column(
                  children: [
                    if (order.userId.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(bottom: Responsive.scaleSpacing(context, 8)),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              context.push('/chat_details', extra: {
                                'chatId': order.orderId,
                                'userId': order.userId,
                                'productName': 'Order ${order.orderNumber}',
                              });
                            },
                            icon: Icon(Icons.chat_bubble_rounded, size: Responsive.scaleFont(context, 12), color: AppColors.matBlue.shade700),
                            label: Text('Message', style: TextStyle(fontSize: Responsive.scaleFont(context, 10), color: AppColors.matBlue.shade700, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.matBlue.shade50,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(vertical: Responsive.scaleSpacing(context, 10)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => showDetailsModal(context, order),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.grey.shade100,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(vertical: Responsive.scaleSpacing(context, 10)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text(
                              'Details',
                              style: TextStyle(fontSize: Responsive.scaleFont(context, 10), color: AppColors.grey.shade800, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(width: Responsive.scaleSpacing(context, 8)),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => showStatusDialog(context, order.orderId),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.matBlue.shade600,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(vertical: Responsive.scaleSpacing(context, 10)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text(
                              'Update',
                              style: TextStyle(fontSize: Responsive.scaleFont(context, 10), color: AppColors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (order.orderStatus != 'received' && order.orderStatus != 'cancelled' && order.orderStatus != 'delivered')
                      Padding(
                        padding: EdgeInsets.only(top: Responsive.scaleSpacing(context, 8)),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => confirmMarkAsReceived(
                              context,
                              order.orderId,
                              order.orderNumber,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.matGreen.shade600,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(vertical: Responsive.scaleSpacing(context, 10)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text(
                              'Mark Received',
                              style: TextStyle(fontSize: Responsive.scaleFont(context, 10), color: AppColors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Displays a detailed modal for a specific order with modern styling
  void showDetailsModal(BuildContext context, OrderReceivedEntity order) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 10,
        backgroundColor: AppColors.white,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Modal Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                  color: AppColors.matBlue.shade50,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Order Details',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.black87,
                          ),
                        ),
                        SizedBox(height: Responsive.scaleSpacing(context, 4)),
                        Text(
                          'Order #${order.orderNumber}',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.matBlue.shade800,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Tooltip(
                          message: 'Save as PDF',
                          child: IconButton(
                            icon: const Icon(Icons.download, size: 20),
                            onPressed: () => saveOrderPdf(context, order),
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.white,
                              foregroundColor: AppColors.matBlue.shade700,
                            ),
                          ),
                        ),
                        SizedBox(width: Responsive.scaleSpacing(context, 8)),
                        Tooltip(
                          message: 'Print Order',
                          child: IconButton(
                            icon: const Icon(Icons.print, size: 20),
                            onPressed: () => printOrderDetail(context, order),
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.white,
                              foregroundColor: AppColors.matBlue.shade700,
                            ),
                          ),
                        ),
                        SizedBox(width: Responsive.scaleSpacing(context, 8)),
                        Tooltip(
                          message: 'Close',
                          child: IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            onPressed: () => Navigator.pop(context),
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.white,
                              foregroundColor: AppColors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Modal Body
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order Info Section
                      detailSection(
                        'Order Information',
                        [
                          detailItem('Order ID', order.orderId),
                          detailItem('Date & Time', DateFormat('dd MMM yyyy, HH:mm').format(order.createdAt)),
                          detailItem('Order Status', order.orderStatus.toUpperCase()),
                          detailItem('Payment Status', order.paymentStatus),
                          detailItem('Payment Method', order.paymentMethod),
                          if (order.deliveryMethod != null)
                            detailItem('Delivery Method', order.deliveryMethod!),
                        ],
                      ),
                      SizedBox(height: Responsive.scaleSpacing(context, 24)),

                      // Customer Info Section
                      detailSection(
                        'Customer Information',
                        [
                          detailItem('Full Name', order.userName),
                          detailItem('Email', order.userEmail),
                          detailItem('Phone', order.userPhone),
                        ],
                      ),
                      SizedBox(height: Responsive.scaleSpacing(context, 24)),

                      // Delivery Section
                      detailSection(
                        'Delivery Address',
                        [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.location_on, size: 18, color: AppColors.matBlue.shade600),
                              SizedBox(width: Responsive.scaleSpacing(context, 8)),
                              Expanded(
                                child: Text(
                                  order.deliveryAddress,
                                  style: const TextStyle(fontSize: 13, height: 1.5),
                                ),
                              ),
                            ],
                          ),
                          if (order.deliveryNotes != null && order.deliveryNotes!.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: Responsive.scaleSpacing(context, 12)),
                              child: Container(
                                padding: EdgeInsets.all(Responsive.scaleSpacing(context, 12)),
                                decoration: BoxDecoration(
                                  color: AppColors.matAmber.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.matAmber.shade200),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.note, size: 16, color: AppColors.matAmber.shade700),
                                    SizedBox(width: Responsive.scaleSpacing(context, 8)),
                                    Expanded(
                                      child: Text(
                                        'Notes: ${order.deliveryNotes}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.matAmber.shade900,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: Responsive.scaleSpacing(context, 24)),

                      // Order Items Section
                      if (order.items.isNotEmpty)
                        detailSection(
                          'Order Items (${order.items.length})',
                          [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.grey.shade200),
                              ),
                              child: Column(
                                children: order.items.asMap().entries.map((entry) {
                                  final item = entry.value;
                                  final isLast = entry.key == order.items.length - 1;
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(Responsive.scaleSpacing(context, 16)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.productName,
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(height: Responsive.scaleSpacing(context, 4)),
                                                  if (item.unit != null)
                                                    Text(
                                                      item.unit!,
                                                      style: TextStyle(fontSize: 11, color: AppColors.grey.shade500),
                                                    ),
                                                  Text(
                                                    'Qty: ${item.quantity.toInt()} × ₹${item.mrp.toStringAsFixed(2)}',
                                                    style: TextStyle(fontSize: 12, color: AppColors.grey.shade600),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  '₹${(item.mrp * item.quantity).toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (!isLast) Divider(color: AppColors.grey.shade200, height: 1),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: Responsive.scaleSpacing(context, 24)),

                      // Price Breakdown Section
                      Container(
                        padding: EdgeInsets.all(Responsive.scaleSpacing(context, 20)),
                        decoration: BoxDecoration(
                          color: AppColors.matBlue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Subtotal', style: TextStyle(fontSize: 13, color: AppColors.grey.shade700)),
                                Text('₹${order.subtotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                              ],
                            ),
                            SizedBox(height: Responsive.scaleSpacing(context, 8)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Delivery Fee', style: TextStyle(fontSize: 13, color: AppColors.grey.shade700)),
                                Text('₹${order.deliveryFee.toStringAsFixed(2)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                              ],
                            ),
                            if (order.discount > 0) ...[
                              SizedBox(height: Responsive.scaleSpacing(context, 8)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Discount', style: TextStyle(fontSize: 13, color: AppColors.matGreen.shade700)),
                                  Text('-₹${order.discount.toStringAsFixed(2)}', style: TextStyle(fontSize: 13, color: AppColors.matGreen.shade700, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ],
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: Responsive.scaleSpacing(context, 16)),
                              child: Divider(color: AppColors.matBlue.shade200, height: 1),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total Amount',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  '₹${order.totalAmount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.matGreen.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Modal Footer Controls
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border(top: BorderSide(color: AppColors.grey.shade200)),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          side: BorderSide(color: AppColors.grey.shade300),
                        ),
                        child: Text('Close', style: TextStyle(color: AppColors.grey.shade700, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    SizedBox(width: Responsive.scaleSpacing(context, 16)),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          showStatusDialog(context, order.orderId);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.matBlue.shade600,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        child: const Text('Update Status', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  if (order.orderStatus != 'received') ...[
                    12.w,
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          confirmMarkAsReceived(
                            context,
                            order.orderId,
                            order.orderNumber,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.matGreen,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                           shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Mark Received'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
 
  Widget detailSection(String title, List<Widget> items) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.matBlue.withValues(alpha: 0.05),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          border: Border(
            left: BorderSide(color: AppColors.matBlue, width: 4),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: AppColors.matBlue,
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
          border: Border(
            bottom: BorderSide(color: AppColors.grey[200]!),
            left: BorderSide(color: AppColors.grey[200]!),
            right: BorderSide(color: AppColors.grey[200]!),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items.asMap().entries.map((entry) {
            final isLast = entry.key == items.length - 1;
            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
              child: entry.value,
            );
          }).toList(),
        ),
      ),
    ],
  );
}

Widget detailItem(String label, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          color: AppColors.grey[700],
        ),
      ),
      16.w,
      Expanded(
        child: Text(
          value,
          textAlign: TextAlign.end,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.grey[900],
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.visible,
        ),
      ),
    ],
  );
}


  /// Displays a dialog to update the order's status using a Cubit to manage state
  void showStatusDialog(BuildContext context, String orderId) {
    final statuses = ['pending', 'processing', 'shipped', 'out for delivery', 'delivered', 'received', 'cancelled'];

    showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (_) => OrderStatusDialogCubit('pending'),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            constraints: const BoxConstraints(maxWidth: 400),
            child: BlocBuilder<OrderStatusDialogCubit, String>(
              builder: (context, selectedStatus) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Update Order Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    20.h,
                    // Status Dropdown Container
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: selectedStatus,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: statuses
                            .map((status) => DropdownMenuItem(
                                  value: status,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      status.toUpperCase(),
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            context.read<OrderStatusDialogCubit>().updateStatus(value);
                          }
                        },
                      ),
                    ),
                    24.h,
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                        ),
                        12.w,
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _orderBloc.add(
                                UpdateOrderStatusEvent(
                                  orderId: orderId,
                                  status: selectedStatus,
                                ),
                              );
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.matBlue,
                            ),
                            child: const Text('Update'),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void confirmMarkAsReceived(
    BuildContext context,
    String orderId,
    String orderNumber,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 48,
                color: AppColors.matGreen[400],
              ),
              16.h,
              const Text(
                'Mark Order as Received',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              12.h,
              Text(
                'Are you sure you want to mark Order #$orderNumber as received?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.grey[700],
                ),
              ),
              24.h,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  12.w,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _orderBloc.add(
                          MarkOrderAsReceivedEvent(orderId: orderId),
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.matGreen,
                      ),
                      child: const Text('Confirm'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String message, Color bgColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: bgColor,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  /// Helper to convert status strings into appropriate UI colors
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.amber;
      case 'processing':
        return AppColors.matBlue;
      case 'shipped':
        return AppColors.indigo;
      case 'out for delivery':
        return AppColors.teal;
      case 'delivered':
        return AppColors.matGreen[800]!;
      case 'received':
        return AppColors.matGreen;
      case 'cancelled':
        return AppColors.matRed;
      default:
        return AppColors.grey;
    }
  }
}