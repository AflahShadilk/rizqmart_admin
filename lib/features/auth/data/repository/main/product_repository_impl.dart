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
  Future<void> addProduct(AddProductEntity entities) async {
    final data = ProductModel(
        id: entities.id,
        name: entities.name,
        price: entities.price,
        mrp: entities.mrp,
        description: entities.description,
        category: entities.category,
        brand: entities.brand,
        quantity: entities.quantity,
        discount: entities.discount,
        variant: entities.variant,
        imageUrls: entities.imageUrls,
        createdAt: entities.createdAt,
        features: entities.features,
        status: entities.status
        );
    await fireStore.addProduct(data);
  }

  @override
  Future<void> updateProduct(AddProductEntity entities) async {
    final data = ProductModel(
        id: entities.id,
        name: entities.name,
        price: entities.price,
        mrp: entities.mrp,
        description: entities.description,
        category: entities.category,
        brand: entities.brand,
        quantity: entities.quantity,
        discount: entities.discount,
        variant: entities.variant,
        imageUrls: entities.imageUrls,
        createdAt: entities.createdAt,
        features: entities.features,
        status: entities.status
        );
    await fireStore.updateProduct(data);
  }

  @override
  Future<void> deleteProduct(String id) async {
    await fireStore.deleteProduct(id);
  }
}
