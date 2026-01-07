import 'package:rizqmartadmin/features/auth/data/data_sources/main/order_received_datasource.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/order_recieved_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/order_received_repository.dart';

class OrderReceivedRepositoryImpl implements OrderReceivedRepository {
  final OrderReceivedDataSource dataSource;

  OrderReceivedRepositoryImpl({required this.dataSource});

  @override
  Future<List<OrderReceivedEntity>> getNewOrders() async {
    final models = await dataSource.getNewOrders();
    return models;
  }

  @override
  Future<List<OrderReceivedEntity>> getOrdersByStatus(String status) async {
    final models = await dataSource.getOrdersByStatus(status);
    return models;
  }

  @override
  Future<OrderReceivedEntity> getOrderById(String orderId) async {
    final model = await dataSource.getOrderById(orderId);
    return model;
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) async {
    await dataSource.updateOrderStatus(orderId, status);
  }

  @override
  Future<void> markOrderAsReceived(String orderId) async {
    await dataSource.markOrderAsReceived(orderId);
  }
}
