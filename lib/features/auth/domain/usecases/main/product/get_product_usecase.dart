import 'package:rizqmartadmin/features/auth/domain/entities/main/product_model.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/product_repository.dart';

class GetProductUsecase {
  ProductRepository repository;
  GetProductUsecase(this.repository);
  Stream<List<AddProductEntity>>call(){
    return repository.getProducts();
  }
}