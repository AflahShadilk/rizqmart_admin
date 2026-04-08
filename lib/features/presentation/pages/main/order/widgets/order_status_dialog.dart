import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/core/theme/appcolor.dart';
import 'package:rizqmartadmin/features/presentation/cubit/order/order_status_dialog_cubit.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/order/order_received_bloc.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/order/order_received_event.dart';
import 'package:rizqmartadmin/features/presentation/widgets/page_decoration/respnsive_page.dart';
import 'order_status_color.dart';

// ---------------- Order Status Dialog ----------------
void showStatusDialog(BuildContext context, String orderId, OrderReceivedBloc orderBloc) {
  const statuses = [
    ('pending', Icons.schedule_rounded),
    ('processing', Icons.autorenew_rounded),
    ('shipped', Icons.local_shipping_rounded),
    ('out for delivery', Icons.directions_bike_rounded),
    ('delivered', Icons.task_alt_rounded),
    ('received', Icons.inventory_rounded),
    ('cancelled', Icons.cancel_rounded),
  ];

  showDialog(
    context: context,
    builder: (context) => BlocProvider(
      create: (_) => OrderStatusDialogCubit('pending'),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.all(Responsive.scaleSpacing(context, 24)),
          constraints: const BoxConstraints(maxWidth: 420),
          child: BlocBuilder<OrderStatusDialogCubit, String>(
            builder: (context, selectedStatus) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Update Order Status',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.black87,
                    ),
                  ),
                  SizedBox(height: Responsive.scaleSpacing(context, 8)),
                  Text(
                    'Select the new status for this order. This will instantly update the user.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: Responsive.scaleSpacing(context, 24)),
                  // ---------------- Status Chips ----------------
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: statuses.map((statusItem) {
                      final statusValue = statusItem.$1;
                      final icon = statusItem.$2;
                      final isSelected = selectedStatus == statusValue;
                      final color = getOrderStatusColor(statusValue);

                      return Material(
                        color: AppColors.transparent,
                        child: InkWell(
                          onTap: () => context.read<OrderStatusDialogCubit>().updateStatus(statusValue),
                          borderRadius: BorderRadius.circular(30),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(
                              horizontal: Responsive.scaleSpacing(context, 16),
                              vertical: Responsive.scaleSpacing(context, 10),
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? color.withValues(alpha: 0.1) : AppColors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: isSelected ? color : AppColors.grey.shade300,
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(icon, size: 16, color: isSelected ? color : AppColors.grey.shade600),
                                SizedBox(width: Responsive.scaleSpacing(context, 8)),
                                Text(
                                  statusValue.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: Responsive.scaleFont(context, 11),
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                    color: isSelected ? color : AppColors.grey.shade700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: Responsive.scaleSpacing(context, 32)),
                  // ---------------- Action Buttons ----------------
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
                              UpdateOrderStatusEvent(
                                orderId: orderId,
                                status: selectedStatus,
                              ),
                            );
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.matBlue.shade700,
                            padding: EdgeInsets.symmetric(vertical: Responsive.scaleSpacing(context, 16)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                          child: const Text('Update Status', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    ),
  );
}
