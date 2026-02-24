import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/product_model.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/product_repository.dart';

class UpdateProductUsecase {
  ProductRepository repository;
  UpdateProductUsecase(this.repository);
  Future<Either<Failure, void>> call(AddProductEntity product) async {
    return await repository.updateProduct(product);
  }
}