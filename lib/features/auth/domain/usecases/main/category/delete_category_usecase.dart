import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/category_repository.dart';

class DeleteCategoryUsecase {
  CategoryRepository repository;
  DeleteCategoryUsecase(this.repository);
  Future<Either<Failure, void>> call(String categoryId) async {
    return await repository.deleteCategory(categoryId);
  }
}