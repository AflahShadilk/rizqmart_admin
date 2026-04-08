import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/core/theme/appcolor.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/payment/payment_bloc.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/payment/payment_event.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/payment/payment_state.dart';
import 'package:rizqmartadmin/features/presentation/cubit/payment/payment_cubit.dart';
import 'package:rizqmartadmin/features/presentation/widgets/common/grid_list_toggle.dart';
import 'payment_print_helper.dart';

class PaymentAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PaymentAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isGridView = context.watch<PaymentCubit>().state.isGridView;
    final paymentBloc = context.read<PaymentBloc>();

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
            mainAxisAlignment: MainAxisAlignment.center,
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
              context.read<PaymentCubit>().toggleGridView(val);
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
                  paymentBloc.add(const FetchAllPaymentsEvent());
                  paymentBloc.add(const FetchPaymentAnalyticsEvent());
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
                      final state = paymentBloc.state;
                      if (state is AllPaymentsLoaded) {
                        PaymentPrintHelper.printPaymentList(state.payments);
                      } else if (state is PaymentsByStatusLoaded) {
                        PaymentPrintHelper.printPaymentList(state.payments);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No payments to print'),
                            backgroundColor: AppColors.amber,
                          ),
                        );
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
}
