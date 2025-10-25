import 'package:equatable/equatable.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/category_model.dart';

abstract class CategoryState extends Equatable {
const CategoryState();
  @override

  List<Object?> get props => [];

}

class CategoryLoadingState extends CategoryState {
  const CategoryLoadingState();
}

class CategoryLoadedState extends CategoryState {
  final List<CategoryModel> cotegories;
 const CategoryLoadedState(this.cotegories);
   @override

  List<Object?> get props => [cotegories];
}

class CategorySuccessState extends CategoryState {
  final String message;
 const CategorySuccessState(this.message);
   @override

  List<Object?> get props => [message];
}

class CategoryFailureState extends CategoryState {
  final String error;
 const CategoryFailureState(this.error);
   @override

  List<Object?> get props => [error];
}