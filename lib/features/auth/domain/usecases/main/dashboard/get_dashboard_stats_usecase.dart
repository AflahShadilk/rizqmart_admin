import 'package:rizqmartadmin/features/auth/domain/entities/main/dashboard_stats_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/dashboard_repository.dart';

class GetDashboardStatsUseCase {
  final DashboardRepository repository;

  GetDashboardStatsUseCase({required this.repository});

  Future<DashboardStatsEntity> call() async {
    return await repository.getDashboardStats();
  }
}
