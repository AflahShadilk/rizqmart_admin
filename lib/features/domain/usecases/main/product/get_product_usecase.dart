import 'package:rizqmartadmin/features/domain/entities/main/product_model.dart';
import 'package:rizqmartadmin/features/domain/repository/main/product_repository.dart';

class GetProductUsecase {
  ProductRepository repository;
  GetProductUsecase(this.repository);
  Stream<List<AddProductEntity>>call(){
    return repository.getProducts();
  }
}