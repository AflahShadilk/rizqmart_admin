import 'package:rizqmartadmin/features/auth/domain/entities/main/order_recieved_entity.dart';

abstract class OrderReceivedRepository {
  Future<List<OrderReceivedEntity>> getNewOrders();
  Stream<List<OrderReceivedEntity>> getNewOrdersStream();
  Future<List<OrderReceivedEntity>> getOrdersByStatus(String status);
  Future<OrderReceivedEntity> getOrderById(String orderId);
  Future<void> updateOrderStatus(String orderId, String status);
  Future<void> markOrderAsReceived(String orderId);
}
