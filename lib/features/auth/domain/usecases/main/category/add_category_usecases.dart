import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/category_model.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/category_repository.dart';

class AddCategoryUsecases {
  CategoryRepository repository;
  AddCategoryUsecases(this.repository);
  Future<Either<Failure, void>> call(CategoryModel model) async {
    return await repository.addcategory(model);
  }
}