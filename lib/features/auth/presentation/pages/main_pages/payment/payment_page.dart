
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/payment_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/payment/payment_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/payment/payment_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/payment/payment_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/payment/payment_page_cubit.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/payment/payment_page_cubit_state.dart';
import 'package:rizqmartadmin/widgets/animated_hover_card.dart';
import 'package:rizqmartadmin/widgets/grid_list_toggle.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentPageCubit(),
      child: const _PaymentPageView(),
    );
  }
}

class _PaymentPageView extends StatefulWidget {
  const _PaymentPageView();

  @override
  State<_PaymentPageView> createState() => _PaymentPageViewState();
}

class _PaymentPageViewState extends State<_PaymentPageView> {
  late PaymentBloc _paymentBloc;
  int itemsPerPage = 12;
  bool isGridView = true;

  @override
  void initState() {
    super.initState();
    _paymentBloc = context.read<PaymentBloc>();
    _paymentBloc.add(const FetchAllPaymentsEvent());
    _paymentBloc.add(const FetchPaymentAnalyticsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    final theme = Theme.of(context);

    return Scaffold(
      appBar: buildPaymentAppBar(theme),
      body: BlocListener<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is PaymentRefunded) {
            buildShowSnackBar(context, state.message, AppColors.matGreen);
          } else if (state is PaymentError) {
            buildShowSnackBar(context, 'Error: ${state.message}', AppColors.matRed);
          }
        },
        child: Container(
          color: theme.scaffoldBackgroundColor,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    buildPaymentHeaderSection(),
                    24.h,
                  ],
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _FilterHeaderDelegate(
                  child: buildPaymentFilterSection(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 24,
                    left: isMobile ? 16 : 24,
                    right: isMobile ? 16 : 24,
                  ),
                  child: buildPaymentContent(isMobile),
                ),
              ),
              SliverToBoxAdapter(
                child: 32.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildPaymentAppBar(ThemeData theme) {
    return AppBar(
      elevation: 0,
      backgroundColor: theme.scaffoldBackgroundColor,
      toolbarHeight: 70,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.matGreen.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.payment,
              color: AppColors.matGreen.shade700,
              size: 24,
            ),
          ),
          12.w,
           Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payments',
                style: TextStyle(
                  color: theme.textTheme.bodyLarge?.color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Transaction history & management',
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
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.refresh, color: AppColors.matGreen.shade700),
                tooltip: 'Refresh',
                onPressed: () {
                  _paymentBloc.add(const FetchAllPaymentsEvent());
                  _paymentBloc.add(const FetchPaymentAnalyticsEvent());
                },
              ),
              8.w,
              PopupMenuButton(
                icon: Icon(Icons.more_vert, color: AppColors.grey.shade600),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Row(
                      children: [
                        const Icon(Icons.download, size: 18),
                        8.w,
                        const Text('Export CSV'),
                      ],
                    ),
                    onTap: () {},
                  ),
                  PopupMenuItem(
                    child: Row(
                      children: [
                        const Icon(Icons.print, size: 18),
                        8.w,
                        const Text('Print'),
                      ],
                    ),
                    onTap: () {
                      final state = _paymentBloc.state;
                      if (state is AllPaymentsLoaded) {
                        _printPaymentList(state.payments);
                      } else if (state is PaymentsByStatusLoaded) {
                        _printPaymentList(state.payments);
                      } else {
                        buildShowSnackBar(context, 'No payments to print', AppColors.amber);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildPaymentHeaderSection() {
    return Container(
      color: Theme.of(context).cardTheme.color,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, state) {
          if (state is PaymentAnalyticsLoaded) {
            final analytics = state.analytics;
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: buildPaymentMetricCard(
                        'Total Revenue',
                        analytics.totalRevenue.toStringAsFixed(2),
                        AppColors.matGreen,
                        Icons.trending_up,
                      ),
                    ),
                    16.w,
                    Expanded(
                      child: buildPaymentMetricCard(
                        'Success Rate',
                        '${analytics.successRate.toStringAsFixed(1)}%',
                        AppColors.matBlue,
                        Icons.check_circle,
                      ),
                    ),
                    16.w,
                    Expanded(
                      child: buildPaymentMetricCard(
                        'Completed',
                        '${analytics.completedCount}',
                        AppColors.matGreen,
                        Icons.done,
                      ),
                    ),
                    16.w,
                    Expanded(
                      child: buildPaymentMetricCard(
                        'Pending',
                        '${analytics.pendingCount}',
                        AppColors.amber,
                        Icons.schedule,
                      ),
                    ),
                  ],
                ),
                16.h,
                Row(
                  children: [
                    Expanded(
                      child: buildPaymentAmountCard(
                        'Completed Amount',
                        analytics.completedAmount.toStringAsFixed(2),
                        AppColors.matGreen,
                      ),
                    ),
                    16.w,
                    Expanded(
                      child: buildPaymentAmountCard(
                        'Pending Amount',
                        analytics.pendingAmount.toStringAsFixed(2),
                        AppColors.amber,
                      ),
                    ),
                    16.w,
                    Expanded(
                      child: buildPaymentAmountCard(
                        'Refunded Amount',
                        analytics.refundedAmount.toStringAsFixed(2),
                        AppColors.purple,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget buildPaymentMetricCard(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return AnimatedHoverCard(
      padding: const EdgeInsets.all(16),
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          8.h,
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          4.h,
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildPaymentAmountCard(String label, String amount, Color color) {
    return AnimatedHoverCard(
      padding: const EdgeInsets.all(16),
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          8.h,
          Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPaymentFilterSection() {
    final theme = Theme.of(context);
    final filters = [
      ('all', 'All', Icons.list, AppColors.matBlue),
      ('completed', 'Completed', Icons.check_circle, AppColors.matGreen),
      ('pending', 'Pending', Icons.schedule, AppColors.amber),
      ('failed', 'Failed', Icons.error, AppColors.matRed),
      ('refunded', 'Refunded', Icons.undo, AppColors.purple),
    ];

    return Container(
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
          children: filters.map((filter) {
            final isSelected = context.watch<PaymentPageCubit>().state.selectedFilter == filter.$1;
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: InkWell(
                onTap: () {
                  context.read<PaymentPageCubit>().updateFilter(filter.$1);
                  if (filter.$1 == 'all') {
                    _paymentBloc.add(const FetchAllPaymentsEvent());
                  } else {
                    _paymentBloc.add(FetchPaymentsByStatusEvent(status: filter.$1));
                  }
                },
                borderRadius: BorderRadius.circular(30),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? filter.$4.withValues(alpha: 0.1) : theme.cardTheme.color,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isSelected ? filter.$4 : AppColors.grey.shade200,
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
    );
  }

  Widget buildPaymentContent(bool isMobile) {
    return BlocBuilder<PaymentBloc, PaymentState>(
      builder: (context, state) {
        if (state is PaymentLoading) {
          return buildPaymentLoadingWidget();
        }

        List<PaymentEntity> payments = [];

        if (state is AllPaymentsLoaded) {
          payments = state.payments;
        } else if (state is PaymentsByStatusLoaded) {
          payments = state.payments;
        } else if (state is PaymentError) {
          return buildPaymentErrorWidget(state.message);
        }

        if (payments.isEmpty) {
          return buildPaymentEmptyWidget();
        }

        int totalPages = (payments.length / itemsPerPage).ceil();

        // Fix: Ensure currentPage is valid
        if (context.read<PaymentPageCubit>().state.currentPage > totalPages && totalPages > 0) {
          context.read<PaymentPageCubit>().setPage(totalPages);
        } else if (totalPages == 0) {
          context.read<PaymentPageCubit>().setPage(1);
        }

        final currentPage = context.read<PaymentPageCubit>().state.currentPage;
        int startIndex = (currentPage - 1) * itemsPerPage;
        int endIndex = startIndex + itemsPerPage;
        startIndex = startIndex.clamp(0, payments.length);
        endIndex = endIndex.clamp(0, payments.length);

        if (startIndex >= payments.length && payments.isNotEmpty) {
          startIndex = 0;
          endIndex = itemsPerPage.clamp(0, payments.length);
          context.read<PaymentPageCubit>().setPage(1);
        }

        List<PaymentEntity> paginatedPayments =
            payments.sublist(startIndex, endIndex);

        if (isGridView) {
          return Column(
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 380, // Responsive width threshold
                  mainAxisExtent: 320, // Fixed height specifically for the modern tall card
                  crossAxisSpacing: isMobile ? 12 : 16,
                  mainAxisSpacing: isMobile ? 12 : 16,
                ),
                itemCount: paginatedPayments.length,
                itemBuilder: (context, index) {
                  return buildPaymentGridCard(paginatedPayments[index]);
                },
              ),
              if (totalPages > 1)
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: buildPaymentPaginationWidget(totalPages),
                ),
            ],
          );
        } else {
          return Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: paginatedPayments.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: isMobile ? 12 : 16,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 900),
                        child: isMobile
                            ? buildPaymentCardMobile(paginatedPayments[index])
                            : buildPaymentCardDesktop(paginatedPayments[index]),
                      ),
                    ),
                  );
                },
              ),
              if (totalPages > 1)
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: buildPaymentPaginationWidget(totalPages),
                ),
            ],
          );
        }
      },
    );
  }

  Widget buildPaymentLoadingWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(64),
        child: Column(
          children: [
            const CircularProgressIndicator(),
            16.h,
            Text(
              'Loading payments...',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPaymentErrorWidget(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.matRed[300],
            ),
            16.h,
            Text(
              'Error: $message',
              style: const TextStyle(
                color: AppColors.matRed,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPaymentEmptyWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(64),
        child: Column(
          children: [
            Icon(
              Icons.inbox,
              size: 64,
              color: AppColors.grey[300],
            ),
            16.h,
            Text(
              'No payments found',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            8.h,
            Text(
              'Check back later for new payments',
              style: TextStyle(
                color: AppColors.grey[500],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPaymentPaginationWidget(int totalPages) {
    return BlocBuilder<PaymentPageCubit, PaymentPageState>(
      builder: (context, pageState) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: pageState.currentPage > 1
                  ? () {
                      context.read<PaymentPageCubit>().previousPage();
                    }
                  : null,
            ),
            ...List.generate(totalPages, (index) {
              final pageNum = index + 1;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                  onPressed: () {
                    context.read<PaymentPageCubit>().setPage(pageNum);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        pageState.currentPage == pageNum ? Theme.of(context).colorScheme.primary : Theme.of(context).cardTheme.color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    pageNum.toString(),
                    style: TextStyle(
                      color: pageState.currentPage == pageNum ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).textTheme.bodyLarge?.color,
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
                      context.read<PaymentPageCubit>().nextPage();
                    }
                  : null,
            ),
          ],
        );
      },
    );
  }

  Widget buildPaymentGridCard(PaymentEntity payment) {
    final theme = Theme.of(context);
    final statusColor = buildPaymentStatusColor(payment.status);

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
                               payment.status.toUpperCase(),
                               style: TextStyle(
                                 fontSize: 10,
                                 color: statusColor,
                                 fontWeight: FontWeight.w800,
                                 letterSpacing: 0.5,
                                 fontFamily: 'Inter',
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
                       DateFormat('dd MMM yyyy').format(payment.createdAt),
                       style: TextStyle(
                         fontSize: 12,
                         color: AppColors.grey.shade500,
                         fontWeight: FontWeight.w500,
                         fontFamily: 'Inter',
                       ),
                       textAlign: TextAlign.right,
                       overflow: TextOverflow.ellipsis,
                     ),
                   ),
                 ],
               ),
            ),
            
            // Payment TXN
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Txn #${payment.paymentId.substring(0, 8).toUpperCase()}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: theme.textTheme.bodyLarge?.color,
                  height: 1.2,
                  fontFamily: 'Inter',
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
                          style: TextStyle(fontSize: 11, color: AppColors.grey.shade500, fontFamily: 'Inter'),
                        ),
                        2.h,
                        Text(
                          payment.userName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: theme.textTheme.bodyMedium?.color,
                            fontFamily: 'Inter',
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
            
            // Stats Row (Method & Total)
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
                        'Method',
                        style: TextStyle(fontSize: 12, color: AppColors.grey.shade500, fontFamily: 'Inter'),
                      ),
                      4.h,
                      Text(
                        payment.method,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: theme.textTheme.bodyLarge?.color,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Amount',
                        style: TextStyle(fontSize: 12, color: AppColors.grey.shade500, fontFamily: 'Inter'),
                      ),
                      4.h,
                      Text(
                        '₹${payment.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: statusColor,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Bottom Action
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        buildShowPaymentDetailsModal(context, payment);
                      },
                      icon: const Icon(Icons.receipt_long, size: 16),
                      label: const Text('View Details', style: TextStyle(fontFamily: 'Inter')),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.matBlue,
                        side: BorderSide(color: AppColors.matBlue.withValues(alpha: 0.3)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  if (payment.status == 'completed') ...[
                    8.w,
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          buildShowRefundDialog(context, payment);
                        },
                        icon: const Icon(Icons.undo, size: 16),
                        label: const Text('Refund', style: TextStyle(fontFamily: 'Inter')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.matRed,
                          foregroundColor: AppColors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPaymentCardMobile(PaymentEntity payment) {
    final theme = Theme.of(context);
    final statusColor = buildPaymentStatusColor(payment.status);

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
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                          'Txn #${payment.paymentId.substring(0, 8).toUpperCase()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: 'Inter',
                          ),
                        ),
                        4.h,
                        Text(
                          payment.userName,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.grey[600],
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
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
                          payment.status.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: statusColor,
                            fontFamily: 'Inter',
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              12.h,
              Divider(color: AppColors.grey[200]),
              12.h,
              Text(
                '₹${payment.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Inter',
                ),
              ),
              8.h,
              Text(
                '${payment.method} • ${DateFormat('dd MMM').format(payment.createdAt)}',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.grey[600],
                  fontFamily: 'Inter',
                ),
              ),
              12.h,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        buildShowPaymentDetailsModal(context, payment);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text(
                        'Details',
                        style: TextStyle(fontSize: 12, fontFamily: 'Inter'),
                      ),
                    ),
                  ),
                  8.w,
                  if (payment.status == 'completed')
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          buildShowRefundDialog(context, payment);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.matRed,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: const Text(
                          'Refund',
                          style: TextStyle(fontSize: 12, fontFamily: 'Inter'),
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

  Widget buildPaymentCardDesktop(PaymentEntity payment) {
    final theme = Theme.of(context);
    final statusColor = buildPaymentStatusColor(payment.status);

    return AnimatedHoverCard(
      padding: EdgeInsets.zero,
      child: Container(
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.payment,
                  color: statusColor,
                ),
              ),
              16.w,
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Txn #${payment.paymentId.substring(0, 8).toUpperCase()}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        fontFamily: 'Inter',
                      ),
                    ),
                    4.h,
                    Text(
                      payment.userName,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.grey[600],
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₹${payment.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        fontFamily: 'Inter',
                      ),
                    ),
                    4.h,
                    Text(
                      payment.method,
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.grey[600],
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('dd MMM yyyy').format(payment.createdAt),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.grey,
                        fontFamily: 'Inter',
                      ),
                    ),
                    4.h,
                    Text(
                      DateFormat('HH:mm').format(payment.createdAt),
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.grey[500],
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusColor.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                      ),
                      4.w,
                      Text(
                        payment.status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: statusColor,
                          fontFamily: 'Inter',
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              12.w,
              SizedBox(
                width: 100,
                child: OutlinedButton(
                  onPressed: () {
                    buildShowPaymentDetailsModal(context, payment);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text(
                    'Details',
                    style: TextStyle(fontSize: 11, fontFamily: 'Inter'),
                  ),
                ),
              ),
              if (payment.status == 'completed')
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        buildShowRefundDialog(context, payment);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.matRed,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text(
                        'Refund',
                        style: TextStyle(fontSize: 11, fontFamily: 'Inter'),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void buildShowPaymentDetailsModal(
    BuildContext context,
    PaymentEntity payment,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Payment Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                20.h,
                buildPaymentDetailSection(
                  'Payment Information',
                  [
                    buildPaymentDetailItem('Transaction ID', payment.paymentId),
                    buildPaymentDetailItem('Order ID', payment.orderId),
                    buildPaymentDetailItem(
                      'Amount',
                      '?${payment.amount.toStringAsFixed(2)}',
                    ),
                    buildPaymentDetailItem('Currency', payment.currency),
                    buildPaymentDetailItem('Method', payment.method),
                    buildPaymentDetailItem('Status', payment.status),
                  ],
                ),
                16.h,
                buildPaymentDetailSection(
                  'Customer Information',
                  [
                    buildPaymentDetailItem('Name', payment.userName),
                    buildPaymentDetailItem('User ID', payment.userId),
                  ],
                ),
                16.h,
                buildPaymentDetailSection(
                  'Dates',
                  [
                    buildPaymentDetailItem(
                      'Created',
                      DateFormat('dd MMM yyyy, HH:mm').format(
                        payment.createdAt,
                      ),
                    ),
                    if (payment.completedAt != null)
                      buildPaymentDetailItem(
                        'Completed',
                        DateFormat('dd MMM yyyy, HH:mm').format(
                          payment.completedAt!,
                        ),
                      ),
                    if (payment.refundedAt != null)
                      buildPaymentDetailItem(
                        'Refunded',
                        DateFormat('dd MMM yyyy, HH:mm').format(
                          payment.refundedAt!,
                        ),
                      ),
                  ],
                ),
                if (payment.refundedAmount != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: buildPaymentDetailSection(
                      'Refund Information',
                      [
                        buildPaymentDetailItem(
                          'Refunded Amount',
                          '?${payment.refundedAmount!.toStringAsFixed(2)}',
                        ),
                      ],
                    ),
                  ),
                24.h,
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ),
                    if (payment.status == 'completed')
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              buildShowRefundDialog(context, payment);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.matRed,
                            ),
                            child: const Text('Refund Payment'),
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

  Widget buildPaymentDetailSection(String title, List<Widget> items) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          12.h,
          ...items.asMap().entries.map((entry) {
            final isLast = entry.key == items.length - 1;
            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
              child: entry.value,
            );
          }),
        ],
      ),
    );
  }

  Widget buildPaymentDetailItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 11,
            color: AppColors.grey[700],
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.grey,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void buildShowRefundDialog(BuildContext context, PaymentEntity payment) {
    final amountController = TextEditingController(
      text: payment.amount.toStringAsFixed(2),
    );

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
                Icons.undo,
                size: 48,
                color: AppColors.matRed[400],
              ),
              16.h,
              const Text(
                'Refund Payment',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              12.h,
              Text(
                'Refund amount for Transaction #${payment.paymentId.substring(0, 8)}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.grey[700],
                ),
              ),
              20.h,
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Refund Amount',
                  hintText: payment.amount.toStringAsFixed(2),
                  prefixText: '? ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
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
                        final refundAmount =
                            double.tryParse(amountController.text) ?? 0;
                        if (refundAmount > 0) {
                          _paymentBloc.add(
                            RefundPaymentEvent(
                              paymentId: payment.paymentId,
                              amount: refundAmount,
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.matRed,
                      ),
                      child: const Text('Refund'),
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

  void buildShowSnackBar(BuildContext context, String message, Color bgColor) {
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

  Color buildPaymentStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppColors.matGreen;
      case 'pending':
        return AppColors.amber;
      case 'failed':
        return AppColors.matRed;
      case 'refunded':
        return AppColors.purple;
      default:
        return AppColors.grey;
    }
  }

  Future<void> _printPaymentList(List<PaymentEntity> payments) async {
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Payment Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                  pw.Text(
                    DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now()),
                    style: const pw.TextStyle(color: PdfColors.grey700),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.TableHelper.fromTextArray(
              headers: ['Transaction ID', 'User', 'Amount', 'Status', 'Date'],
              data: payments.map((payment) {
                return [
                  payment.paymentId.substring(0, 8).toUpperCase(),
                  payment.userName,
                  'INR ${payment.amount.toStringAsFixed(2)}',
                  payment.status.toUpperCase(),
                  DateFormat('dd MMM yyyy').format(payment.createdAt),
                ];
              }).toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.green),
              cellAlignment: pw.Alignment.centerLeft,
              cellAlignments: {
                2: pw.Alignment.centerRight,
              },
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name: 'Payment_Report',
    );
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