

// ignore_for_file: unnecessary_cast

import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/sales_data_point.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/sales_report_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/sales_report/sales_report_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/sales_report/sales_report_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/sales_report/sales_report_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/salesreport/sales_report_page_cubit.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/salesreport/sales_report_page_cubit_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/sales_report/top_selling_products/top_selling_products_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/sales_report/top_selling_products/top_selling_products_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/sales_report/top_selling_products/top_selling_products_state.dart';

class SalesReportPage extends StatelessWidget {
  const SalesReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SalesReportPageCubit(),
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
    _loadReport();
  }

  void _loadReport() {
    final cubitState = context.read<SalesReportPageCubit>().state;
    context.read<SalesReportBloc>().add(
      LoadSalesReportEvent(startDate: cubitState.startDate, endDate: cubitState.endDate),
    );
    context.read<TopSellingProductsBloc>().add(
      LoadTopSellingProducts(startDate: cubitState.startDate, endDate: cubitState.endDate),
    );
  }

  Future<void> _selectDateRange() async {
    final cubitState = context.read<SalesReportPageCubit>().state;
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
      context.read<SalesReportPageCubit>().updateDateRange(picked.start, picked.end);
      _loadReport();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateState = context.watch<SalesReportPageCubit>().state;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
        actions: MediaQuery.of(context).size.width >= 800 ? [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildFilterChip('Today', SalesFilter.today, dateState),
                const SizedBox(width: 4),
                _buildFilterChip('Week', SalesFilter.thisWeek, dateState),
                const SizedBox(width: 4),
                _buildFilterChip('Month', SalesFilter.thisMonth, dateState),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: _selectDateRange,
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: Text(
                    '${DateFormat('dd MMM').format(dateState.startDate)} – ${DateFormat('dd MMM').format(dateState.endDate)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: dateState.selectedFilter == SalesFilter.custom
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: dateState.selectedFilter == SalesFilter.custom
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
        ] : null,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (MediaQuery.of(context).size.width < 800)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _buildFilterChip('Today', SalesFilter.today, dateState),
                  _buildFilterChip('Week', SalesFilter.thisWeek, dateState),
                  _buildFilterChip('Month', SalesFilter.thisMonth, dateState),
                  TextButton.icon(
                    onPressed: _selectDateRange,
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: Text(
                      '${DateFormat('dd MMM').format(dateState.startDate)} – ${DateFormat('dd MMM').format(dateState.endDate)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: dateState.selectedFilter == SalesFilter.custom
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      backgroundColor: dateState.selectedFilter == SalesFilter.custom
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
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
            final report = state.report;
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
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color),
                      ),
                      16.h,
                      
                          // Summary Cards Grid
                      LayoutBuilder(
                        builder: (context, constraints) {
                          double width = constraints.maxWidth;
                          int crossAxisCount = width >= 1100 ? 4 : (width >= 700 ? 2 : 1);
                          double childAspectRatio = width >= 1100 ? 2.2 : (width >= 700 ? 2.0 : 2.8);
                          
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GridView.count(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                childAspectRatio: childAspectRatio,
                                children: [
                                  _buildSummaryCard('Total Revenue', report.totalRevenue.toStringAsFixed(2), Icons.currency_rupee, AppColors.green),
                                  _buildSummaryCard('Total Orders', report.totalOrders.toString(), Icons.shopping_bag, AppColors.blue),
                                  _buildSummaryCard('Items Sold', report.totalItemsSold.toString(), Icons.inventory_2, AppColors.orange),
                                  _buildSummaryCard('Avg Order Value', report.averageOrderValue.toStringAsFixed(2), Icons.analytics, AppColors.teal),
                                ],
                              ),
                              32.h,
            
                              // Charts Section
                              if (width >= 1100)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(flex: 2, child: _buildRevenueChart(report.dailySales)),
                                    24.w,
                                    Expanded(flex: 1, child: _buildOrderStatusChart(report)),
                                  ],
                                )
                              else
                                Column(
                                  children: [
                                    _buildRevenueChart(report.dailySales),
                                    24.h,
                                    _buildOrderStatusChart(report),
                                  ],
                                ),
                              32.h,

                              // Top Selling Products Section
                              const _TopSellingProductsSection(),
                            ],
                          );
                        }
                      ),    
                    ],
                  ),
                ),
              ),
            );
          }
          return const Center(child: Text('Select a date range to view report'));
        },
      ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          12.w,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style:  TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    maxLines: 1,
                  ),
                ),
                2.h,
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart(List<SalesDataPoint> data) {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withValues(alpha: 0.1), blurRadius: 16)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Revenue Trend', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          24.h,
          Expanded(
            child: data.isEmpty
                ? const Center(child: Text('No revenue data available'))
                : LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: null,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() >= 0 && value.toInt() < data.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    DateFormat('MM/dd').format(data[value.toInt()].date),
                                    style: TextStyle(fontSize: 10, color: Theme.of(context).textTheme.bodySmall?.color),
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
                            interval: (data.length / 5).ceilToDouble().clamp(1, double.infinity), 
                            reservedSize: 30,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((spot) {
                              final dataPoint = data[spot.x.toInt()];
                              return LineTooltipItem(
                                '${DateFormat('MMM dd').format(dataPoint.date)}\n₹${dataPoint.amount.toStringAsFixed(2)}\n${dataPoint.orderCount} orders',
                                TextStyle(
                                  color: AppColors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.amount)).toList(),
                          isCurved: true,
                          color: Theme.of(context).colorScheme.primary,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: data.length <= 14),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }


  Widget _buildOrderStatusChart(SalesReportEntity report) {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withValues(alpha: 0.1), blurRadius: 16)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Order Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          24.h,
          Expanded(
            child: (report.completedOrders == 0 && report.cancelledOrders == 0 && report.pendingOrders == 0)
                ? const Center(child: Text('No order data available'))
                : PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: [
                  if (report.completedOrders > 0)
                    PieChartSectionData(
                      color: AppColors.emerald,
                      value: report.completedOrders.toDouble(),
                      title: '${report.completedOrders}',
                      radius: 50,
                      titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.white),
                    ),
                  if (report.pendingOrders > 0)
                    PieChartSectionData(
                      color: AppColors.amber,
                      value: report.pendingOrders.toDouble(),
                      title: '${report.pendingOrders}',
                      radius: 50,
                      titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.white),
                    ),
                  if (report.cancelledOrders > 0)
                    PieChartSectionData(
                      color: AppColors.chartRed,
                      value: report.cancelledOrders.toDouble(),
                      title: '${report.cancelledOrders}',
                      radius: 50,
                      titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.white),
                    ),
                ],
              ),
            ),
          ),
          16.h,
          _buildLegendItem(AppColors.emerald, 'Completed: ${report.completedOrders}'),
          8.h,
          _buildLegendItem(AppColors.amber, 'Pending: ${report.pendingOrders}'),
          8.h,
          _buildLegendItem(AppColors.chartRed, 'Cancelled: ${report.cancelledOrders}'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, SalesFilter filter, SalesReportPageState dateState) {
    final isSelected = dateState.selectedFilter == filter;
    return ActionChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isSelected
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.primary,
        ),
      ),
      backgroundColor: isSelected
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      onPressed: () => _applyFilter(filter),
    );
  }

  void _applyFilter(SalesFilter filter) {
    final cubit = context.read<SalesReportPageCubit>();
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

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        8.w,
        Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}

