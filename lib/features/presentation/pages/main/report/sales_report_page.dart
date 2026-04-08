import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:rizqmartadmin/core/theme/appcolor.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:rizqmartadmin/features/domain/entities/main/sales_report_entity.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/sales_report/sales_report_bloc.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/sales_report/sales_report_event.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/sales_report/sales_report_state.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/sales_report/top_selling_products/top_selling_products_bloc.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/sales_report/top_selling_products/top_selling_products_event.dart';
import 'package:rizqmartadmin/features/presentation/cubit/report/report_cubit.dart';
import 'package:rizqmartadmin/features/presentation/cubit/report/report_state.dart';
import 'widgets/report_filter_bar.dart';
import 'widgets/report_summary_card.dart';
import 'widgets/sales_chart_widget.dart';
import 'widgets/order_status_chart.dart';
import 'widgets/top_selling_products_section.dart';

class SalesReportPage extends StatelessWidget {
  const SalesReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReportCubit(),
      child: const _SalesReportPageView(),
    );
  }
}

class _SalesReportPageView extends StatefulWidget {
  const _SalesReportPageView();

  @override
  State<_SalesReportPageView> createState() => _SalesReportPageViewState();
}

class _SalesReportPageViewState extends State<_SalesReportPageView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadReport();
    });
  }

  void _loadReport() {
    final cubitState = context.read<ReportCubit>().state;
    context.read<SalesReportBloc>().add(
        LoadSalesReportEvent(startDate: cubitState.startDate, endDate: cubitState.endDate),
    );
    context.read<TopSellingProductsBloc>().add(
        LoadTopSellingProducts(startDate: cubitState.startDate, endDate: cubitState.endDate),
    );
  }

  Future<void> _selectDateRange() async {
    final cubitState = context.read<ReportCubit>().state;
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: cubitState.startDate, end: cubitState.endDate),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (!mounted) return;
      context.read<ReportCubit>().updateDateRange(picked.start, picked.end);
      _loadReport();
    }
  }

  void _onFilterChanged(SalesFilter filter) {
    final cubit = context.read<ReportCubit>();
    switch (filter) {
      case SalesFilter.today:
        cubit.setToday();
        break;
      case SalesFilter.thisWeek:
        cubit.setThisWeek();
        break;
      case SalesFilter.thisMonth:
        cubit.setThisMonth();
        break;
      case SalesFilter.custom:
        _selectDateRange();
        return;
    }
    _loadReport();
  }

  @override
  Widget build(BuildContext context) {
    final dateState = context.watch<ReportCubit>().state;
    final isDesktop = ResponsiveBreakpoints.of(context).largerOrEqualTo(DESKTOP);
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      
      // ---------------- Sales Report Header ----------------
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        toolbarHeight: 70,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.analytics_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            12.w,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sales Report',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Visualize your sales performance',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        
        // ---------------- Date Range Filter Section (Desktop) ----------------
        actions: isDesktop
            ? [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: ReportFilterBar(
                    dateState: dateState,
                    onFilterChanged: _onFilterChanged,
                    onCustomDateSelected: _selectDateRange,
                  ),
                )
              ]
            : null,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          // ---------------- Date Range Filter Section (Mobile/Tablet) ----------------
          if (!isDesktop)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ReportFilterBar(
                dateState: dateState,
                onFilterChanged: _onFilterChanged,
                onCustomDateSelected: _selectDateRange,
              ),
            ),
            
          Expanded(
            child: BlocBuilder<SalesReportBloc, SalesReportState>(
              builder: (context, state) {
                if (state is SalesReportLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SalesReportError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else if (state is SalesReportLoaded) {
                  return _buildReportContent(state.report);
                }
                return const Center(child: Text('Select a date range to view report'));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportContent(SalesReportEntity report) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overview',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              16.h,
              LayoutBuilder(
                builder: (context, constraints) {
                  double width = constraints.maxWidth;
                  int crossAxisCount = width >= 1100 ? 4 : (width >= 700 ? 2 : 1);
                  double childAspectRatio = width >= 1100 ? 2.2 : (width >= 700 ? 2.0 : 2.8);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ---------------- Report Summary Cards ----------------
                      GridView.count(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: childAspectRatio,
                        children: [
                          ReportSummaryCard(
                            title: 'Total Revenue',
                            value: report.totalRevenue.toStringAsFixed(2),
                            icon: Icons.currency_rupee,
                            color: AppColors.green,
                          ),
                          ReportSummaryCard(
                            title: 'Total Orders',
                            value: report.totalOrders.toString(),
                            icon: Icons.shopping_bag,
                            color: AppColors.blue,
                          ),
                          ReportSummaryCard(
                            title: 'Items Sold',
                            value: report.totalItemsSold.toString(),
                            icon: Icons.inventory_2,
                            color: AppColors.orange,
                          ),
                          ReportSummaryCard(
                            title: 'Avg Order Value',
                            value: report.averageOrderValue.toStringAsFixed(2),
                            icon: Icons.analytics,
                            color: AppColors.teal,
                          ),
                        ],
                      ),
                      32.h,

                      // ---------------- Sales Chart Section ----------------
                      if (width >= 1100)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 2, child: SalesChartWidget(data: report.dailySales)),
                            24.w,
                            Expanded(flex: 1, child: OrderStatusChart(report: report)),
                          ],
                        )
                      else
                        Column(
                          children: [
                            SalesChartWidget(data: report.dailySales),
                            24.h,
                            OrderStatusChart(report: report),
                          ],
                        ),
                      32.h,

                      // ---------------- Top Selling Products Section ----------------
                      const TopSellingProductsSection(),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
