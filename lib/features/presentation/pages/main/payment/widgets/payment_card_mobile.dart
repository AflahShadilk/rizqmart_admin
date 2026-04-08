import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rizqmartadmin/core/theme/appcolor.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:rizqmartadmin/features/domain/entities/main/payment_entity.dart';
import 'package:rizqmartadmin/features/presentation/widgets/common/animated_hover_card.dart';
import 'payment_dialogs.dart';
import 'payment_status_color.dart';

class PaymentCardMobile extends StatelessWidget {
  final PaymentEntity payment;

  const PaymentCardMobile({super.key, required this.payment});

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
                            color: AppColors.grey600,
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
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              12.h,
              Divider(color: AppColors.grey200),
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
                  color: AppColors.grey600,
                  fontFamily: 'Inter',
                ),
              ),
              12.h,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        PaymentDialogs.showPaymentDetailsModal(context, payment);
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
                  if (payment.status.toLowerCase() == 'completed')
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          PaymentDialogs.showRefundDialog(context, payment);
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
}
