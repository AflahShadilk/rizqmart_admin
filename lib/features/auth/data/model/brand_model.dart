
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/brand_entity.dart';

class BrandModel extends BrandEntity {
  // ignore: use_super_parameters
  BrandModel(
      {required String id,
      required String name,
      required String logourl,
      required String description,
      required bool status})
      : super(
            id: id,
            name: name,
            logourl: logourl,
            description: description,
            status: status);

  factory BrandModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BrandModel(
        id: doc.id,
        name: data['name'] ?? '',
        logourl: data['logourl'] ?? '',
        description: data['description'] ?? '',
        status: data['status'] ?? false);
  }
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'logourl': logourl,
      'description': description,
      'status': status,
      'createdAt': FieldValue.serverTimestamp()
    };
  }
}
