

import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
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
                                  _buildSummaryCard('Total Revenue', report.totalRevenue.toStringAsFixed(2), Icons.currency_rupee, Colors.green),
                                  _buildSummaryCard('Total Orders', report.totalOrders.toString(), Icons.shopping_bag, Colors.blue),
                                  _buildSummaryCard('Items Sold', report.totalItemsSold.toString(), Icons.inventory_2, Colors.orange),
                                  _buildSummaryCard('Avg Order Value', report.averageOrderValue.toStringAsFixed(2), Icons.analytics, Colors.teal),
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
                                  color: Colors.white,
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
                      color: const Color(0xFF10B981),
                      value: report.completedOrders.toDouble(),
                      title: '${report.completedOrders}',
                      radius: 50,
                      titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  if (report.pendingOrders > 0)
                    PieChartSectionData(
                      color: const Color(0xFFF59E0B),
                      value: report.pendingOrders.toDouble(),
                      title: '${report.pendingOrders}',
                      radius: 50,
                      titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  if (report.cancelledOrders > 0)
                    PieChartSectionData(
                      color: const Color(0xFFEF4444),
                      value: report.cancelledOrders.toDouble(),
                      title: '${report.cancelledOrders}',
                      radius: 50,
                      titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                ],
              ),
            ),
          ),
          16.h,
          _buildLegendItem(const Color(0xFF10B981), 'Completed: ${report.completedOrders}'),
          8.h,
          _buildLegendItem(const Color(0xFFF59E0B), 'Pending: ${report.pendingOrders}'),
          8.h,
          _buildLegendItem(const Color(0xFFEF4444), 'Cancelled: ${report.cancelledOrders}'),
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