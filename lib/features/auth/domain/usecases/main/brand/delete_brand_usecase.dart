import 'package:rizqmartadmin/features/auth/domain/repository/main/brand_repository.dart';

class DeleteBrandUsecase {
  BrandRepository repository;
  DeleteBrandUsecase(this.repository);

   Future<void>call(String id)async{
    await repository.deleteBrand(id);
  }
}