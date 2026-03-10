import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/order_recieved_entity.dart';

void showOrderDetailsModal(BuildContext context, OrderReceivedEntity order, {
  required VoidCallback onSavePdf,
  required VoidCallback onPrint,
  required VoidCallback onUpdateStatus,
  required VoidCallback onMarkReceived,
}) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 0,
      backgroundColor: AppColors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 650, maxHeight: 850),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.1),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Modern Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.matBlue.shade50, AppColors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                border: Border(bottom: BorderSide(color: AppColors.grey.shade100)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.matBlue.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.receipt_long, color: AppColors.matBlue.shade700, size: 24),
                            ),
                            16.w,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Order Details',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.black87,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  4.h,
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: [
                                      Text(
                                        '#${order.orderNumber}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: AppColors.matBlue.shade700,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: _getStatusBgColor(order.orderStatus),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          order.orderStatus.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800,
                                            color: _getStatusTextColor(order.orderStatus),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _buildHeaderAction(Icons.download_rounded, 'Save PDF', onSavePdf, AppColors.matBlue),
                      _buildHeaderAction(Icons.print_rounded, 'Print', onPrint, AppColors.matBlue),
                      _buildHeaderAction(Icons.close_rounded, 'Close', () => Navigator.pop(context), AppColors.grey.shade600),
                    ],
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Info Row (Customer & Order Info)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            context,
                            'Customer',
                            Icons.person_outline,
                            AppColors.matIndigo,
                            [
                              _detailRow('Name', order.userName, icon: Icons.badge_outlined),
                              _detailRow('Email', order.userEmail, icon: Icons.email_outlined),
                              _detailRow('Phone', order.userPhone, icon: Icons.phone_outlined),
                            ],
                          ),
                        ),
                        16.w,
                        Expanded(
                          child: _buildInfoCard(
                            context,
                            'Payment Info',
                            Icons.payment_outlined,
                            AppColors.matGreen,
                            [
                              _detailRow('Date', DateFormat('dd MMM, HH:mm').format(order.createdAt), icon: Icons.calendar_today_outlined),
                              _detailRow('Method', order.paymentMethod, icon: Icons.credit_card_outlined),
                              _detailRow('Status', order.paymentStatus, 
                                valueColor: order.paymentStatus.toLowerCase() == 'paid' 
                                    ? AppColors.matGreen.shade700 
                                    : AppColors.matAmber.shade800,
                                isBold: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    24.h,

                    // Delivery Info
                    _buildInfoCard(
                      context,
                      'Delivery Details',
                      Icons.local_shipping_outlined,
                      AppColors.matAmber,
                      [
                        if (order.deliveryMethod != null)
                          _detailRow('Method', order.deliveryMethod!),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.location_on_outlined, size: 16, color: AppColors.grey.shade500),
                            8.w,
                            Expanded(
                              child: Text(
                                order.deliveryAddress,
                                style: TextStyle(fontSize: 13, color: AppColors.grey.shade800, height: 1.5),
                              ),
                            ),
                          ],
                        ),
                        if (order.deliveryNotes != null && order.deliveryNotes!.isNotEmpty) ...[
                          12.h,
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.matAmber.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.matAmber.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.info_outline, size: 16, color: AppColors.matAmber.shade800),
                                8.w,
                                Expanded(
                                  child: Text(
                                    'Note: ${order.deliveryNotes}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.matAmber.shade900,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    24.h,

                    // Items List
                    Text(
                      'Order Items (${order.itemCount})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black87,
                      ),
                    ),
                    12.h,
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.grey.shade100,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Column(
                          children: order.items.asMap().entries.map((entry) {
                            final item = entry.value;
                            final isLast = entry.key == order.items.length - 1;
                            return Container(
                              decoration: BoxDecoration(
                                color: entry.key.isEven ? AppColors.white : AppColors.grey.shade50,
                                border: isLast ? null : Border(bottom: BorderSide(color: AppColors.grey.shade100)),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              child: Row(
                                children: [
                                  Container(
                                    height: 48,
                                    width: 48,
                                    decoration: BoxDecoration(
                                      color: AppColors.matBlue.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${item.quantity.toInt()}x',
                                        style: TextStyle(
                                          color: AppColors.matBlue.shade700,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  16.w,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.productName,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.black87,
                                          ),
                                        ),
                                        4.h,
                                        Row(
                                          children: [
                                            Text(
                                              '₹${item.mrp.toStringAsFixed(2)}',
                                              style: TextStyle(fontSize: 12, color: AppColors.grey.shade600),
                                            ),
                                            if (item.unit != null) ...[
                                              4.w,
                                              Text('•', style: TextStyle(color: AppColors.grey.shade400)),
                                              4.w,
                                              Text(
                                                item.unit!,
                                                style: TextStyle(fontSize: 12, color: AppColors.grey.shade500),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '₹${(item.mrp * item.quantity).toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    24.h,

                    // Summary
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 320,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.matBlue.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.matBlue.shade100.withValues(alpha: 0.5)),
                        ),
                        child: Column(
                          children: [
                            _summaryRow('Subtotal', order.subtotal),
                            12.h,
                            _summaryRow('Delivery Fee', order.deliveryFee),
                            if (order.discount > 0) ...[
                              12.h,
                              _summaryRow('Discount', -order.discount, isDiscount: true),
                            ],
                            16.h,
                            Divider(color: AppColors.matBlue.shade200, height: 1),
                            16.h,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.black87,
                                  ),
                                ),
                                Text(
                                  '₹${order.totalAmount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.matBlue.shade700,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer Actions
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                border: Border(top: BorderSide(color: AppColors.grey.shade100)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.03),
                    offset: const Offset(0, -5),
                    blurRadius: 10,
                  )
                ],
              ),
              child: Wrap(
                alignment: WrapAlignment.end,
                spacing: 16,
                runSpacing: 12,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(color: AppColors.grey.shade300),
                    ),
                    child: Text(
                      'Close',
                      style: TextStyle(color: AppColors.grey.shade700, fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      onUpdateStatus();
                    },
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text(
                      'Update Status',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.matBlue.shade600,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                  ),
                  if (order.orderStatus != 'received' && order.orderStatus != 'cancelled')
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        onMarkReceived();
                      },
                      icon: const Icon(Icons.check_circle_outline, size: 18),
                      label: const Text(
                        'Mark Received',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.matGreen.shade600,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
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

// ---------------------------------------------------------
// Helper Widget Builders
// ---------------------------------------------------------

Widget _buildHeaderAction(IconData icon, String tooltip, VoidCallback onTap, Color color) {
  return Tooltip(
    message: tooltip,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 20, color: color),
      ),
    ),
  );
}

Widget _buildInfoCard(BuildContext context, String title, IconData icon, MaterialColor color, List<Widget> children) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.grey.shade200),
      boxShadow: [
        BoxShadow(
          color: AppColors.grey.shade100,
          blurRadius: 10,
          offset: const Offset(0, 4),
        )
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: color.shade700),
            ),
            8.w,
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.black87,
              ),
            ),
          ],
        ),
        16.h,
        ...children.map((child) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: child,
        )),
      ],
    ),
  );
}

