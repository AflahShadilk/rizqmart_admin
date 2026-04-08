import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/domain/entities/main/brand_entity.dart';

abstract class BrandRepository {
  Stream<List<BrandEntity>> getBrands();
  Future<Either<Failure, void>> addBrand(BrandEntity brandEntity);
  Future<Either<Failure, void>> updateBrand(BrandEntity brandEntity);
  Future<Either<Failure, void>> deleteBrand(String id);
}