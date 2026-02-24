import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/error_handler.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/auth/data/data_sources/main/product_firestore_source.dart';
import 'package:rizqmartadmin/features/auth/data/model/add_product_model.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/product_model.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductFirestoreSource fireStore;
  ProductRepositoryImpl({required this.fireStore});

  @override
  Stream<List<AddProductEntity>> getProducts() {
    return fireStore.getProducts();
  }

  @override
  Future<Either<Failure, void>> addProduct(AddProductEntity entities) async {
    final data = ProductModel(
        id: entities.id,
        name: entities.name,
        description: entities.description,
        category: entities.category,
        brand: entities.brand,
        discount: entities.discount,
        createdAt: entities.createdAt,
        features: entities.features,
        status: entities.status,
        variantDetails: entities.variantDetails);
    return ErrorHandler.execute(() => fireStore.addProduct(data));
  }

  @override
  Future<Either<Failure, void>> updateProduct(AddProductEntity entities) async {
    final data = ProductModel(
        id: entities.id,
        name: entities.name,
        description: entities.description,
        category: entities.category,
        brand: entities.brand,
        discount: entities.discount,
        createdAt: entities.createdAt,
        features: entities.features,
        status: entities.status,
        variantDetails: entities.variantDetails);
    return ErrorHandler.execute(() => fireStore.updateProduct(data));
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    return ErrorHandler.execute(() => fireStore.deleteProduct(id));
  }

  @override
  Future<Either<Failure, void>> updateProductStock(String productId, String? variantId, double quantityChange) async {
    return ErrorHandler.execute(() => fireStore.updateStock(productId, variantId, quantityChange));
  }
}
