import 'package:rizqmartadmin/features/auth/domain/entities/main/brand_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/brand_repository.dart';

class GetBrandUsecases {
  BrandRepository brandRepository;
  GetBrandUsecases(this.brandRepository);
  Stream<List<BrandEntity>>call(){
   return brandRepository.getBrands();
  }
  
 
}