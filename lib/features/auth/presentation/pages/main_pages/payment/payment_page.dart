// ignore_for_file: deprecated_member_use

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

    return Scaffold(
      appBar: buildPaymentAppBar(),
      body: BlocListener<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is PaymentRefunded) {
            buildShowSnackBar(context, state.message, Colors.green);
          } else if (state is PaymentError) {
            buildShowSnackBar(context, 'Error: ${state.message}', Colors.red);
          }
        },
        child: Container(
          color: Colors.grey[50],
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildPaymentHeaderSection(),
                24.h,
                buildPaymentFilterSection(),
                24.h,
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16 : 24,
                  ),
                  child: buildPaymentContent(isMobile),
                ),
                32.h,
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar buildPaymentAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      toolbarHeight: 70,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.payment,
              color: Colors.green.shade700,
              size: 24,
            ),
          ),
          12.w,
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payments',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Transaction history & management',
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
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.refresh, color: Colors.green.shade700),
                tooltip: 'Refresh',
                onPressed: () {
                  _paymentBloc.add(const FetchAllPaymentsEvent());
                  _paymentBloc.add(const FetchPaymentAnalyticsEvent());
                },
              ),
              8.w,
              PopupMenuButton(
                icon: Icon(Icons.more_vert, color: Colors.grey.shade600),
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
                        buildShowSnackBar(context, 'No payments to print', Colors.orange);
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
      color: Colors.white,
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
                        '₹${analytics.totalRevenue.toStringAsFixed(2)}',
                        Colors.green,
                        Icons.trending_up,
                      ),
                    ),
                    16.w,
                    Expanded(
                      child: buildPaymentMetricCard(
                        'Success Rate',
                        '${analytics.successRate.toStringAsFixed(1)}%',
                        Colors.blue,
                        Icons.check_circle,
                      ),
                    ),
                    16.w,
                    Expanded(
                      child: buildPaymentMetricCard(
                        'Completed',
                        '${analytics.completedCount}',
                        Colors.green,
                        Icons.done,
                      ),
                    ),
                    16.w,
                    Expanded(
                      child: buildPaymentMetricCard(
                        'Pending',
                        '${analytics.pendingCount}',
                        Colors.orange,
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
                        '₹${analytics.completedAmount.toStringAsFixed(2)}',
                        Colors.green,
                      ),
                    ),
                    16.w,
                    Expanded(
                      child: buildPaymentAmountCard(
                        'Pending Amount',
                        '₹${analytics.pendingAmount.toStringAsFixed(2)}',
                        Colors.orange,
                      ),
                    ),
                    16.w,
                    Expanded(
                      child: buildPaymentAmountCard(
                        'Refunded Amount',
                        '₹${analytics.refundedAmount.toStringAsFixed(2)}',
                        Colors.purple,
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: Colors.grey[700],
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
    final filters = [
      ('all', 'All', Icons.list, Colors.blue),
      ('completed', 'Completed', Icons.check_circle, Colors.green),
      ('pending', 'Pending', Icons.schedule, Colors.orange),
      ('failed', 'Failed', Icons.error, Colors.red),
      ('refunded', 'Refunded', Icons.undo, Colors.purple),
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters
              .asMap()
              .entries
              .map((entry) {
                final index = entry.key;
                final filter = entry.value;
                return Padding(
                  padding: EdgeInsets.only(
                    right: index < filters.length - 1 ? 8 : 0,
                  ),
                  child: FilterChip(
                    avatar: Icon(filter.$3, size: 16),
                    label: Text(filter.$2),
                    selected: context.watch<PaymentPageCubit>().state.selectedFilter == filter.$1,
                    backgroundColor: Colors.grey[100],
                    selectedColor: filter.$4.withOpacity(0.2),
                    side: BorderSide(
                      color: context.watch<PaymentPageCubit>().state.selectedFilter == filter.$1
                          ? filter.$4
                          : Colors.transparent,
                      width: 1.5,
                    ),
                    labelStyle: TextStyle(
                      color: context.watch<PaymentPageCubit>().state.selectedFilter == filter.$1
                          ? filter.$4
                          : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                    onSelected: (selected) {
                      context.read<PaymentPageCubit>().updateFilter(filter.$1);

                      if (filter.$1 == 'all') {
                        _paymentBloc.add(const FetchAllPaymentsEvent());
                      } else {
                        _paymentBloc.add(
                          FetchPaymentsByStatusEvent(status: filter.$1),
                        );
                      }
                    },
                  ),
                );
              })
              .toList(),
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

        if (isMobile) {
          return Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: paginatedPayments.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: buildPaymentCardMobile(paginatedPayments[index]),
                  );
                },
              ),
              if (totalPages > 1)
                Padding(
                  padding: const EdgeInsets.only(top: 24),
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
                    padding: const EdgeInsets.only(bottom: 12),
                    child: buildPaymentCardDesktop(paginatedPayments[index]),
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
                color: Colors.grey[600],
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
              color: Colors.red[300],
            ),
            16.h,
            Text(
              'Error: $message',
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

  Widget buildPaymentEmptyWidget() {
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
              'No payments found',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            8.h,
            Text(
              'Check back later for new payments',
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
                        pageState.currentPage == pageNum ? Colors.green : Colors.grey[200],
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
                      context.read<PaymentPageCubit>().nextPage();
                    }
                  : null,
            ),
          ],
        );
      },
    );
  }

  Widget buildPaymentCardMobile(PaymentEntity payment) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
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
                        ),
                      ),
                      4.h,
                      Text(
                        payment.userName,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: buildPaymentStatusColor(payment.status)
                        .withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    payment.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: buildPaymentStatusColor(payment.status),
                    ),
                  ),
                ),
              ],
            ),
            12.h,
            Divider(color: Colors.grey[200]),
            12.h,
            Text(
              '₹${payment.amount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            8.h,
            Text(
              '${payment.method} • ${DateFormat('dd MMM').format(payment.createdAt)}',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
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
                      style: TextStyle(fontSize: 12),
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
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text(
                        'Refund',
                        style: TextStyle(fontSize: 12),
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

  Widget buildPaymentCardDesktop(PaymentEntity payment) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: buildPaymentStatusColor(payment.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.payment,
                color: buildPaymentStatusColor(payment.status),
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
                    ),
                  ),
                  4.h,
                  Text(
                    payment.userName,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
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
                    ),
                  ),
                  4.h,
                  Text(
                    payment.method,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
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
                      color: Colors.grey,
                    ),
                  ),
                  4.h,
                  Text(
                    DateFormat('HH:mm').format(payment.createdAt),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: buildPaymentStatusColor(payment.status)
                      .withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  payment.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: buildPaymentStatusColor(payment.status),
                  ),
                  textAlign: TextAlign.center,
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
                  style: TextStyle(fontSize: 11),
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
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text(
                      'Refund',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ),
              ),
          ],
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
                      '₹${payment.amount.toStringAsFixed(2)}',
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
                          '₹${payment.refundedAmount!.toStringAsFixed(2)}',
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
                              backgroundColor: Colors.red,
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
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
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
            color: Colors.grey[700],
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
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
                color: Colors.red[400],
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
                  color: Colors.grey[700],
                ),
              ),
              20.h,
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Refund Amount',
                  hintText: payment.amount.toStringAsFixed(2),
                  prefixText: '₹ ',
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
                        backgroundColor: Colors.red,
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
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      case 'refunded':
        return Colors.purple;
      default:
        return Colors.grey;
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