import 'package:equatable/equatable.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/units_entity.dart';

abstract class UnitState extends Equatable{
  const UnitState();
  @override
  
  List<Object?> get props => [];
}

class UnitLoadingState extends UnitState{
  const UnitLoadingState();
}

class UnitLoadedState extends UnitState{
  final List<UnitsEntity>unit;
  const UnitLoadedState(this.unit);
  @override
  
  List<Object?> get props => [unit];
}

class UnitSuccessState extends UnitState{
  final String message;
  const UnitSuccessState(this.message);
  @override
  
  List<Object?> get props => [message];
}

class UnitFailureState extends UnitState{
  final String message;
 const UnitFailureState(this.message);
@override
  
  List<Object?> get props => [message];
}  