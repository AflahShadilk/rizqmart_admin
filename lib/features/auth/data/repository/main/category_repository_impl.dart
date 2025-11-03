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
  Future<void>addcategory(CategoryModel category)async{
    final model=CategoryFirestoreModel(id: category.id, name: category.name,variants: category.variants);
    await firestoreSource.addcategory(model);
  }
  @override
  Future<void>updateCategory(CategoryModel category)async{
    final model=CategoryFirestoreModel(id: category.id, name:category.name,variants: category.variants);
    await firestoreSource.updateCategory(model);
  }
  
  @override
  Future<void> addVariant(String categoryId, String newVariant) async {
  await firestoreSource.addVariantToCategory(categoryId, newVariant);
 }

  @override
Future<void> deleteVariant(String categoryId, String variant) async {
  await firestoreSource.deleteVariantFromCategory(categoryId, variant);
}

  @override
  Future<void>deleteCategory(String id)async{
    await firestoreSource.deleteCategory(id);
  }
}
