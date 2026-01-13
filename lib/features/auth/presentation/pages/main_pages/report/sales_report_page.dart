// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/sales_data_point.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/sales_report_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/page_decoration/respnsive_page.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/sales_report/sales_report_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/sales_report/sales_report_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/sales_report/sales_report_state.dart';

class SalesReportPage extends StatefulWidget {
  const SalesReportPage({super.key});

  @override
  State<SalesReportPage> createState() => _SalesReportPageState();
}

class _SalesReportPageState extends State<SalesReportPage> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadReport();
  }

  void _loadReport() {
    context.read<SalesReportBloc>().add(
      LoadSalesReportEvent(startDate: _startDate, endDate: _endDate),
    );
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            colorScheme: const ColorScheme.light(primary: Colors.blue),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _loadReport();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 70,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.analytics_rounded,
                color: Colors.blue.shade700,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sales Report',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Visualize your sales performance',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton.icon(
              onPressed: _selectDateRange,
              icon: const Icon(Icons.calendar_today, size: 18),
              label: Text(
                '${DateFormat('dd MMM yyyy').format(_startDate)} - ${DateFormat('dd MMM yyyy').format(_endDate)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue.shade700,
                backgroundColor: Colors.blue.shade50,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<SalesReportBloc, SalesReportState>(
        builder: (context, state) {
          if (state is SalesReportLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SalesReportError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is SalesReportLoaded) {
            final report = state.report;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Overview',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  
                  // Summary Cards Grid
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isDesktop = Responsive.isDesktop(context);
                      final isTablet = Responsive.isTablet(context);
                      int crossAxisCount = isDesktop ? 4 : (isTablet ? 2 : 1);
                      double childAspectRatio = isDesktop ? 1.6 : (isTablet ? 1.4 : 1.8);
                      
                      return GridView.count(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: childAspectRatio,
                        children: [
                          _buildSummaryCard('Total Revenue', '₹${report.totalRevenue.toStringAsFixed(2)}', Icons.currency_rupee, Colors.green),
                          _buildSummaryCard('Total Orders', report.totalOrders.toString(), Icons.shopping_bag, Colors.blue),
                          _buildSummaryCard('Items Sold', report.totalItemsSold.toString(), Icons.inventory_2, Colors.orange),
                          _buildSummaryCard('Avg Order Value', '₹${report.averageOrderValue.toStringAsFixed(2)}', Icons.analytics, Colors.teal),
                        ],
                      );
                    }
                  ),
                  const SizedBox(height: 32),

                  // Charts Section
                  if (Responsive.isDesktop(context))
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: _buildRevenueChart(report.dailySales)),
                        const SizedBox(width: 24),
                        Expanded(flex: 1, child: _buildOrderStatusChart(report)),
                      ],
                    )
                  else
                    Column(
                      children: [
                        _buildRevenueChart(report.dailySales),
                        const SizedBox(height: 24),
                        _buildOrderStatusChart(report),
                      ],
                    ),
                ],
              ),
            );
          }
          return const Center(child: Text('Select a date range to view report'));
        },
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildRevenueChart(List<SalesDataPoint> data) {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Revenue Trend', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Expanded(
            child: data.isEmpty
                ? const Center(child: Text('No revenue data available'))
                : LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true, drawVerticalLine: false),
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
                                    style: const TextStyle(fontSize: 10, color: Colors.grey),
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
                      lineBarsData: [
                        LineChartBarData(
                          spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.amount)).toList(),
                          isCurved: true,
                          color: Colors.blue,
                          barWidth: 4,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.blue.withOpacity(0.1),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Order Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: [
                  PieChartSectionData(
                    color: Colors.purple,
                    value: report.completedOrders.toDouble(),
                    title: '${report.completedOrders}',
                    radius: 50,
                    titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                   PieChartSectionData(
                    color: Colors.red,
                    value: report.cancelledOrders.toDouble(),
                    title: '${report.cancelledOrders}',
                    radius: 50,
                    titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildLegendItem(Colors.purple, 'Completed: ${report.completedOrders}'),
          const SizedBox(height: 8),
          _buildLegendItem(Colors.red, 'Cancelled: ${report.cancelledOrders}'),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}