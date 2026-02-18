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
      // Fetch orders within date range
      // Note: We use paymentStatus 'succeeded' for revenue calculation
      final querySnapshot = await firestore
          .collection('orders')
          .get();
      
      double totalRevenue = 0;
      int completedOrders = 0;
      int cancelledOrders = 0;
      int totalItemsSold = 0;
      Map<DateTime, double> dailyRevenueMap = {};

      for (var doc in querySnapshot.docs) {
        final order = OrderReceivedModel.fromFirestore(doc);
        
        // Calculate Revenue (only for non-cancelled/refunded orders)
        if (order.paymentStatus == 'succeeded' && 
            order.orderStatus != 'refunded') {
          totalRevenue += order.totalAmount;
          totalItemsSold += order.itemCount;
          
          // Normalize date to day (reset time to 00:00:00)
          final dateKey = DateTime(
            order.createdAt.year,
            order.createdAt.month,
            order.createdAt.day,
          );
          
          dailyRevenueMap[dateKey] = (dailyRevenueMap[dateKey] ?? 0) + order.totalAmount;
        }

        if (order.orderStatus == 'received') {
          completedOrders++;
        } else if (order.orderStatus == 'cancelled' || 
                   order.orderStatus == 'rejected') {
          cancelledOrders++;
        }
      }

      // Convert Map to List<SalesDataPoint> and sort by date
      final dailySales = dailyRevenueMap.entries.map((e) {
        return SalesDataPoint(date: e.key, amount: e.value);
      }).toList();
      
      dailySales.sort((a, b) => a.date.compareTo(b.date));

      return SalesReportModel.fromData(
        totalRevenue: totalRevenue,
        totalOrders: querySnapshot.docs.length,
        completedOrders: completedOrders,
        cancelledOrders: cancelledOrders,
        totalItemsSold: totalItemsSold,
        dailySales: dailySales,
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      throw Exception('Failed to generate sales report: $e');
    }
  }
}
