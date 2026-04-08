import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/domain/entities/main/category_model.dart';
import 'package:rizqmartadmin/features/domain/repository/main/category_repository.dart';

class UpdateCategoryUsecase {
  CategoryRepository repository;
  UpdateCategoryUsecase(this.repository);
  Future<Either<Failure, void>> call(CategoryModel model) async {
    return await repository.updateCategory(model);
  }
}