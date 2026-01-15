import 'package:rizqmartadmin/features/auth/data/data_sources/main/dashboard_datasource.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/dashboard_stats_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardDataSource dataSource;

  DashboardRepositoryImpl({required this.dataSource});

  @override
  Future<DashboardStatsEntity> getDashboardStats() async {
    return await dataSource.getDashboardStats();
  }
}
