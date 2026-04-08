import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/domain/entities/main/brand_entity.dart';
import 'package:rizqmartadmin/features/domain/repository/main/brand_repository.dart';

class UpdateBrandUsecase {
  BrandRepository repository;
  UpdateBrandUsecase(this.repository);

  Future<Either<Failure, void>> call(BrandEntity brand) async {
    return await repository.updateBrand(brand);
  }
}