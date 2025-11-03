import 'package:rizqmartadmin/features/auth/domain/repository/main/category_repository.dart';

class AddVariantUsecase {
  final CategoryRepository repo;
  AddVariantUsecase(this.repo);
  Future<void>call(String categoryId,String newVariant)async{
    await repo.addVariant(categoryId,newVariant);
  }
}