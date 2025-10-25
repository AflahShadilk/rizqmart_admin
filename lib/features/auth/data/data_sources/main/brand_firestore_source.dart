import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmartadmin/features/auth/data/model/brand_model.dart';

class BrandFirestoreSource {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('brands');

  Stream<List<BrandModel>> getBrands() {
    return collection.orderBy('createdAt', descending: false).snapshots().map(
        (snap) =>
            snap.docs.map((doc) => BrandModel.fromFirestore(doc)).toList());
  }

  Future<void> addBrand(BrandModel model) async {
    await collection.doc(model.id).set(model.toFirestore());
  }

  Future<void>updateBrand(BrandModel model)async{
    await collection.doc(model.id).update(model.toFirestore());
  }

  Future<void>deleteBrand(String id)async{
    await collection.doc(id).delete();
  }
}
