import 'package:rizqmartadmin/features/auth/domain/entities/main/sales_report_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/sales_data_point.dart';

class SalesReportModel extends SalesReportEntity {
  const SalesReportModel({
    required super.totalRevenue,
    required super.totalOrders,
    required super.completedOrders,
    required super.cancelledOrders,
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
    required int totalItemsSold,
    required List<SalesDataPoint> dailySales,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return SalesReportModel(
      totalRevenue: totalRevenue,
      totalOrders: totalOrders,
      completedOrders: completedOrders,
      cancelledOrders: cancelledOrders,
      totalItemsSold: totalItemsSold,
      averageOrderValue: totalOrders > 0 ? totalRevenue / totalOrders : 0.0,
      dailySales: dailySales,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
