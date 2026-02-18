import 'package:rizqmartadmin/features/auth/domain/entities/main/sales_report_entity.dart';

abstract class SalesReportRepository {
  Future<SalesReportEntity> getSalesReport(DateTime startDate, DateTime endDate);
}
