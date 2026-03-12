import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/payment_entity.dart';
import 'package:rizqmartadmin/widgets/animated_hover_card.dart';
import 'payment_dialogs.dart';
import 'payment_status_color.dart';

class PaymentCardDesktop extends StatelessWidget {
  final PaymentEntity payment;

  const PaymentCardDesktop({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = getPaymentStatusColor(payment.status);

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
                flex: 3,
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
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.h,
                    Text(
                      payment.userName,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.grey600,
                        fontFamily: 'Inter',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
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
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.h,
                    Text(
                      payment.method,
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.grey600,
                        fontFamily: 'Inter',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
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
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.h,
                    Text(
                      DateFormat('HH:mm').format(payment.createdAt),
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.grey500,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
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
                      Flexible(
                        child: Text(
                          payment.status.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: statusColor,
                            fontFamily: 'Inter',
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              8.w,
              Flexible(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 70, maxWidth: 100),
                  child: OutlinedButton(
                    onPressed: () {
                      PaymentDialogs.showPaymentDetailsModal(context, payment);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    ),
                    child: const Text(
                      'Details',
                      style: TextStyle(fontSize: 11, fontFamily: 'Inter'),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              if (payment.status.toLowerCase() == 'completed')
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 70, maxWidth: 100),
                      child: ElevatedButton(
                        onPressed: () {
                          PaymentDialogs.showRefundDialog(context, payment);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.matRed,
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                        ),
                        child: const Text(
                          'Refund',
                          style: TextStyle(fontSize: 11, fontFamily: 'Inter'),
                          overflow: TextOverflow.ellipsis,
                        ),
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
}
