import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/category_model.dart';

class CategoryFirestoreModel extends CategoryModel {
  // ignore: use_super_parameters
  const CategoryFirestoreModel(
      {required String id,
      required String name,
      String? logoUrl,
      List<String>? variants})
      : super(
          id: id,
          name: name,
          logoUrl: logoUrl,
          variants: variants,
        );

  factory CategoryFirestoreModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CategoryFirestoreModel(
        id: doc.id,
        name: data['name'] ?? '',
        logoUrl: data['logoUrl'] ?? '',
        variants: List<String>.from(data['variants'] ?? []));
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'variants': variants,
      'logoUrl': logoUrl,
      'createdAt': FieldValue.serverTimestamp()
    };
  }
}