import 'package:rizqmartadmin/features/auth/domain/repository/main/product_repository.dart';

class DeleteProductUsecase {
  ProductRepository repository;
  DeleteProductUsecase(this.repository);
  Future<void>call(String id)async{
    await repository.deleteProduct(id);
  }
}