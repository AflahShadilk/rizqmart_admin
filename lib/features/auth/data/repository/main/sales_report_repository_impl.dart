import 'package:rizqmartadmin/features/auth/data/data_sources/main/sales_report_datasource.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/sales_report_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/sales_report_repository.dart';

class SalesReportRepositoryImpl implements SalesReportRepository {
  final SalesReportDataSource dataSource;

  SalesReportRepositoryImpl({required this.dataSource});

  @override
  Future<SalesReportEntity> getSalesReport(DateTime startDate, DateTime endDate) async {
    return await dataSource.getSalesReport(startDate, endDate);
  }
}
