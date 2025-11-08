import 'package:equatable/equatable.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/units_entity.dart';

abstract class UnitEvent extends Equatable{
  const UnitEvent();
  @override
  
  List<Object?> get props => [];
}

class UnitLoadingEvent extends UnitEvent{
  const UnitLoadingEvent();
}

class UnitLoadedEvent extends UnitEvent{
final List<UnitsEntity>unit;
  const UnitLoadedEvent(this.unit);
  @override
  List<Object?> get props => [unit];
}
class GetUnitbyCategoryEvent extends UnitEvent{
  final String categoryId;
 const GetUnitbyCategoryEvent(this.categoryId);
 @override
  
  List<Object?> get props => [categoryId];
}
class UnitAddingEvent extends UnitEvent{
  final UnitsEntity unitsEntity;
 const UnitAddingEvent(this.unitsEntity);
 @override
  
  List<Object?> get props => [unitsEntity];
}

class UnitUpdatingEvent extends UnitEvent{
  final UnitsEntity unitsEntity;
  const UnitUpdatingEvent(this.unitsEntity);
  @override
  
  List<Object?> get props => [unitsEntity];
}

class UnitDeletingEvent extends UnitEvent{
  final String id;
  const UnitDeletingEvent(this.id);
  @override
  
  List<Object?> get props => [id];
}
