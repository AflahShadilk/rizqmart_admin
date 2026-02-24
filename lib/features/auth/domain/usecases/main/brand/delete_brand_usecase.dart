import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/brand_repository.dart';

class DeleteBrandUsecase {
  BrandRepository repository;
  DeleteBrandUsecase(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteBrand(id);
  }
}