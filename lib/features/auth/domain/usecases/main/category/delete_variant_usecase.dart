
import 'package:rizqmartadmin/features/auth/domain/repository/main/category_repository.dart';

class DeleteVariantUsecase {
  CategoryRepository repository;
  DeleteVariantUsecase(this.repository);
  Future<void>call(String categoryId,String variant)async{
    await repository.deleteVariant(categoryId, variant);
  }
}