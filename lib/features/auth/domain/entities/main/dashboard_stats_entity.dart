import 'package:equatable/equatable.dart';

class DashboardStatsEntity extends Equatable {
  final double dailyRevenue;
  final int totalOrders;
  final int pendingOrders;
  final int totalProducts;
  final int totalUsers;

  const DashboardStatsEntity({
    required this.dailyRevenue,
    required this.totalOrders,
    required this.pendingOrders,
    required this.totalProducts,
    required this.totalUsers,
  });

  @override
  List<Object?> get props => [
        dailyRevenue,
        totalOrders,
        pendingOrders,
        totalProducts,
        totalUsers,
      ];
}
