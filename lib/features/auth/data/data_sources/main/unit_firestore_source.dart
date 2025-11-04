import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmartadmin/features/auth/data/model/units_model.dart';

class UnitFirestoreSource {
  final CollectionReference collection=FirebaseFirestore.instance.collection('units');

  Stream<List<UnitsModel>>getVariants(){
    return collection.snapshots().map((doc){
      final units=doc.docs.map((unit){
        try{
          return UnitsModel.fromFirestore(unit);
        }catch(e){
          rethrow;
        }
      }).toList();
      return units;
    }).handleError((e){
      throw e;
    });
  }

  Future<void>addUnits(UnitsModel unit)async{
    try{
      await collection.doc(unit.id).set(unit.toFireStore());
    }catch (e){
      rethrow ;
    }
  }
  Future<void>updateUnits(UnitsModel unit)async{
    try{
      await collection.doc(unit.id).update(unit.toFireStore());
    }catch(e){
      rethrow;
    }
  }
  Future<void>deleteUnit(String id)async{
    try{
      await collection.doc(id).delete();
    }catch(e){
      rethrow;
    }
  }
}