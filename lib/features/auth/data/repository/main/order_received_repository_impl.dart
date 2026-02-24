import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/error_handler.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/auth/data/data_sources/main/order_received_datasource.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/order_recieved_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/order_received_repository.dart';

class OrderReceivedRepositoryImpl implements OrderReceivedRepository {
  final OrderReceivedDataSource dataSource;

  OrderReceivedRepositoryImpl({required this.dataSource});

  @override
  Stream<List<OrderReceivedEntity>> getNewOrdersStream() {
    return dataSource.getNewOrdersStream();
  }

  @override
  Future<Either<Failure, List<OrderReceivedEntity>>> getNewOrders() async {
    return ErrorHandler.execute(() => dataSource.getNewOrders());
  }

  @override
  Future<Either<Failure, List<OrderReceivedEntity>>> getOrdersByStatus(String status) async {
    return ErrorHandler.execute(() => dataSource.getOrdersByStatus(status));
  }

  @override
  Future<Either<Failure, OrderReceivedEntity>> getOrderById(String orderId) async {
    return ErrorHandler.execute(() => dataSource.getOrderById(orderId));
  }

  @override
  Future<Either<Failure, void>> updateOrderStatus(String orderId, String status) async {
    return ErrorHandler.execute(() => dataSource.updateOrderStatus(orderId, status));
  }

  @override
  Future<Either<Failure, void>> markOrderAsReceived(String orderId) async {
    return ErrorHandler.execute(() => dataSource.markOrderAsReceived(orderId));
  }

  @override
  Future<Either<Failure, List<OrderReceivedEntity>>> getOrdersByUserId(String userId) async {
    return ErrorHandler.execute(() => dataSource.getOrdersByUserId(userId));
  }
}
