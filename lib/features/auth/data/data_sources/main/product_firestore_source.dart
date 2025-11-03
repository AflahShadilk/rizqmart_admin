

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmartadmin/features/auth/data/model/add_product_model.dart';

class ProductFirestoreSource {
  final CollectionReference collection=FirebaseFirestore.instance.collection('products');

  Stream<List<ProductModel>> getProducts() {
    
    return collection.snapshots().map((snap) {
      
      final products = snap.docs.map((doc) {
        try {
          return ProductModel.fromFirestore(doc);
        } catch (e) {
          rethrow;
        }
      }).toList();
      
      return products;
    }).handleError((error) {
      throw error;
    });
  }

  Future<void>addProduct(ProductModel product)async{
    try{
    await collection.doc(product.id).set(product.toFirestore());
      }catch(e){
        rethrow;
      }  
  }
  
  Future<void>updateProduct(ProductModel product)async{
    try{
      await collection.doc(product.id).update(product.toFirestore());
    }catch (e){
      rethrow;
    }
  }

  Future<void>deleteProduct(String id)async{
   try{
     await collection.doc(id).delete();
   }catch(e){
    rethrow;
   }
  }

}