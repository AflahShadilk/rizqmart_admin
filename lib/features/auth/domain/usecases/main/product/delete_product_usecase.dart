import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/product_repository.dart';

class DeleteProductUsecase {
  ProductRepository repository;
  DeleteProductUsecase(this.repository);
  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteProduct(id);
  }
}