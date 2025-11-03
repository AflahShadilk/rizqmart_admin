import 'package:rizqmartadmin/features/auth/domain/entities/main/brand_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/brand_repository.dart';

class AddBrandUsecase {
  BrandRepository repository;
  AddBrandUsecase(this.repository);

   Future<void>call(BrandEntity brand)async{
    await repository.addBrand(brand);
  }
}