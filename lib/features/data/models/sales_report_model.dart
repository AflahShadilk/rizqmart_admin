import 'package:rizqmartadmin/features/domain/entities/main/sales_report_entity.dart';
import 'package:rizqmartadmin/features/domain/entities/main/sales_data_point.dart';

class SalesReportModel extends SalesReportEntity {
  const SalesReportModel({
    required super.totalRevenue,
    required super.totalOrders,
    required super.completedOrders,
    required super.cancelledOrders,
    required super.pendingOrders,
    required super.totalItemsSold,
    required super.averageOrderValue,
    required super.dailySales,
    required super.startDate,
    required super.endDate,
  });

  factory SalesReportModel.fromData({
    required double totalRevenue,
    required int totalOrders,
    required int completedOrders,
    required int cancelledOrders,
    required int pendingOrders,
    required int totalItemsSold,
    required int revenueContributingOrders,
    required List<SalesDataPoint> dailySales,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return SalesReportModel(
      totalRevenue: totalRevenue,
      totalOrders: totalOrders,
      completedOrders: completedOrders,
      cancelledOrders: cancelledOrders,
      pendingOrders: pendingOrders,
      totalItemsSold: totalItemsSold,
      averageOrderValue: revenueContributingOrders > 0
          ? totalRevenue / revenueContributingOrders
          : 0.0,
      dailySales: dailySales,
      startDate: startDate,
      endDate: endDate,
    );
  }
}

