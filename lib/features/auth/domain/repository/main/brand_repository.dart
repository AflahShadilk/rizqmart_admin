import 'package:rizqmartadmin/features/auth/domain/entities/main/brand_entity.dart';

abstract class BrandRepository {
  Stream <List<BrandEntity>>getBrands();
  Future<void>addBrand(BrandEntity brandEntity);
  Future<void>updateBrand(BrandEntity brandEntity);
  Future<void>deleteBrand(String id);
}