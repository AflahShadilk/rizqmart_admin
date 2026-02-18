import 'package:rizqmartadmin/features/auth/domain/entities/main/dashboard_stats_entity.dart';

abstract class DashboardRepository {
  Future<DashboardStatsEntity> getDashboardStats();
}
