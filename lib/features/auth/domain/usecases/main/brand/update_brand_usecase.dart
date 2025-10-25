import 'package:rizqmartadmin/features/auth/domain/entities/main/brand_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/brand_repository.dart';

class UpdateBrandUsecase {
  BrandRepository repository;
  UpdateBrandUsecase(this.repository);

   Future<void>call(BrandEntity brand)async{
    await repository.updateBrand(brand);
  }
}