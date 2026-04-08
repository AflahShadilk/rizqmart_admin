import 'package:rizqmartadmin/features/domain/entities/main/dashboard_stats_entity.dart';

class DashboardStatsModel extends DashboardStatsEntity {
  const DashboardStatsModel({
    required super.dailyRevenue,
    required super.totalOrders,
    required super.pendingOrders,
    required super.totalProducts,
    required super.totalUsers,
  });

  factory DashboardStatsModel.fromData({
    required double dailyRevenue,
    required int totalOrders,
    required int pendingOrders,
    required int totalProducts,
    required int totalUsers,
  }) {
    return DashboardStatsModel(
      dailyRevenue: dailyRevenue,
      totalOrders: totalOrders,
      pendingOrders: pendingOrders,
      totalProducts: totalProducts,
      totalUsers: totalUsers,
    );
  }
}