Widget _detailRow(String label, String value, {IconData? icon, Color? valueColor, bool isBold = false}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (icon != null) ...[
        Icon(icon, size: 14, color: AppColors.grey.shade500),
        6.w,
      ],
      Expanded(
        flex: 2,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      Expanded(
        flex: 3,
        child: Text(
          value,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 13,
            color: valueColor ?? AppColors.black87,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    ],
  );
}

Widget _summaryRow(String label, double amount, {bool isDiscount = false}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 14,
          color: AppColors.grey.shade600,
          fontWeight: FontWeight.w500,
        ),
      ),
      Text(
        isDiscount ? '-₹${amount.abs().toStringAsFixed(2)}' : '₹${amount.toStringAsFixed(2)}',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDiscount ? AppColors.matGreen.shade600 : AppColors.black87,
        ),
      ),
    ],
  );
}

Color _getStatusBgColor(String status) {
  switch (status.toLowerCase()) {
    case 'pending': return AppColors.matAmber.shade50;
    case 'processing': return AppColors.matBlue.shade50;
    case 'shipped': return AppColors.matIndigo.shade50;
    case 'out for delivery': return AppColors.matTeal.shade50;
    case 'delivered': return AppColors.matGreen.shade50;
    case 'received': return AppColors.matGreen.shade50;
    case 'cancelled': return AppColors.matRed.shade50;
    default: return AppColors.grey.shade50;
  }
}

Color _getStatusTextColor(String status) {
  switch (status.toLowerCase()) {
    case 'pending': return AppColors.matAmber.shade800;
    case 'processing': return AppColors.matBlue.shade800;
    case 'shipped': return AppColors.matIndigo.shade800;
    case 'out for delivery': return AppColors.matTeal.shade800;
    case 'delivered': return AppColors.matGreen.shade800;
    case 'received': return AppColors.matGreen.shade800;
    case 'cancelled': return AppColors.matRed.shade800;
    default: return AppColors.grey.shade800;
  }
}
