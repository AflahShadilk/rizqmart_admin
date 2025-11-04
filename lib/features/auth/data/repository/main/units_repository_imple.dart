import 'package:rizqmartadmin/features/auth/data/data_sources/main/unit_firestore_source.dart';
import 'package:rizqmartadmin/features/auth/data/model/units_model.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/units_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/units_repository.dart';

class UnitsRepositoryImple implements UnitsRepository{
  final UnitFirestoreSource unitFirestoreSource;
  const UnitsRepositoryImple( {required this.unitFirestoreSource});
 
 @override
 Stream<List<UnitsEntity>>getUnits(){
  return unitFirestoreSource.getVariants();
 }

 @override
  Future<void>addUnit(UnitsEntity unit)async{
  final model=UnitsModel(id: unit.id, unitName:unit. unitName, unitType:unit. unitType, wieght:unit. wieght);
  await unitFirestoreSource.addUnits(model);
 }

 @override
  Future<void>updateUnits(UnitsEntity unit)async{
  final model=UnitsModel(id: unit.id, unitName:unit. unitName, unitType:unit. unitType, wieght:unit. wieght);
  await unitFirestoreSource.updateUnits(model);
 }

 @override
  Future<void>deleteUnit(String id)async{
  await unitFirestoreSource.deleteUnit(id);
 }
}