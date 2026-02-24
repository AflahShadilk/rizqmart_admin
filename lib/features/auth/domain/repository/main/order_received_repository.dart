import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/order_recieved_entity.dart';

abstract class OrderReceivedRepository {
  Future<Either<Failure, List<OrderReceivedEntity>>> getNewOrders();
  Stream<List<OrderReceivedEntity>> getNewOrdersStream();
  Future<Either<Failure, List<OrderReceivedEntity>>> getOrdersByStatus(String status);
  Future<Either<Failure, OrderReceivedEntity>> getOrderById(String orderId);
  Future<Either<Failure, void>> updateOrderStatus(String orderId, String status);
  Future<Either<Failure, void>> markOrderAsReceived(String orderId);
  Future<Either<Failure, List<OrderReceivedEntity>>> getOrdersByUserId(String userId);
}
