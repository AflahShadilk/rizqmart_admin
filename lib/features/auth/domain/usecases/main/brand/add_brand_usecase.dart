import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/brand_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/brand_repository.dart';

class AddBrandUsecase {
  BrandRepository repository;
  AddBrandUsecase(this.repository);

  Future<Either<Failure, void>> call(BrandEntity brand) async {
    return await repository.addBrand(brand);
  }
}