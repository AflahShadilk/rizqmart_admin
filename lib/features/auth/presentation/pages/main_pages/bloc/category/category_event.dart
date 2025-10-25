import 'package:equatable/equatable.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/category_model.dart';

abstract class CategoryEvent extends Equatable{
  const CategoryEvent();
  @override

  List<Object?> get props => [];
}

class LoadingCategoryEvent extends CategoryEvent {
  const LoadingCategoryEvent();

}

class CategoryLoadedEvent extends CategoryEvent {
  final List<CategoryModel> categories;
 const CategoryLoadedEvent(this.categories);
   @override

  List<Object?> get props => [categories];
}

class AddCategoryEvent extends CategoryEvent {
  final CategoryModel category;
 const AddCategoryEvent(this.category);
  @override

  List<Object?> get props => [category];
}

class AddVariantEvent extends CategoryEvent {
  final String categoryId;
  final String variant;
 const AddVariantEvent(this.categoryId, this.variant);
}

class UpdateCategoryEvent extends CategoryEvent {
  final CategoryModel model;
 const UpdateCategoryEvent(this.model);
  @override

  List<Object?> get props => [model];
}

class DeleteVariantEvent extends CategoryEvent {
  final String categoryId;
  final String variant;
 const DeleteVariantEvent(this.categoryId, this.variant);
   @override

  List<Object?> get props => [categoryId,variant];
}

class DeleteCategoryEvent extends CategoryEvent {
  final String id;
 const  DeleteCategoryEvent(this.id);
   @override

  List<Object?> get props => [id];
}