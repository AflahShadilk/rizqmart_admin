// ignore_for_file: curly_braces_in_flow_control_structures, unused_local_variable

import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/order_recieved_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/order/order_received_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/order/order_received_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/order/order_received_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/order/print_order.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/widgets/animated_hover_card.dart';
import 'package:rizqmartadmin/widgets/grid_list_toggle.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/page_decoration/respnsive_page.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/order/order_page_cubit.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/order/order_page_cubit_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/order/order_status_dialog_cubit.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/order/order_details_dialog.dart';

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
  bool isGridView = true;

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
          Center(
            child: GridListToggle(
              isGridView: isGridView,
              onToggle: (val) {
                setState(() {
                  isGridView = val;
                });
              },
            ),
          ),
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
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // 1. Top Stats Section (In Scroll)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                        child: BlocBuilder<OrderReceivedBloc, OrderReceivedState>(
                          builder: (context, state) {
                            int totalOrders = 0;
                            if (state is NewOrdersLoaded) {
                              totalOrders = state.orders.length;
                            } else if (state is OrdersByStatusLoaded) {
                              totalOrders = state.orders.length;
                            }

                            return Container(
                              padding: const EdgeInsets.all(28),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [AppColors.matBlue.shade900, AppColors.matIndigo.shade700],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.matBlue.withValues(alpha: 0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.dashboard_customize_rounded, color: AppColors.white.withValues(alpha: 0.9), size: 20),
                                          8.w,
                                          Text(
                                            'Processing Dashboard',
                                            style: TextStyle(
                                              color: AppColors.white.withValues(alpha: 0.9),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                      16.h,
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.baseline,
                                        textBaseline: TextBaseline.alphabetic,
                                        children: [
                                          Text(
                                            totalOrders.toString(),
                                            style: const TextStyle(
                                              color: AppColors.white,
                                              fontSize: 56,
                                              height: 1,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          8.w,
                                          Text(
                                            'Orders',
                                            style: TextStyle(
                                              color: AppColors.white.withValues(alpha: 0.8),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      8.h,
                                      Text(
                                        'Ready for fulfillment & processing',
                                        style: TextStyle(
                                          color: AppColors.white.withValues(alpha: 0.7),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (MediaQuery.of(context).size.width > 400)
                                    Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: AppColors.white.withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                        border: Border.all(color: AppColors.white.withValues(alpha: 0.2), width: 1.5),
                                      ),
                                      child: const Icon(
                                        Icons.inventory_2_rounded,
                                        size: 52,
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

                    // 2. Filters Section (In Scroll)
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _FilterHeaderDelegate(
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.scaffoldBackgroundColor,
                            boxShadow: [
                              BoxShadow(
                                color: theme.scaffoldBackgroundColor.withValues(alpha: 0.9),
                                blurRadius: 8,
                                spreadRadius: 4,
                              )
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Row(
                              children: [
                                ('all', 'All Orders', Icons.grid_view_rounded, AppColors.grey),
                                ('pending', 'Pending', Icons.schedule_rounded, AppColors.amber),
                                ('processing', 'Processing', Icons.autorenew_rounded, AppColors.matBlue),
                                ('shipped', 'Shipped', Icons.local_shipping_rounded, AppColors.matIndigo),
                                ('out for delivery', 'Out for Delivery', Icons.directions_bike_rounded, AppColors.matTeal),
                                ('delivered', 'Delivered', Icons.task_alt_rounded, AppColors.matGreen[700]),
                                ('received', 'Received', Icons.inventory_rounded, AppColors.matGreen),
                                ('cancelled', 'Cancelled', Icons.cancel_rounded, AppColors.matRed),
                              ].map((filter) {
                                final isSelected = context.watch<OrderPageCubit>().state.selectedFilter == filter.$1;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: InkWell(
                                    onTap: () {
                                      context.read<OrderPageCubit>().updateFilter(filter.$1);
                                      if (filter.$1 == 'all') {
                                        _orderBloc.add(const FetchNewOrdersEvent());
                                      } else {
                                        _orderBloc.add(FetchOrdersByStatusEvent(status: filter.$1));
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(30),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 250),
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: isSelected ? filter.$4!.withValues(alpha: 0.1) : theme.cardTheme.color,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color: isSelected ? filter.$4! : AppColors.grey.shade200,
                                          width: isSelected ? 1.5 : 1.0,
                                        ),
                                        boxShadow: isSelected 
                                          ? [] 
                                          : [BoxShadow(color: AppColors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2))],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            filter.$3, 
                                            size: 18, 
                                            color: isSelected ? filter.$4 : AppColors.grey.shade500,
                                          ),
                                          8.w,
                                          Text(
                                            filter.$2,
                                            style: TextStyle(
                                              color: isSelected ? filter.$4 : AppColors.grey.shade700,
                                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
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

                        // Pagination Logic
                        final cubit = context.read<OrderPageCubit>();
                        List<OrderReceivedEntity> paginatedOrders = cubit.getPaginatedList(orders, itemsPerPage);
                        final isMobile = MediaQuery.of(context).size.width < 768;

                        if (isGridView) {
                          return SliverPadding(
                            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24, vertical: 8),
                            sliver: SliverGrid(
                              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 380, // Responsive width threshold
                                mainAxisExtent: 320, // Fixed height specifically for the modern tall card
                                crossAxisSpacing: isMobile ? 12 : 16,
                                mainAxisSpacing: isMobile ? 12 : 16,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  return orderCardDesktop(paginatedOrders[index]);
                                },
                                childCount: paginatedOrders.length,
                              ),
                            ),
                          );
                        } else {
                          // List View Layout
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: isMobile ? 12 : 16, 
                                    left: isMobile ? 16 : 24, 
                                    right: isMobile ? 16 : 24
                                  ),
                                  child: Center(
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(maxWidth: 900),
                                      child: orderCardMobile(paginatedOrders[index]),
                                    ),
                                  ),
                                );
                              },
                              childCount: paginatedOrders.length,
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
                  ],  // slivers
                ),  // CustomScrollView
              ),  // Expanded
            ],
          ),
        ),
      ));
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

  /// Mobile view for an individual order card with modern aesthetics
  Widget orderCardMobile(OrderReceivedEntity order) {
    final theme = Theme.of(context);
    final statusColor = getStatusColor(order.orderStatus);

    return AnimatedHoverCard(
      padding: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.cardTheme.color ?? theme.scaffoldBackgroundColor,
              statusColor.withValues(alpha: 0.03),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header: Status and Date
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: statusColor.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                        ),
                        6.w,
                        Text(
                          order.orderStatus.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: statusColor,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    DateFormat('MMM dd, yyyy • HH:mm').format(order.createdAt),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            
            // Order Number
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Order #${order.orderNumber}',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: theme.textTheme.bodyLarge?.color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            12.h,
            
            // User and Items info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.matBlue.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.person, size: 16, color: AppColors.matBlue.shade700),
                  ),
                  12.w,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.userName,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        2.h,
                        Text(
                          '${order.itemCount} Items',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '₹${order.totalAmount.toStringAsFixed(2)}',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.matGreen.shade700,
                    ),
                  ),
                ],
              ),
            ),
            
            16.h,
            
            // Action Buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: theme.dividerColor.withValues(alpha: 0.05))),
                color: theme.scaffoldBackgroundColor.withValues(alpha: 0.5),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: OutlinedButton.icon(
                      onPressed: () => showOrderDetailsModal(
                        context, order,
                        onSavePdf: () => saveOrderPdf(context, order),
                        onPrint: () => printOrderDetail(context, order),
                        onUpdateStatus: () => showStatusDialog(context, order.orderId),
                        onMarkReceived: () => confirmMarkAsReceived(context, order.orderId, order.orderNumber),
                      ),
                      icon: const Icon(Icons.receipt_long, size: 16),
                      label: const Text('Details'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.matBlue,
                        side: BorderSide(color: AppColors.matBlue.withValues(alpha: 0.3)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  8.w,
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.matBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      onPressed: () {
                        context.push('/chat_details', extra: {
                          'chatId': order.orderId,
                          'productName': 'Order #${order.orderNumber}',
                          'userId': order.userId,
                        });
                      },
                      icon: Icon(Icons.chat_bubble_outline, color: AppColors.matBlue.shade700, size: 20),
                      tooltip: 'Chat with Buyer',
                    ),
                  ),
                  8.w,
                  Expanded(
                    flex: 5,
                    child: ElevatedButton.icon(
                      onPressed: () => showStatusDialog(context, order.orderId),
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Status'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.matGreen,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Desktop view for an individual order card with modern hover-ready aesthetics
  Widget orderCardDesktop(OrderReceivedEntity order) {
    final theme = Theme.of(context);
    final statusColor = getStatusColor(order.orderStatus);

    return AnimatedHoverCard(
      padding: EdgeInsets.zero,
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.cardTheme.color ?? theme.scaffoldBackgroundColor,
              statusColor.withValues(alpha: 0.02),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section (Status & Date)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: statusColor.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                          ),
                          6.w,
                          Flexible(
                            child: Text(
                              order.orderStatus.toUpperCase(),
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: statusColor,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  8.w,
                  Expanded(
                    flex: 1,
                    child: Text(
                      DateFormat('MMM dd, yyyy').format(order.createdAt),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            
            // Order ID
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Order #${order.orderNumber}',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: theme.textTheme.bodyLarge?.color,
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            16.h,
            
            // Customer Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.matBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.person, size: 20, color: AppColors.matBlue.shade700),
                  ),
                  12.w,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Customer',
                          style: GoogleFonts.inter(fontSize: 11, color: AppColors.grey.shade500),
                        ),
                        2.h,
                        Text(
                          order.userName,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const Spacer(),
            
            // Stats Row (Items & Total)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(color: theme.dividerColor.withValues(alpha: 0.05)),
                ),
                color: theme.scaffoldBackgroundColor.withValues(alpha: 0.3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Items',
                        style: GoogleFonts.inter(fontSize: 12, color: AppColors.grey.shade500),
                      ),
                      2.h,
                      Text(
                        '${order.itemCount}',
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: theme.textTheme.bodyLarge?.color),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total',
                        style: GoogleFonts.inter(fontSize: 12, color: AppColors.grey.shade500),
                      ),
                      2.h,
                      Text(
                        '₹${order.totalAmount.toStringAsFixed(2)}',
                        style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.matGreen.shade700),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: OutlinedButton(
                      onPressed: () => showOrderDetailsModal(
                        context, order,
                        onSavePdf: () => saveOrderPdf(context, order),
                        onPrint: () => printOrderDetail(context, order),
                        onUpdateStatus: () => showStatusDialog(context, order.orderId),
                        onMarkReceived: () => confirmMarkAsReceived(context, order.orderId, order.orderNumber),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.matBlue,
                        side: BorderSide(color: AppColors.matBlue.withValues(alpha: 0.3)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Details', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  8.w,
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.matBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      onPressed: () {
                        context.push('/chat_details', extra: {
                          'chatId': order.orderId,
                          'productName': 'Order #${order.orderNumber}',
                          'userId': order.userId,
                        });
                      },
                      icon: Icon(Icons.chat_bubble_outline, color: AppColors.matBlue.shade700, size: 20),
                      tooltip: 'Chat with Buyer',
                    ),
                  ),
                  8.w,
                  Expanded(
                    flex: 5,
                    child: ElevatedButton(
                      onPressed: () => showStatusDialog(context, order.orderId),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.matGreen,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Status', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Displays a modern bottom/dialog layout to update the order's status
  void showStatusDialog(BuildContext context, String orderId) {
    final statuses = [
      ('pending', Icons.schedule_rounded),
      ('processing', Icons.autorenew_rounded),
      ('shipped', Icons.local_shipping_rounded),
      ('out for delivery', Icons.directions_bike_rounded),
      ('delivered', Icons.task_alt_rounded),
      ('received', Icons.inventory_rounded),
      ('cancelled', Icons.cancel_rounded),
    ];

    showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (_) => OrderStatusDialogCubit('pending'),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(Responsive.scaleSpacing(context, 24)),
            constraints: const BoxConstraints(maxWidth: 420),
            child: BlocBuilder<OrderStatusDialogCubit, String>(
              builder: (context, selectedStatus) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Update Order Status',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.black87,
                      ),
                    ),
                    SizedBox(height: Responsive.scaleSpacing(context, 8)),
                    Text(
                      'Select the new status for this order. This will instantly update the user.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: Responsive.scaleSpacing(context, 24)),
                    // Modern selectable status chips
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: statuses.map((statusItem) {
                        final statusValue = statusItem.$1;
                        final icon = statusItem.$2;
                        final isSelected = selectedStatus == statusValue;
                        final color = getStatusColor(statusValue);

                        return Material(
                          color: AppColors.transparent,
                          child: InkWell(
                            onTap: () => context.read<OrderStatusDialogCubit>().updateStatus(statusValue),
                            borderRadius: BorderRadius.circular(30),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.symmetric(
                                horizontal: Responsive.scaleSpacing(context, 16),
                                vertical: Responsive.scaleSpacing(context, 10),
                              ),
                              decoration: BoxDecoration(
                                color: isSelected ? color.withValues(alpha: 0.1) : AppColors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: isSelected ? color : AppColors.grey.shade300,
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(icon, size: 16, color: isSelected ? color : AppColors.grey.shade600),
                                  SizedBox(width: Responsive.scaleSpacing(context, 8)),
                                  Text(
                                    statusValue.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: Responsive.scaleFont(context, 11),
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                      color: isSelected ? color : AppColors.grey.shade700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: Responsive.scaleSpacing(context, 32)),
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: Responsive.scaleSpacing(context, 16)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              side: BorderSide(color: AppColors.grey.shade300),
                            ),
                            child: Text('Cancel', style: TextStyle(color: AppColors.grey.shade700, fontWeight: FontWeight.w600)),
                          ),
                        ),
                        SizedBox(width: Responsive.scaleSpacing(context, 12)),
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
                              backgroundColor: AppColors.matBlue.shade700,
                              padding: EdgeInsets.symmetric(vertical: Responsive.scaleSpacing(context, 16)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                            ),
                            child: const Text('Update Status', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
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
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.all(Responsive.scaleSpacing(context, 24)),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(Responsive.scaleSpacing(context, 16)),
                decoration: BoxDecoration(
                  color: AppColors.matGreen.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_outline,
                  size: 48,
                  color: AppColors.matGreen.shade600,
                ),
              ),
              SizedBox(height: Responsive.scaleSpacing(context, 16)),
              const Text(
                'Mark Order as Received',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.black87,
                ),
              ),
              SizedBox(height: Responsive.scaleSpacing(context, 12)),
              Text(
                'Are you sure you want to mark Order #$orderNumber as received? This action cannot be undone.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.grey.shade600,
                  height: 1.4,
                ),
              ),
              SizedBox(height: Responsive.scaleSpacing(context, 24)),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: Responsive.scaleSpacing(context, 16)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        side: BorderSide(color: AppColors.grey.shade300),
                      ),
                      child: Text('Cancel', style: TextStyle(color: AppColors.grey.shade700, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  SizedBox(width: Responsive.scaleSpacing(context, 12)),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _orderBloc.add(
                          MarkOrderAsReceivedEvent(orderId: orderId),
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.matGreen.shade600,
                        padding: EdgeInsets.symmetric(vertical: Responsive.scaleSpacing(context, 16)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      child: const Text('Confirm', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
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

class _FilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _FilterHeaderDelegate({required this.child});

  @override
  double get minExtent => 72.0;

  @override
  double get maxExtent => 72.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_FilterHeaderDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}