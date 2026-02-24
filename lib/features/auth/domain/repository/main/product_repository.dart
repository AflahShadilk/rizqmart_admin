import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/product_model.dart';

abstract class ProductRepository {
  Stream<List<AddProductEntity>> getProducts();
  Future<Either<Failure, void>> addProduct(AddProductEntity product);
  Future<Either<Failure, void>> updateProduct(AddProductEntity product);
  Future<Either<Failure, void>> deleteProduct(String id);
  Future<Either<Failure, void>> updateProductStock(String productId, String? variantId, double quantityChange);
}