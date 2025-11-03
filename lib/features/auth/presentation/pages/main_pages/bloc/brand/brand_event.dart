import 'package:equatable/equatable.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/brand_entity.dart';

abstract class BrandEvent extends Equatable{
  const BrandEvent();
  @override
 
  List<Object?> get props => [];
}

class UploadingBrandEvent extends BrandEvent {
  const UploadingBrandEvent();
}

class UploadedBrandEvent extends BrandEvent {
  final List<BrandEntity> products;
 const UploadedBrandEvent(this.products);
 @override
  List<Object?> get props => [products];
}

class AddBrandEvent extends BrandEvent {
  final BrandEntity brandEntity;
 const AddBrandEvent(this.brandEntity);
 @override
  List<Object?> get props => [brandEntity];
}

class UpdateBrandEvent extends BrandEvent{
  final BrandEntity brandEntity;
 const UpdateBrandEvent(this.brandEntity);
   @override
  List<Object?> get props => [brandEntity];
}

class DeleteBrandEvent extends BrandEvent {
  final String id;
 const DeleteBrandEvent(this.id);
  @override
  List<Object?> get props => [id];
}