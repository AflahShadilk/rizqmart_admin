import 'package:equatable/equatable.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/sales_data_point.dart';

class SalesReportEntity extends Equatable {
  final double totalRevenue;
  final int totalOrders;
  final int completedOrders;
  final int cancelledOrders;
  final int totalItemsSold;
  final double averageOrderValue;
  final List<SalesDataPoint> dailySales;
  final DateTime startDate;
  final DateTime endDate;

  const SalesReportEntity({
    required this.totalRevenue,
    required this.totalOrders,
    required this.completedOrders,
    required this.cancelledOrders,
    required this.totalItemsSold,
    required this.averageOrderValue,
    required this.dailySales,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [
        totalRevenue,
        totalOrders,
        completedOrders,
        cancelledOrders,
        totalItemsSold,
        averageOrderValue,
        dailySales,
        startDate,
        endDate,
      ];
}
