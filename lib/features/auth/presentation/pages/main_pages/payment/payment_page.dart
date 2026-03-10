import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/payment/payment_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/payment/payment_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/payment/payment_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/cubit/payment/payment_cubit.dart';
import 'widgets/payment_app_bar.dart';
import 'widgets/payment_header_section.dart';
import 'widgets/payment_filter_section.dart';
import 'widgets/payment_list_content.dart';
import 'widgets/payment_dialogs.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentCubit(),
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<PaymentBloc>().add(const FetchAllPaymentsEvent());
        context.read<PaymentBloc>().add(const FetchPaymentAnalyticsEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Scaffold(
      appBar: const PaymentAppBar(),
      body: BlocListener<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is PaymentRefunded) {
            PaymentDialogs.showSnackBar(context, state.message, AppColors.matGreen);
          } else if (state is PaymentError) {
            PaymentDialogs.showSnackBar(context, 'Error: ${state.message}', AppColors.matRed);
          }
        },
        child: Container(
          color: theme.scaffoldBackgroundColor,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // ---------------- Payment Summary Section ----------------
                const PaymentHeaderSection(),
                24.h,
                
                // ---------------- Payment Filters Section ----------------
                const PaymentFilterSection(),
                24.h,
                
                // ---------------- Payments List Section ----------------
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16 : 24,
                  ),
                  child: const PaymentListContent(),
                ),
                32.h,
              ],
            ),
          ),
        ),
      ),
    );
  }
}