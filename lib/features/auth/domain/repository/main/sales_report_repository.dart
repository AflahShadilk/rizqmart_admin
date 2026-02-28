import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/sales_report_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/top_selling_product_entity.dart';

abstract class SalesReportRepository {
  Future<Either<Failure, SalesReportEntity>> getSalesReport(DateTime startDate, DateTime endDate);
  Future<Either<Failure, List<TopSellingProductEntity>>> getTopSellingProducts(DateTime startDate, DateTime endDate, {int limit = 10});
}
