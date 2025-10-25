import 'package:rizqmartadmin/features/auth/domain/entities/main/category_model.dart';

abstract class CategoryRepository {
  Stream <List<CategoryModel>>getCategories();
  Future<void>addcategory(CategoryModel category);
  Future<void>updateCategory(CategoryModel category);
  Future<void> addVariant(String categoryId, String newVariant);
  Future<void> deleteVariant(String categoryId, String variant);
  Future<void>deleteCategory(String id);
}