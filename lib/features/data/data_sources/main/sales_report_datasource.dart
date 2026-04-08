import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmartadmin/features/data/models/sales_report_model.dart';
import 'package:rizqmartadmin/features/data/models/order_received_model.dart';
import 'package:rizqmartadmin/features/data/models/top_selling_product_model.dart';
import 'package:rizqmartadmin/features/domain/entities/main/sales_data_point.dart';

abstract class SalesReportDataSource {
  Future<SalesReportModel> getSalesReport(DateTime startDate, DateTime endDate);
  Future<List<TopSellingProductModel>> getTopSellingProducts(DateTime startDate, DateTime endDate, {int limit = 10});
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

  @override
  Future<List<TopSellingProductModel>> getTopSellingProducts(
    DateTime startDate,
    DateTime endDate, {
    int limit = 10,
  }) async {
    try {
      final endOfDay = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

      // Query only completed/paid orders in the date range
      final querySnapshot = await firestore
          .collection('orders')
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .orderBy('createdAt', descending: true)
          .get();

      // Aggregate product sales from order items
      final Map<String, _ProductAggregate> aggregateMap = {};

      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        final status = data['status'] ?? data['orderStatus'] ?? 'pending';
        final paymentStatus = data['paymentStatus'] ?? 'pending';

        // Only count revenue-contributing orders
        if (paymentStatus != 'succeeded' || status == 'refunded') continue;

        final items = data['items'] as List<dynamic>? ?? [];
        for (final item in items) {
          final productId = item['id'] ?? item['productId'] ?? '';
          final productName = item['name'] ?? item['productName'] ?? 'Unknown';
          final quantity = _parseAmount(item['count'] ?? item['quantity'] ?? 0).toInt();
          
          final variantIndex = (item['variantIndex'] as num?)?.toInt() ?? 0;
          final variants = item['variantDetails'] as List<dynamic>?;
          final variant = (variants != null && variants.isNotEmpty && variantIndex < variants.length)
              ? variants[variantIndex] as Map<String, dynamic>
              : <String, dynamic>{};
          final price = _parseAmount(variant['price'] ?? item['price'] ?? 0);

          if (productId.isEmpty) continue;

          if (aggregateMap.containsKey(productId)) {
            aggregateMap[productId]!.totalSold += quantity;
            aggregateMap[productId]!.totalRevenue += price * quantity;
          } else {
            aggregateMap[productId] = _ProductAggregate(
              name: productName,
              totalSold: quantity,
              totalRevenue: price * quantity,
            );
          }
        }
      }

      // Sort by totalSold descending and take top N
      final sortedEntries = aggregateMap.entries.toList()
        ..sort((a, b) => b.value.totalSold.compareTo(a.value.totalSold));

      return sortedEntries
          .take(limit)
          .map((e) => TopSellingProductModel(
                productId: e.key,
                name: e.value.name,
                totalSold: e.value.totalSold,
                totalRevenue: e.value.totalRevenue,
              ))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch top selling products: \$e');
    }
  }

  static double _parseAmount(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}

/// Helper class for in-memory aggregation (not exposed outside data source).
class _ProductAggregate {
  final String name;
  int totalSold;
  double totalRevenue;

  _ProductAggregate({
    required this.name,
    required this.totalSold,
    required this.totalRevenue,
  });
}

