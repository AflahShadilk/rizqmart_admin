import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/payment_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/payment/payment_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/payment/payment_event.dart';

class PaymentDialogs {
  static void showPaymentDetailsModal(BuildContext context, PaymentEntity payment) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
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
                      onPressed: () => Navigator.pop(dialogContext),
                    ),
                  ],
                ),
                20.h,
                _buildPaymentDetailSection(
                  'Payment Information',
                  [
                    _buildPaymentDetailItem('Transaction ID', payment.paymentId),
                    _buildPaymentDetailItem('Order ID', payment.orderId),
                    _buildPaymentDetailItem('Amount', '₹${payment.amount.toStringAsFixed(2)}'),
                    _buildPaymentDetailItem('Currency', payment.currency),
                    _buildPaymentDetailItem('Method', payment.method),
                    _buildPaymentDetailItem('Status', payment.status),
                  ],
                ),
                16.h,
                _buildPaymentDetailSection(
                  'Customer Information',
                  [
                    _buildPaymentDetailItem('Name', payment.userName),
                    _buildPaymentDetailItem('User ID', payment.userId),
                  ],
                ),
                16.h,
                _buildPaymentDetailSection(
                  'Dates',
                  [
                    _buildPaymentDetailItem(
                      'Created',
                      DateFormat('dd MMM yyyy, HH:mm').format(payment.createdAt),
                    ),
                    if (payment.completedAt != null)
                      _buildPaymentDetailItem(
                        'Completed',
                        DateFormat('dd MMM yyyy, HH:mm').format(payment.completedAt!),
                      ),
                    if (payment.refundedAt != null)
                      _buildPaymentDetailItem(
                        'Refunded',
                        DateFormat('dd MMM yyyy, HH:mm').format(payment.refundedAt!),
                      ),
                  ],
                ),
                if (payment.refundedAmount != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: _buildPaymentDetailSection(
                      'Refund Information',
                      [
                        _buildPaymentDetailItem(
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
                        onPressed: () => Navigator.pop(dialogContext),
                        child: const Text('Close'),
                      ),
                    ),
                    if (payment.status.toLowerCase() == 'completed')
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(dialogContext); // close details modal
                              showRefundDialog(context, payment); // prompt refund
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

  static Widget _buildPaymentDetailSection(String title, List<Widget> items) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? theme.cardColor : AppColors.grey50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.grey200,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: theme.textTheme.bodyMedium?.color,
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
      },
    );
  }

  static Widget _buildPaymentDetailItem(String label, String value) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 11,
                color: theme.textTheme.bodySmall?.color ?? AppColors.grey700,
              ),
            ),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 11,
                  color: theme.textTheme.bodyMedium?.color ?? AppColors.grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      },
    );
  }

  static void showRefundDialog(BuildContext context, PaymentEntity payment) {
    final amountController = TextEditingController(
      text: payment.amount.toStringAsFixed(2),
    );

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
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
                  color: AppColors.grey700,
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
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('Cancel'),
                    ),
                  ),
                  12.w,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final refundAmount = double.tryParse(amountController.text) ?? 0;
                        if (refundAmount > 0) {
                          context.read<PaymentBloc>().add(
                                RefundPaymentEvent(
                                  paymentId: payment.paymentId,
                                  amount: refundAmount,
                                ),
                              );
                          Navigator.pop(dialogContext);
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

  static void showSnackBar(BuildContext context, String message, Color bgColor) {
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
