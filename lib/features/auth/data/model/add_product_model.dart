import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/product_model.dart';

class ProductModel extends AddProductEntity {
 const ProductModel(
      {required super.id,
      required super.name,
      required super.price,
      required super.mrp,
       super.description,
      required super.category,
      required super.brand,
      required super.quantity,
      super.discount,
      required super.variant,
      required super.imageUrls,
      required super.createdAt,
      super.updateAt,
       super.features,
       super.status,
       super.variantDetails
       });

  
factory ProductModel.fromFirestore(DocumentSnapshot doc) {
  final data = doc.data() as Map<String, dynamic>;
  

  DateTime? createdAt;
  try {
    if (data['createdAt'] != null) {
      createdAt = (data['createdAt'] as Timestamp).toDate();
    } else {
      createdAt = DateTime.now();
    }
  } catch (e) {
    createdAt = DateTime.now();
  }
  
  DateTime? updateAt;
  try {
    if (data['updateAt'] != null) {
      updateAt = (data['updateAt'] as Timestamp).toDate();
    }
  } catch (e) {
    updateAt = null;
  }
  List<Map<String,dynamic>>variantDetails=[];
  try{
    if(data['variantDetails']!=null&&data['variantDetails'] is List){
      variantDetails=List<Map<String,dynamic>>.from(  data['variantDetails']);
    }
  }catch(e){
   variantDetails=[];
  }
  
  return ProductModel(
    id: doc.id,
    name: data['name'] ?? 'Unknown',
    price: (data['price'] ?? 0).toDouble(),
    mrp: (data['mrp'] ?? 0).toDouble(),
    description: data['description'] ?? '',
    category: data['category'] ?? '',
    brand: data['brand'] ?? '',
    quantity: (data['quantity'] ?? 0).toDouble(),
    discount: (data['discount'] ?? 0).toDouble(),
    variant: List<String>.from(data['variant']??[] ),
    imageUrls: List<String>.from(data['imageUrls'] ?? []),
    createdAt: createdAt,
    updateAt: updateAt,
    features: data['features'] ?? false,
    status: data['status'] ?? false,
    variantDetails: variantDetails
  );
}

  Map<String, dynamic> toFirestore() {
    return {
    
      'name': name,
      'price': price,
      'mrp'  :mrp,
      'description': description,
      'category': category,
      'brand': brand,
      'quantity': quantity,
      'discount': discount,
      'variant': variant,
      'imageUrls': imageUrls,
      'createdAt': createdAt,
      'updateAt': updateAt,
      'features': features,
      'status'  :status,
      'variantDetails': variantDetails,
    };
  }
}
