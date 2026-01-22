

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

  Future<void> updateStock(String productId, String? variantId, double quantityChange) async {
    try {
      final docRef = collection.doc(productId);
      
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        
        if (!snapshot.exists) {
          throw Exception("Product does not exist!");
        }

        final data = snapshot.data() as Map<String, dynamic>;
        List<dynamic> variants = data['variantDetails'] ?? [];
        bool updated = false;

        List<dynamic> newVariants = variants.map((v) {
          // Identify variant by ID if available, or name/unit combination if that's what we have
          // Based on previous code, variantDetails has 'unitName', etc.
          // IF we have a unique ID for variant, use it. Otherwise, standard fallback needed?
          // Since we added variantId to OrderItemEntity, let's assume valid variantId matching
          // or fallback to checking equality if no ID.
          
          if (variantId != null && v['id'] == variantId) {
             double currentQty = (v['quantity'] as num? ?? 0).toDouble();
             v['quantity'] = currentQty + quantityChange;
             updated = true;
          } 
          // Fallback: if we don't have IDs in variants (legacy data), maybe match by unitName?
          // But strict ID matching is safer if IDs exist.
          return v;
        }).toList();

        if (updated) {
          transaction.update(docRef, {'variantDetails': newVariants});
        }
      });
      
    } catch (e) {
      rethrow;
    }
  }
}