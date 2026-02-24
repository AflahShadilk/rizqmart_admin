import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/error_handler.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/auth/data/data_sources/main/dashboard_datasource.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/dashboard_stats_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardDataSource dataSource;

  DashboardRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, DashboardStatsEntity>> getDashboardStats() async {
    return ErrorHandler.execute(() => dataSource.getDashboardStats());
  }
}
