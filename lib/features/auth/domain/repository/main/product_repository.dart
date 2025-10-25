import 'package:rizqmartadmin/features/auth/domain/entities/main/product_model.dart';

abstract class ProductRepository {
  Stream<List<AddProductEntity>>getProducts();
  Future<void>addProduct(AddProductEntity product);
  Future<void>updateProduct(AddProductEntity product);
  Future<void>deleteProduct(String id);
}