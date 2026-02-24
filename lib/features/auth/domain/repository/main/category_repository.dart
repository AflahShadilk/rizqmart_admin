import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/category_model.dart';

abstract class CategoryRepository {
  Stream<List<CategoryModel>> getCategories();
  Future<Either<Failure, void>> addcategory(CategoryModel category);
  Future<Either<Failure, void>> updateCategory(CategoryModel category);
  Future<Either<Failure, void>> addVariant(String categoryId, String newVariant);
  Future<Either<Failure, void>> deleteVariant(String categoryId, String variant);
  Future<Either<Failure, void>> deleteCategory(String id);
}