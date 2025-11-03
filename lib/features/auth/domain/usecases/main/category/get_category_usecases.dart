import 'package:rizqmartadmin/features/auth/domain/entities/main/category_model.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/category_repository.dart';

class GetCategoryUsecases {
  CategoryRepository repository;
  GetCategoryUsecases(this.repository);
  Stream<List<CategoryModel>>call(){
    return repository.getCategories();
  }
}