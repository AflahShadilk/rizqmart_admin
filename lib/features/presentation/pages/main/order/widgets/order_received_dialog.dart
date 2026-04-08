import 'package:flutter/material.dart';
import 'package:rizqmartadmin/core/theme/appcolor.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/order/order_received_bloc.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/order/order_received_event.dart';
import 'package:rizqmartadmin/features/presentation/widgets/page_decoration/respnsive_page.dart';

// ---------------- Mark as Received Confirmation Dialog ----------------
void confirmMarkAsReceived(
  BuildContext context,
  String orderId,
  String orderNumber,
  OrderReceivedBloc orderBloc,
) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: EdgeInsets.all(Responsive.scaleSpacing(context, 24)),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(Responsive.scaleSpacing(context, 16)),
              decoration: BoxDecoration(
                color: AppColors.matGreen.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline,
                size: 48,
                color: AppColors.matGreen.shade600,
              ),
            ),
            SizedBox(height: Responsive.scaleSpacing(context, 16)),
            const Text(
              'Mark Order as Received',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.black87,
              ),
            ),
            SizedBox(height: Responsive.scaleSpacing(context, 12)),
            Text(
              'Are you sure you want to mark Order #$orderNumber as received? This action cannot be undone.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.grey.shade600,
                height: 1.4,
              ),
            ),
            SizedBox(height: Responsive.scaleSpacing(context, 24)),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: Responsive.scaleSpacing(context, 16)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      side: BorderSide(color: AppColors.grey.shade300),
                    ),
                    child: Text('Cancel', style: TextStyle(color: AppColors.grey.shade700, fontWeight: FontWeight.w600)),
                  ),
                ),
                SizedBox(width: Responsive.scaleSpacing(context, 12)),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      orderBloc.add(
                        MarkOrderAsReceivedEvent(orderId: orderId),
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.matGreen.shade600,
                      padding: EdgeInsets.symmetric(vertical: Responsive.scaleSpacing(context, 16)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    child: const Text('Confirm', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
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
