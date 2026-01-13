import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmartadmin/features/auth/data/model/order_received_model.dart';

abstract class OrderReceivedDataSource {
  Future<List<OrderReceivedModel>> getNewOrders();
  Future<List<OrderReceivedModel>> getOrdersByStatus(String status);
  Future<OrderReceivedModel> getOrderById(String orderId);
  Future<void> updateOrderStatus(String orderId, String status);
  Future<void> markOrderAsReceived(String orderId);
}

class OrderReceivedDataSourceImpl implements OrderReceivedDataSource {
  final FirebaseFirestore firestore;

  OrderReceivedDataSourceImpl({required this.firestore});

  @override
  Future<List<OrderReceivedModel>> getNewOrders() async {
    try {
      final snapshot = await firestore
          .collection('orders')
          .where('paymentStatus', isEqualTo: 'succeeded')
          .orderBy('createdAt', descending: true)
          .get();


      
      return snapshot.docs
          .map((doc) {
            final data = doc.data();
            return OrderReceivedModel.fromFirestore(doc);
          })
          .toList();
    } catch (e) {

      throw Exception('Failed to fetch new orders: $e');
    }
  }

  @override
  Future<List<OrderReceivedModel>> getOrdersByStatus(String status) async {
    try {

      
      final snapshot = await firestore
          .collection('orders')
          .where('orderStatus', isEqualTo: status)  
          .where('paymentStatus', isEqualTo: 'succeeded')
          .orderBy('createdAt', descending: true)
          .get();


      
      return snapshot.docs
          .map((doc) {
            final data = doc.data();

            return OrderReceivedModel.fromFirestore(doc);
          })
          .toList();
    } catch (e) {

      throw Exception('Failed to fetch orders by status: $e');
    }
  }

  @override
  Future<OrderReceivedModel> getOrderById(String orderId) async {
    try {
      final doc = await firestore.collection('orders').doc(orderId).get();
      
      if (!doc.exists) {

        throw Exception('Order not found');
      }
      

      return OrderReceivedModel.fromFirestore(doc);
    } catch (e) {

      throw Exception('Failed to fetch order: $e');
    }
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await firestore.collection('orders').doc(orderId).update({
        'orderStatus': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      

    } catch (e) {

      throw Exception('Failed to update order status: $e');
    }
  }

  @override
  Future<void> markOrderAsReceived(String orderId) async {
    try {
      await firestore.collection('orders').doc(orderId).update({
        'orderStatus': 'received',
        'receivedAt': FieldValue.serverTimestamp(),
      });
      

    } catch (e) {

      throw Exception('Failed to mark order as received: $e');
    }
  }
}