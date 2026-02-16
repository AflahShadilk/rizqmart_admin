// ignore_for_file: deprecated_member_use

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
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 70,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.shopping_cart,
                color: Colors.blue.shade700,
                size: 24,
              ),
            ),
            12.w,
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Received',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Manage incoming orders',
                  style: TextStyle(
                    color: Colors.grey,
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
              icon: Icon(Icons.refresh, color: Colors.blue.shade700),
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
            showSnackBar(context, state.message, AppColors.blueAccent);
          } else if (state is OrderMarkedAsReceived) {
            showSnackBar(context, state.message, AppColors.green);
          } else if (state is OrderReceivedError) {
            showSnackBar(context, 'Error: ${state.message}', AppColors.red);
          }
        },
        child: Container(
          color: Colors.grey[50],
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                  child: BlocBuilder<OrderReceivedBloc, OrderReceivedState>(
                    builder: (context, state) {
                      int totalOrders = 0;

                      if (state is NewOrdersLoaded) {
                        totalOrders = state.orders.length;
                      } else if (state is OrdersByStatusLoaded) {
                        totalOrders = state.orders.length;
                      }

                      return Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade400, Colors.blue.shade600],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'New Orders Awaiting Processing',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                12.h,
                                Text(
                                  totalOrders.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                8.h,
                                const Text(
                                  'Payment verified - Ready to process',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.check_circle,
                              size: 80,
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                24.h,
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ('all', 'All Orders', Icons.list, Colors.blue),
                        ('pending', 'Pending', Icons.hourglass_bottom, Colors.orange),
                        ('processing', 'Processing', Icons.build, Colors.purple),
                        ('shipped', 'Shipped', Icons.local_shipping, Colors.indigo),
                        ('received', 'Received', Icons.check_circle, Colors.green),
                      ]
                          .asMap()
                          .entries
                          .map((entry) {
                        final index = entry.key;
                        final filters = [
                          ('all', 'All Orders', Icons.list, Colors.blue),
                          ('pending', 'Pending', Icons.hourglass_bottom, Colors.orange),
                          ('processing', 'Processing', Icons.build, Colors.purple),
                          ('shipped', 'Shipped', Icons.local_shipping, Colors.indigo),
                          ('received', 'Received', Icons.check_circle, Colors.green),
                        ];
                        final filter = entry.value;
                        return Padding(
                          padding: EdgeInsets.only(right: index < filters.length - 1 ? 8 : 0),
                          child: FilterChip(
                            avatar: Icon(filter.$3, size: 16),
                            label: Text(filter.$2),
                            selected: context.watch<OrderPageCubit>().state.selectedFilter == filter.$1,
                            backgroundColor: Colors.grey[100],
                            selectedColor: filter.$4.withOpacity(0.2),
                            side: BorderSide(
                              color: context.watch<OrderPageCubit>().state.selectedFilter == filter.$1
                                  ? filter.$4
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                            labelStyle: TextStyle(
                              color: context.watch<OrderPageCubit>().state.selectedFilter == filter.$1
                                  ? filter.$4
                                  : Colors.grey[600],
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
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
                        );
                      }).toList(),
                    ),
                  ),
                ),
                24.h,
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16 : 24,
                  ),
                  child: BlocBuilder<OrderReceivedBloc, OrderReceivedState>(
                    builder: (context, state) {
                      if (state is OrderReceivedLoading) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(64),
                            child: Column(
                              children: [
                                const CircularProgressIndicator(),
                                16.h,
                                Text(
                                  'Loading orders...',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
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
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: Colors.red[300],
                                ),
                                16.h,
                                Text(
                                  'Error: ${state.message}',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (orders.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(64),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.inbox,
                                  size: 64,
                                  color: Colors.grey[300],
                                ),
                                16.h,
                                Text(
                                  'No orders found',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                8.h,
                                Text(
                                  'Check back later for new orders',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final currentPage = context.read<OrderPageCubit>().state.currentPage;
                      int totalPages = (orders.length / itemsPerPage).ceil();
                      
                      // Fix: Ensure currentPage is valid
                      if (currentPage > totalPages && totalPages > 0) {
                        context.read<OrderPageCubit>().setPage(totalPages);
                      } else if (totalPages == 0) {
                        context.read<OrderPageCubit>().setPage(1);
                      }

                      int startIndex = (context.watch<OrderPageCubit>().state.currentPage - 1) * itemsPerPage;
                      int endIndex = (startIndex + itemsPerPage).clamp(0, orders.length);
                      
                      // Fix: Ensure startIndex is valid
                      if (startIndex >= orders.length && orders.isNotEmpty) {
                        startIndex = 0;
                        endIndex = itemsPerPage.clamp(0, orders.length);
                        context.read<OrderPageCubit>().setPage(1);
                      }
                      
                      List<OrderReceivedEntity> paginatedOrders =
                          orders.sublist(startIndex, endIndex);

                      if (isMobile) {
                        return Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: paginatedOrders.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: orderCardMobile(paginatedOrders[index]),
                                );
                              },
                            ),
                            if (totalPages > 1)
                              Padding(
                                padding: const EdgeInsets.only(top: 24),
                                child: paginationWidget(totalPages),
                              ),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: MediaQuery.of(context).size.width > 1400 ? 4 : 3,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                              itemCount: paginatedOrders.length,
                              itemBuilder: (context, index) {
                                return orderCardDesktop(paginatedOrders[index]);
                              },
                            ),
                            if (totalPages > 1)
                              Padding(
                                padding: const EdgeInsets.only(top: 32),
                                child: paginationWidget(totalPages),
                              ),
                          ],
                        );
                      }
                    },
                  ),
                ),
                32.h,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget paginationWidget(int totalPages) {
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
                        pageState.currentPage == pageNum ? Colors.blue : Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    pageNum.toString(),
                    style: TextStyle(
                      color: pageState.currentPage == pageNum ? Colors.white : Colors.black,
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

  Widget orderCardMobile(OrderReceivedEntity order) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Responsive.scaleRadius(context, 12)),
        side: BorderSide(color: Colors.grey[200]!),
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
                          fontWeight: FontWeight.bold,
                          fontSize: Responsive.scaleFont(context, 14),
                        ),
                      ),
                      SizedBox(height: Responsive.scaleSpacing(context, 4)),
                      Text(
                        order.userName,
                        style: TextStyle(
                          fontSize: Responsive.scaleFont(context, 12),
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.scaleSpacing(context, 10),
                    vertical: Responsive.scaleSpacing(context, 5),
                  ),
                  decoration: BoxDecoration(
                    color: getStatusColor(order.orderStatus).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(Responsive.scaleRadius(context, 20)),
                  ),
                  child: Text(
                    order.orderStatus.toUpperCase(),
                    style: TextStyle(
                      fontSize: Responsive.scaleFont(context, 10),
                      fontWeight: FontWeight.bold,
                      color: getStatusColor(order.orderStatus),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Responsive.scaleSpacing(context, 12)),
            Divider(color: Colors.grey[200]),
            SizedBox(height: Responsive.scaleSpacing(context, 12)),
            Text(
              '₹${order.totalAmount.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Responsive.scaleFont(context, 18),
                color: Colors.green[700],
              ),
            ),
            SizedBox(height: Responsive.scaleSpacing(context, 8)),
            Text(
              '${order.itemCount} items • ${DateFormat('dd MMM').format(order.createdAt)}',
              style: TextStyle(
                fontSize: Responsive.scaleFont(context, 11),
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: Responsive.scaleSpacing(context, 12)),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      if (order.userId.isNotEmpty) {
                        context.push('/chat_details', extra: {
                          'userId': order.userId,
                          'userName': order.userName,
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Cannot chat: User ID missing')),
                        );
                      }
                    },
                    icon: Icon(Icons.chat_bubble_outline, size: Responsive.scaleFont(context, 16)),
                    label: Text('Chat', style: TextStyle(fontSize: Responsive.scaleFont(context, 12))),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: Responsive.scaleSpacing(context, 10)),
                    ),
                  ),
                ),
                SizedBox(width: Responsive.scaleSpacing(context, 8)),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => showStatusDialog(context, order.orderId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: Responsive.scaleSpacing(context, 10)),
                    ),
                    child: Text(
                      'Update',
                      style: TextStyle(fontSize: Responsive.scaleFont(context, 12)),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Responsive.scaleSpacing(context, 8)),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => showDetailsModal(context, order),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: Responsive.scaleSpacing(context, 10)),
                ),
                child: Text(
                  'Details',
                  style: TextStyle(fontSize: Responsive.scaleFont(context, 12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget orderCardDesktop(OrderReceivedEntity order) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Responsive.scaleRadius(context, 12)),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: InkWell(
        onTap: () => showDetailsModal(context, order),
        borderRadius: BorderRadius.circular(Responsive.scaleRadius(context, 12)),
        child: Padding(
          padding: EdgeInsets.all(Responsive.scaleSpacing(context, 16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                fontWeight: FontWeight.bold,
                                fontSize: Responsive.scaleFont(context, 13),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: Responsive.scaleSpacing(context, 4)),
                            Text(
                              order.userName,
                              style: TextStyle(
                                fontSize: Responsive.scaleFont(context, 11),
                                color: Colors.grey[600],
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
                          color: getStatusColor(order.orderStatus).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(Responsive.scaleRadius(context, 12)),
                        ),
                        child: Text(
                          order.orderStatus.toUpperCase(),
                          style: TextStyle(
                            fontSize: Responsive.scaleFont(context, 9),
                            fontWeight: FontWeight.bold,
                            color: getStatusColor(order.orderStatus),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Responsive.scaleSpacing(context, 12)),
                  Divider(color: Colors.grey[200], height: Responsive.scaleSpacing(context, 12)),
                  SizedBox(height: Responsive.scaleSpacing(context, 12)),
                  Text(
                    '₹${order.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.scaleFont(context, 16),
                      color: Colors.green[700],
                    ),
                  ),
                  SizedBox(height: Responsive.scaleSpacing(context, 6)),
                  Text(
                    '${order.itemCount} items',
                    style: TextStyle(
                      fontSize: Responsive.scaleFont(context, 10),
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: Responsive.scaleSpacing(context, 4)),
                  Text(
                    DateFormat('dd MMM, HH:mm').format(order.createdAt),
                    style: TextStyle(
                      fontSize: Responsive.scaleFont(context, 9),
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
              SizedBox(height: Responsive.scaleSpacing(context, 12)),
              Column(
                children: [
                  if (order.userId.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(bottom: Responsive.scaleSpacing(context, 8)),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            context.push('/chat_details', extra: {
                              'userId': order.userId,
                              'userName': order.userName,
                            });
                          },
                          icon: Icon(Icons.chat_bubble_outline, size: Responsive.scaleFont(context, 14)),
                          label: Text('Chat with Customer', style: TextStyle(fontSize: Responsive.scaleFont(context, 11))),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: Responsive.scaleSpacing(context, 10)),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => showDetailsModal(context, order),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: Responsive.scaleSpacing(context, 10)),
                      ),
                      child: Text(
                        'View Details',
                        style: TextStyle(fontSize: Responsive.scaleFont(context, 11)),
                      ),
                    ),
                  ),
                  SizedBox(height: Responsive.scaleSpacing(context, 8)),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => showStatusDialog(context, order.orderId),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: Responsive.scaleSpacing(context, 10)),
                      ),
                      child: Text(
                        'Update Status',
                        style: TextStyle(fontSize: Responsive.scaleFont(context, 11)),
                      ),
                    ),
                  ),
                  if (order.orderStatus != 'received')
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
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(vertical: Responsive.scaleSpacing(context, 10)),
                          ),
                          child: Text(
                            'Mark Received',
                            style: TextStyle(fontSize: Responsive.scaleFont(context, 11)),
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
    );
  }

