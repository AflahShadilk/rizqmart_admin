import 'package:rizqmartadmin/features/auth/domain/entities/main/category_model.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/category_repository.dart';

class AddCategoryUsecases {
  CategoryRepository repository;
  AddCategoryUsecases(this.repository);
  Future<void>call(CategoryModel model)async{
    await repository.addcategory(model);
  }
}