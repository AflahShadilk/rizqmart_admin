import 'package:flutter/material.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:rizqmartadmin/core/theme/appcolor.dart';
import 'package:rizqmartadmin/features/presentation/widgets/common/animated_hover_card.dart';
import 'package:rizqmartadmin/features/domain/entities/main/sales_report_entity.dart';

class OrderStatusChart extends StatelessWidget {
  final SalesReportEntity report;

  const OrderStatusChart({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: AnimatedHoverCard(
        padding: const EdgeInsets.all(24),
        borderRadius: BorderRadius.circular(20),
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
            _LegendItem(color: AppColors.emerald, text: 'Completed: ${report.completedOrders}'),
            8.h,
            _LegendItem(color: AppColors.amber, text: 'Pending: ${report.pendingOrders}'),
            8.h,
            _LegendItem(color: AppColors.chartRed, text: 'Cancelled: ${report.cancelledOrders}'),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const _LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        8.w,
        Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
