import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/domain/repository/main/category_repository.dart';

class DeleteVariantUsecase {
  CategoryRepository repository;
  DeleteVariantUsecase(this.repository);
  Future<Either<Failure, void>> call(String categoryId, String variant) async {
    return await repository.deleteVariant(categoryId, variant);
  }
}