import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/units_entity.dart';

class UnitsModel extends UnitsEntity{
 const UnitsModel({required super.id,required super.unitName,required super.unitType,required super.wieght,required super.category});
 
 factory UnitsModel.fromFirestore(DocumentSnapshot snap){
  final data=snap.data() as Map<String,dynamic>;
  return UnitsModel(id: snap.id, unitName: data['unitName']??'', unitType: data['unitType']??'', wieght:(data['wieght']??0.0).toDouble(),category: data['category']??'');

 }
 Map<String,dynamic>toFireStore(){
  return {
    'unitName':unitName,
    'unitType':unitType,
    'wieght'  :wieght,
    "category":category
  };
 }
}