import 'package:equatable/equatable.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/product_model.dart';

abstract class ProductState extends Equatable{
  const ProductState();
  @override
  
  List<Object?> get props => [];
}

class LoadingProductState extends ProductState {
  const LoadingProductState();
}

class LoadedProductState extends ProductState {
  final List<AddProductEntity> product;
 const LoadedProductState(this.product);
 @override
  
  List<Object?> get props => [product];
}

class SuccessLoadingState extends ProductState {
  
  final String message;

 const SuccessLoadingState(this.message);
 @override
  
  List<Object?> get props => [message];
}

class FailureLoadingState extends ProductState {
  final String message;
 const FailureLoadingState(this.message);
 @override
  
  List<Object?> get props => [message];
}