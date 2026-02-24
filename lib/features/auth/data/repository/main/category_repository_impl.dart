import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/error_handler.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/auth/data/data_sources/main/category_firestore_source.dart';
import 'package:rizqmartadmin/features/auth/data/model/category_firestore_model.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/category_model.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryFirestoreSource firestoreSource;
  CategoryRepositoryImpl(this.firestoreSource);

  @override
  Stream<List<CategoryModel>> getCategories() {
    return firestoreSource.getCategories();
  }

  @override
  Future<Either<Failure, void>> addcategory(CategoryModel category) async {
    final model = CategoryFirestoreModel(id: category.id, name: category.name, logoUrl: category.logoUrl, variants: category.variants);
    return ErrorHandler.execute(() => firestoreSource.addcategory(model));
  }

  @override
  Future<Either<Failure, void>> updateCategory(CategoryModel category) async {
    final model = CategoryFirestoreModel(id: category.id, name: category.name, logoUrl: category.logoUrl, variants: category.variants);
    return ErrorHandler.execute(() => firestoreSource.updateCategory(model));
  }

  @override
  Future<Either<Failure, void>> addVariant(String categoryId, String newVariant) async {
    return ErrorHandler.execute(() => firestoreSource.addVariantToCategory(categoryId, newVariant));
  }

  @override
  Future<Either<Failure, void>> deleteVariant(String categoryId, String variant) async {
    return ErrorHandler.execute(() => firestoreSource.deleteVariantFromCategory(categoryId, variant));
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String id) async {
    return ErrorHandler.execute(() => firestoreSource.deleteCategory(id));
  }
}