void showDetailsModal(BuildContext context, OrderReceivedEntity order) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Order Details',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      4.h,
                      Text(
                        'Order #${order.orderNumber}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Tooltip(
                        message: 'Save as PDF',
                        child: IconButton(
                          icon: const Icon(Icons.download),
                          onPressed: () => saveOrderPdf(context, order),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.blue.withOpacity(0.1),
                          ),
                        ),
                      ),
                      8.w,
                      Tooltip(
                        message: 'Print Order',
                        child: IconButton(
                          icon: const Icon(Icons.print),
                          onPressed: () => printOrderDetail(context, order),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.blue.withOpacity(0.1),
                          ),
                        ),
                      ),
                      8.w,
                      //close button
                      Tooltip(
                        message: 'Close',
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.grey.withOpacity(0.1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 32),

              // order info
              detailSection(
                'Order Information',
                [
                  detailItem('Order ID', order.orderId),
                  detailItem('Order Number', order.orderNumber),
                  detailItem(
                    'Date & Time',
                    DateFormat('dd MMM yyyy, HH:mm').format(order.createdAt),
                  ),
                  detailItem('Order Status', order.orderStatus.toUpperCase()),
                  detailItem('Payment Status', order.paymentStatus),
                ],
              ),
              24.h,

              //customer info
              detailSection(
                'Customer Information',
                [
                  detailItem('Full Name', order.userName),
                  detailItem('Email', order.userEmail),
                  detailItem('Phone Number', order.userPhone),
                ],
              ),
              24.h,
               //order details secction
              detailSection(
                'Delivery Address',
                [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.blue,
                        ),
                        8.w,
                        Expanded(
                          child: Text(
                            order.deliveryAddress,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (order.deliveryNotes != null &&
                      order.deliveryNotes!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.note,
                            size: 16,
                            color: Colors.amber,
                          ),
                          8.w,
                          Expanded(
                            child: Text(
                              'Delivery Notes: ${order.deliveryNotes}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              24.h,

              // order details
              if (order.items.isNotEmpty)
                detailSection(
                  'Order Items (${order.items.length})',
                  [
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey[300]!),
                          bottom: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      child: Column(
                        children: order.items.asMap().entries.map((entry) {
                          final item = entry.value;
                          final isLast = entry.key == order.items.length - 1;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.productName,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            'Quantity: ${item.quantity}',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '₹${item.price.toStringAsFixed(2)}',
                                          style:  TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        Text(
                                          '₹${(item.price * item.quantity).toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                if (!isLast)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Divider(
                                      color: Colors.grey[200],
                                      height: 1,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              24.h,

              // ✅ TOTAL AMOUNT
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '₹${order.totalAmount.toStringAsFixed(2)}',
                      style:  TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ),
              32.h,

              // ACTION BUTTONS
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Close'),
                    ),
                  ),
                  12.w,
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showStatusDialog(context, order.orderId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                         shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Update Status'),
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
                          backgroundColor: Colors.green,
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
            ],
          ),
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
          color: Colors.blue.withOpacity(0.05),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          border: Border(
            left: BorderSide(color: Colors.blue, width: 4),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Colors.blue,
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!),
            left: BorderSide(color: Colors.grey[200]!),
            right: BorderSide(color: Colors.grey[200]!),
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
          color: Colors.grey[700],
        ),
      ),
      16.w,
      Expanded(
        child: Text(
          value,
          textAlign: TextAlign.end,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[900],
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.visible,
        ),
      ),
    ],
  );
}


  void showStatusDialog(BuildContext context, String orderId) {
    final statuses = ['pending', 'processing', 'shipped', 'received', 'cancelled'];
    String selectedStatus = 'pending';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
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
                        setState(() {
                          selectedStatus = value;
                        });
                      }
                    },
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
                            UpdateOrderStatusEvent(
                              orderId: orderId,
                              status: selectedStatus,
                            ),
                          );
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text('Update'),
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
                color: Colors.green[400],
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
                  color: Colors.grey[700],
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
                        backgroundColor: Colors.green,
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

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'received':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}