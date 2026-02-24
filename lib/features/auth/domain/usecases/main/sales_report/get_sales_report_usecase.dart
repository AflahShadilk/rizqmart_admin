import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/sales_report_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/sales_report_repository.dart';

class GetSalesReportUseCase {
  final SalesReportRepository repository;

  GetSalesReportUseCase(this.repository);

  Future<Either<Failure, SalesReportEntity>> call(DateTime startDate, DateTime endDate) async {
    return await repository.getSalesReport(startDate, endDate);
  }
}
