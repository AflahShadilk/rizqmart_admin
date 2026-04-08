import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rizqmartadmin/core/theme/appcolor.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:rizqmartadmin/features/domain/entities/main/order_recieved_entity.dart';
import 'package:rizqmartadmin/features/presentation/widgets/common/animated_hover_card.dart';
import 'order_status_color.dart';

class OrderCardGrid extends StatelessWidget {
  final OrderReceivedEntity order;
  final VoidCallback onViewDetails;
  final VoidCallback onUpdateStatus;

  const OrderCardGrid({
    super.key,
    required this.order,
    required this.onViewDetails,
    required this.onUpdateStatus,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = getOrderStatusColor(order.orderStatus);

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
              statusColor.withOpacity(0.02),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- Top Section (Status & Date) ----------------
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: statusColor.withOpacity(0.2)),
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
                      DateFormat('MMM dd, yyyy').format(order.createdAt),
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

            // ---------------- Order ID ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Order #${order.orderNumber}',
                style: TextStyle(
                  fontSize: 17, // reduced from 20
                  fontWeight: FontWeight.w800,
                  color: theme.textTheme.bodyLarge?.color,
                  height: 1.2,
                  fontFamily: 'Inter',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            10.h,

            // ---------------- Customer Info ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.matBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.person, size: 18, color: AppColors.matBlue.shade700),
                  ),
                  10.w, // reduced from 12.w
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Customer',
                          style: TextStyle(fontSize: 10, color: AppColors.grey.shade500, fontFamily: 'Inter'), // reduced size
                        ),
                        2.h,
                        Text(
                          order.userName,
                          style: TextStyle(
                            fontSize: 13, // reduced from 14
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

            // ---------------- Stats Row (Items & Total) ----------------
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), // reduced vertical padding from 16
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(color: theme.dividerColor.withOpacity(0.05)),
                ),
                color: theme.scaffoldBackgroundColor.withOpacity(0.3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Items',
                        style: TextStyle(fontSize: 11, color: AppColors.grey.shade500, fontFamily: 'Inter'), // reduced size
                      ),
                      2.h,
                      Text(
                        '${order.itemCount}',
                        style: TextStyle(
                          fontSize: 14, // reduced from 16
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
                        'Total',
                        style: TextStyle(fontSize: 11, color: AppColors.grey.shade500, fontFamily: 'Inter'), // reduced size
                      ),
                      2.h,
                      Text(
                        '₹${order.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16, // reduced from 18
                          fontWeight: FontWeight.w800,
                          color: AppColors.matGreen.shade700,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ---------------- Action Buttons ----------------
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: OutlinedButton(
                      onPressed: onViewDetails,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.matBlue,
                        side: BorderSide(color: AppColors.matBlue.withOpacity(0.3)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Details', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)), // reduced from 13
                    ),
                  ),
                  8.w,
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.matBlue.withOpacity(0.1),
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
                      onPressed: onUpdateStatus,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.matGreen,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 10), // reduced from 14
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Status', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)), // reduced from 13
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
}
