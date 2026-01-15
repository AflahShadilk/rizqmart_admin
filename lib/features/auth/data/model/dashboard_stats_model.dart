import 'package:rizqmartadmin/features/auth/domain/entities/main/dashboard_stats_entity.dart';

class DashboardStatsModel extends DashboardStatsEntity {
  const DashboardStatsModel({
    required super.totalRevenue,
    required super.totalOrders,
    required super.pendingOrders,
    required super.totalProducts,
    required super.totalUsers,
  });

  factory DashboardStatsModel.fromData({
    required double totalRevenue,
    required int totalOrders,
    required int pendingOrders,
    required int totalProducts,
    required int totalUsers,
  }) {
    return DashboardStatsModel(
      totalRevenue: totalRevenue,
      totalOrders: totalOrders,
      pendingOrders: pendingOrders,
      totalProducts: totalProducts,
      totalUsers: totalUsers,
    );
  }
}
