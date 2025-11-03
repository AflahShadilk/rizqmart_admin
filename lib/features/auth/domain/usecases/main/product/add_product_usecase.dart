import 'package:rizqmartadmin/features/auth/domain/entities/main/product_model.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/product_repository.dart';

class AddProductUsecase {
  ProductRepository repository;
  AddProductUsecase(this.repository);
  Future<void>call(AddProductEntity product)async{
    await repository.addProduct(product);
  }
}