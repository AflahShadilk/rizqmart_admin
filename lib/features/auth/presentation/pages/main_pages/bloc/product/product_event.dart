import 'package:equatable/equatable.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/product_model.dart';

abstract class ProductEvent extends Equatable{
 const ProductEvent();
 @override
  
  List<Object?> get props => [];
}

class LoadingProductEvent extends ProductEvent {
  const LoadingProductEvent();
}

class LoadedProductEvent extends ProductEvent {
  final List<AddProductEntity> product;
 const LoadedProductEvent(this.product);
  @override
  
  List<Object?> get props => [product];
}

class AddingProductEvent extends ProductEvent {
  final AddProductEntity product;
 const AddingProductEvent(this.product);
 @override
  
  List<Object?> get props => [product];
}

class UpdatingProductEvent extends ProductEvent {
  final AddProductEntity product;
const  UpdatingProductEvent(this.product);
@override
  
  List<Object?> get props => [product];
}

class DeletingProductEvent extends ProductEvent {
  final String id;
 const DeletingProductEvent(this.id);
 @override
  
  List<Object?> get props => [id];
}