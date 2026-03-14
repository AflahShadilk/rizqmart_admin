// ignore_for_file: curly_braces_in_flow_control_structures, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/order_recieved_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/cubit/order/order_cubit.dart';
import 'package:rizqmartadmin/features/auth/presentation/cubit/order/order_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/order/order_received_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/order/order_received_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/order/order_received_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/order/order_details_dialog.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/order/print_order.dart';
import 'package:rizqmartadmin/widgets/grid_list_toggle.dart';
import 'widgets/order_stats_header.dart';
import 'widgets/order_filter_section.dart';
import 'widgets/order_card_grid.dart';
import 'widgets/order_card_list.dart';
import 'widgets/order_pagination.dart';
import 'widgets/order_status_dialog.dart';
import 'widgets/order_received_dialog.dart';

// ================================================================
// OrderReceivedPage — Lean assembler for the Orders module
// ================================================================

class OrderReceivedPage extends StatelessWidget {
  const OrderReceivedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderCubit(),
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

  @override
  void initState() {
    super.initState();
    _orderBloc = context.read<OrderReceivedBloc>();
    _orderBloc.add(const FetchNewOrdersEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // ---------------- Orders Page AppBar ----------------
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
          // ---------------- Grid/List Toggle ----------------
          Center(
            child: BlocBuilder<OrderCubit, OrderState>(
              builder: (context, cubitState) {
                return GridListToggle(
                  isGridView: cubitState.isGridView,
                  onToggle: (val) {
                    context.read<OrderCubit>().toggleView(val);
                  },
                );
              },
            ),
          ),
          // ---------------- Refresh Button ----------------
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

      // ---------------- Page Body ----------------
      body: BlocListener<OrderReceivedBloc, OrderReceivedState>(
        listener: (context, state) {
          if (state is OrderStatusUpdated) {
            _showSnackBar(context, state.message, AppColors.matBlueAccent);
          } else if (state is OrderMarkedAsReceived) {
            _showSnackBar(context, state.message, AppColors.matGreen);
          } else if (state is OrderReceivedError) {
            _showSnackBar(context, 'Error: ${state.message}', AppColors.matRed);
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
                    // ---------------- 1. Stats Header ----------------
                    const SliverToBoxAdapter(
                      child: OrderStatsHeader(),
                    ),

                    // ---------------- 2. Filter Section ----------------
                    const OrderFilterSection(),

                    // ---------------- 3. Order Grid/List ----------------
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

                        return BlocBuilder<OrderCubit, OrderState>(
                          builder: (context, cubitState) {
                            final cubit = context.read<OrderCubit>();
                            final paginatedOrders = cubit.getPaginatedList(orders);
                            final isMobile = MediaQuery.of(context).size.width < 768;

                            if (cubitState.isGridView) {
                              return SliverPadding(
                                padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24, vertical: 8),
                                sliver: SliverGrid(
                                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 340, // reduced from 380
                                      mainAxisExtent: 290, // reduced from 320
                                      crossAxisSpacing: isMobile ? 12 : 16,
                                      mainAxisSpacing: isMobile ? 12 : 16,
                                    ),
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      return OrderCardGrid(
                                        order: paginatedOrders[index],
                                        onViewDetails: () => _onViewDetails(paginatedOrders[index]),
                                        onUpdateStatus: () => _onUpdateStatus(paginatedOrders[index].orderId),
                                      );
                                    },
                                    childCount: paginatedOrders.length,
                                  ),
                                ),
                              );
                            } else {
                              return SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: isMobile ? 12 : 16,
                                        left: isMobile ? 16 : 24,
                                        right: isMobile ? 16 : 24,
                                      ),
                                      child: Center(
                                        child: ConstrainedBox(
                                          constraints: const BoxConstraints(maxWidth: 900),
                                          child: OrderCardList(
                                            order: paginatedOrders[index],
                                            onViewDetails: () => _onViewDetails(paginatedOrders[index]),
                                            onUpdateStatus: () => _onUpdateStatus(paginatedOrders[index].orderId),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  childCount: paginatedOrders.length,
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),

                    // ---------------- 4. Pagination Footer ----------------
                    BlocBuilder<OrderReceivedBloc, OrderReceivedState>(
                      builder: (context, state) {
                        List<OrderReceivedEntity> orders = [];
                        if (state is NewOrdersLoaded) orders = state.orders;
                        else if (state is OrdersByStatusLoaded) orders = state.orders;

                        if (orders.isEmpty) return const SliverToBoxAdapter(child: SizedBox());

                        final totalPages = context.read<OrderCubit>().getTotalPages(orders.length);
                        if (totalPages <= 1) return const SliverToBoxAdapter(child: SizedBox(height: 32));

                        return SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 32, bottom: 32),
                            child: OrderPagination(totalPages: totalPages),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================================================================
  // Helper Methods
  // ================================================================

  void _onViewDetails(OrderReceivedEntity order) {
    showOrderDetailsModal(
      context, order,
      onSavePdf: () => saveOrderPdf(context, order),
      onPrint: () => printOrderDetail(context, order),
      onUpdateStatus: () => _onUpdateStatus(order.orderId),
      onMarkReceived: () => confirmMarkAsReceived(context, order.orderId, order.orderNumber, _orderBloc),
    );
  }

  void _onUpdateStatus(String orderId) {
    showStatusDialog(context, orderId, _orderBloc);
  }

  void _showSnackBar(BuildContext context, String message, Color bgColor) {
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
}