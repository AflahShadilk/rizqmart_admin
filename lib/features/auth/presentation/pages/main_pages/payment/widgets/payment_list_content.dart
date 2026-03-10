import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/payment_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/payment/payment_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/payment/payment_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/cubit/payment/payment_cubit.dart';
import 'package:rizqmartadmin/features/auth/presentation/cubit/payment/payment_state.dart';

import 'payment_grid_card.dart';
import 'payment_card_mobile.dart';
import 'payment_card_desktop.dart';
import 'payment_pagination_widget.dart';

class PaymentListContent extends StatelessWidget {
  const PaymentListContent({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return BlocBuilder<PaymentBloc, PaymentState>(
      builder: (context, state) {
        if (state is PaymentLoading) {
          return const PaymentLoadingWidget();
        }

        List<PaymentEntity> payments = [];

        if (state is AllPaymentsLoaded) {
          payments = state.payments;
        } else if (state is PaymentsByStatusLoaded) {
          payments = state.payments;
        } else if (state is PaymentError) {
          return PaymentErrorWidget(message: state.message);
        }

        if (payments.isEmpty) {
          return const PaymentEmptyWidget();
        }

        const itemsPerPage = 12;
        int totalPages = (payments.length / itemsPerPage).ceil();

        return BlocBuilder<PaymentCubit, PaymentCubitState>(
          builder: (context, cubitState) {
            int safeCurrentPage = cubitState.currentPage;
            if (safeCurrentPage > totalPages && totalPages > 0) {
              safeCurrentPage = totalPages;
            } else if (totalPages == 0) {
              safeCurrentPage = 1;
            }

            int startIndex = (safeCurrentPage - 1) * itemsPerPage;
            int endIndex = startIndex + itemsPerPage;
            startIndex = startIndex.clamp(0, payments.length);
            endIndex = endIndex.clamp(0, payments.length);

            List<PaymentEntity> paginatedPayments = payments.sublist(startIndex, endIndex);

            if (cubitState.isGridView) {
              return Column(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 380,
                      mainAxisExtent: 320,
                      crossAxisSpacing: isMobile ? 12 : 16,
                      mainAxisSpacing: isMobile ? 12 : 16,
                    ),
                    itemCount: paginatedPayments.length,
                    itemBuilder: (context, index) {
                      return PaymentGridCard(payment: paginatedPayments[index]);
                    },
                  ),
                  if (totalPages > 1)
                    Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: PaymentPaginationWidget(totalPages: totalPages),
                    ),
                ],
              );
            } else {
              return Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: paginatedPayments.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: isMobile ? 12 : 16),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 900),
                            child: isMobile
                                ? PaymentCardMobile(payment: paginatedPayments[index])
                                : PaymentCardDesktop(payment: paginatedPayments[index]),
                          ),
                        ),
                      );
                    },
                  ),
                  if (totalPages > 1)
                    Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: PaymentPaginationWidget(totalPages: totalPages),
                    ),
                ],
              );
            }
          },
        );
      },
    );
  }
}

class PaymentLoadingWidget extends StatelessWidget {
  const PaymentLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(64),
        child: Column(
          children: [
            const CircularProgressIndicator(),
            16.h,
            Text(
              'Loading payments...',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentErrorWidget extends StatelessWidget {
  final String message;
  const PaymentErrorWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.matRed[300],
            ),
            16.h,
            Text(
              'Error: $message',
              style: const TextStyle(
                color: AppColors.matRed,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentEmptyWidget extends StatelessWidget {
  const PaymentEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(64),
        child: Column(
          children: [
            Icon(
              Icons.inbox,
              size: 64,
              color: AppColors.grey300,
            ),
            16.h,
            Text(
              'No payments found',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            8.h,
            Text(
              'Check back later for new payments',
              style: TextStyle(
                color: AppColors.grey500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