/// Presentational widget for the Top Selling Products section.
class _TopSellingProductsSection extends StatelessWidget {
  const _TopSellingProductsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopSellingProductsBloc, TopSellingProductsState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                blurRadius: 16,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.deepPurple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.trending_up_rounded, color: AppColors.deepPurple, size: 20),
                  ),
                  12.w,
                  Expanded(
                    child: Text(
                      'Most Sold Products',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                ],
              ),
              20.h,

              // Content based on state
              if (state is TopSellingProductsLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (state is TopSellingProductsError)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Column(
                      children: [
                        Icon(Icons.error_outline_rounded, color: AppColors.red300, size: 40),
                        12.h,
                        Text(
                          (state as TopSellingProductsError).message,
                          style: TextStyle(color: AppColors.red400, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else if (state is TopSellingProductsLoaded && (state as TopSellingProductsLoaded).products.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Column(
                      children: [
                        Icon(Icons.inventory_2_outlined, color: AppColors.grey400, size: 40),
                        12.h,
                        Text(
                          'No product sales data for this period',
                          style: TextStyle(color: AppColors.grey500, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                )
              else if (state is TopSellingProductsLoaded)
                ..._buildProductRows(context, (state as TopSellingProductsLoaded).products)
              else
                const SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildProductRows(BuildContext context, List products) {
    final widgets = <Widget>[];

    // Table header
    widgets.add(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const SizedBox(width: 36),
            Expanded(
              flex: 3,
              child: Text(
                'Product',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                'Qty Sold',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                'Revenue',
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    widgets.add(8.h);

    // Product rows
    for (int i = 0; i < products.length; i++) {
      final product = products[i];
      final rankColor = i == 0
          ? AppColors.gold
          : i == 1
              ? AppColors.silver
              : i == 2
                  ? AppColors.bronze
                  : AppColors.grey400;

      widgets.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
              ),
            ),
          ),
          child: Row(
            children: [
              // Rank badge
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: rankColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${i + 1}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: rankColor,
                  ),
                ),
              ),
              8.w,
              // Product name
              Expanded(
                flex: 3,
                child: Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Quantity sold
              Expanded(
                flex: 1,
                child: Text(
                  '${product.totalSold}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.deepPurple400,
                  ),
                ),
              ),
              // Revenue
              Expanded(
                flex: 1,
                child: Text(
                  '₹${product.totalRevenue.toStringAsFixed(0)}',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.green600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return widgets;
  }
}
