//state
import 'package:equatable/equatable.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/brand_entity.dart';

abstract class BrandState extends Equatable {
  const BrandState();
  @override
  
  List<Object?> get props => [];
}

class BrandLoadingState extends BrandState {
 const BrandLoadingState();
}

class BrandLoadedState extends BrandState {
  final List<BrandEntity> brand;
 const BrandLoadedState(this.brand);
  @override
  List<Object?> get props => [brand];
}

class BrandLoadingSuccessState extends BrandState{
  final String message;
 const BrandLoadingSuccessState(this.message);
  @override
  List<Object?> get props => [message];
}

class BrandFailureState extends BrandState{
  final String error;
 const BrandFailureState(this.error);
  @override
  List<Object?> get props => [error];
}
