import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmartadmin/features/auth/data/model/category_firestore_model.dart';

class CategoryFirestoreSource {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('categories');

  Stream<List<CategoryFirestoreModel>> getCategories() {
    return collection.orderBy('createdAt', descending: false).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => CategoryFirestoreModel.fromFirestore(doc))
            .toList());
  }

  Future<void> addcategory(CategoryFirestoreModel model) async {
    await collection.doc(model.id).set(model.toMap());
  }

  Future<void> updateCategory(CategoryFirestoreModel model) async {
    await collection.doc(model.id).update(model.toMap());
  }

  Future<void> addVariantToCategory(
      String categoryId, String newVariant) async {
    await collection.doc(categoryId).update({
      'variants': FieldValue.arrayUnion([newVariant]),
    });
  }

  Future<void> deleteVariantFromCategory(
      String categoryId, String variant) async {
    await collection.doc(categoryId).update({
      'variants': FieldValue.arrayRemove([variant]),
    });
  }

  Future<void> deleteCategory(String id) async {
    await collection.doc(id).delete();
  }
}
