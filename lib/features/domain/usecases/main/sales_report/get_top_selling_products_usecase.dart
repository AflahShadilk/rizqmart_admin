import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/domain/entities/main/top_selling_product_entity.dart';
import 'package:rizqmartadmin/features/domain/repository/main/sales_report_repository.dart';

/// Use case to fetch top-selling products within a date range.
class GetTopSellingProductsUseCase {
  final SalesReportRepository repository;

  GetTopSellingProductsUseCase(this.repository);

  Future<Either<Failure, List<TopSellingProductEntity>>> call(
    DateTime startDate,
    DateTime endDate, {
    int limit = 10,
  }) async {
    return await repository.getTopSellingProducts(startDate, endDate, limit: limit);
  }
}
