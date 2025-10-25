import 'package:rizqmartadmin/features/auth/domain/repository/main/category_repository.dart';

class DeleteCategoryUsecase {
  CategoryRepository repository;
  DeleteCategoryUsecase(this.repository);
  Future<void>call(String categoryId)async{
    await repository.deleteCategory(categoryId);
  }
}