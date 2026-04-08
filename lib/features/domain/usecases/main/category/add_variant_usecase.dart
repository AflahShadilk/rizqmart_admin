import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/domain/repository/main/category_repository.dart';

class AddVariantUsecase {
  final CategoryRepository repo;
  AddVariantUsecase(this.repo);
  Future<Either<Failure, void>> call(String categoryId, String newVariant) async {
    return await repo.addVariant(categoryId, newVariant);
  }
}