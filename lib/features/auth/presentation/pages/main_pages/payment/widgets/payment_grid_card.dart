import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/payment_entity.dart';
import 'package:rizqmartadmin/widgets/animated_hover_card.dart';
import 'payment_dialogs.dart';
import 'payment_status_color.dart';

class PaymentGridCard extends StatelessWidget {
  final PaymentEntity payment;

  const PaymentGridCard({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = getPaymentStatusColor(payment.status);

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
                        color: AppColors.grey500,
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
                          style: TextStyle(fontSize: 11, color: AppColors.grey500, fontFamily: 'Inter'),
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
                        style: TextStyle(fontSize: 12, color: AppColors.grey500, fontFamily: 'Inter'),
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
                        style: TextStyle(fontSize: 12, color: AppColors.grey500, fontFamily: 'Inter'),
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
                        PaymentDialogs.showPaymentDetailsModal(context, payment);
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
                  if (payment.status.toLowerCase() == 'completed') ...[
                    8.w,
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          PaymentDialogs.showRefundDialog(context, payment);
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
}
