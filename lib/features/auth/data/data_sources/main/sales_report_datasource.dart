import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmartadmin/features/auth/data/model/sales_report_model.dart';
import 'package:rizqmartadmin/features/auth/data/model/order_received_model.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/sales_data_point.dart';

abstract class SalesReportDataSource {
  Future<SalesReportModel> getSalesReport(DateTime startDate, DateTime endDate);
}

class SalesReportDataSourceImpl implements SalesReportDataSource {
  final FirebaseFirestore firestore;

  SalesReportDataSourceImpl({required this.firestore});

  @override
  Future<SalesReportModel> getSalesReport(DateTime startDate, DateTime endDate) async {
    try {
      // Normalize endDate to end of day so the full day is included
      final endOfDay = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

      // Fetch orders within selected date range only
      final querySnapshot = await firestore
          .collection('orders')
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .orderBy('createdAt', descending: true)
          .get();
      
      double totalRevenue = 0;
      int completedOrders = 0;
      int cancelledOrders = 0;
      int pendingOrders = 0;
      int totalItemsSold = 0;
      int revenueContributingOrders = 0;
      Map<DateTime, double> dailyRevenueMap = {};
      Map<DateTime, int> dailyOrderCountMap = {};

      for (var doc in querySnapshot.docs) {
        final order = OrderReceivedModel.fromFirestore(doc);
        
        // Normalize date to day (reset time to 00:00:00)
        final dateKey = DateTime(
          order.createdAt.year,
          order.createdAt.month,
          order.createdAt.day,
        );

        // Calculate Revenue (only for non-cancelled/refunded orders)
        if (order.paymentStatus == 'succeeded' && 
            order.orderStatus != 'refunded') {
          totalRevenue += order.totalAmount;
          revenueContributingOrders++;
          
          // Sum actual item quantities instead of just counting line items
          for (var item in order.items) {
            totalItemsSold += item.quantity.toInt();
          }
          
          dailyRevenueMap[dateKey] = (dailyRevenueMap[dateKey] ?? 0) + order.totalAmount;
          dailyOrderCountMap[dateKey] = (dailyOrderCountMap[dateKey] ?? 0) + 1;
        }

        // Order status breakdown
        if (order.orderStatus == 'received') {
          completedOrders++;
        } else if (order.orderStatus == 'cancelled' || 
                   order.orderStatus == 'rejected') {
          cancelledOrders++;
        } else {
          // pending, processing, shipped, etc.
          pendingOrders++;
        }
      }

      // Fill in all dates in the range (even those with no orders)
      // so the chart shows continuous data without gaps
      final normalizedStart = DateTime(startDate.year, startDate.month, startDate.day);
      final normalizedEnd = DateTime(endDate.year, endDate.month, endDate.day);
      
      List<SalesDataPoint> dailySales = [];
      DateTime current = normalizedStart;
      while (!current.isAfter(normalizedEnd)) {
        dailySales.add(SalesDataPoint(
          date: current,
          amount: dailyRevenueMap[current] ?? 0.0,
          orderCount: dailyOrderCountMap[current] ?? 0,
        ));
        current = current.add(const Duration(days: 1));
      }

      return SalesReportModel.fromData(
        totalRevenue: totalRevenue,
        totalOrders: querySnapshot.docs.length,
        completedOrders: completedOrders,
        cancelledOrders: cancelledOrders,
        pendingOrders: pendingOrders,
        totalItemsSold: totalItemsSold,
        revenueContributingOrders: revenueContributingOrders,
        dailySales: dailySales,
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      throw Exception('Failed to generate sales report: \$e');
    }
  }
}
