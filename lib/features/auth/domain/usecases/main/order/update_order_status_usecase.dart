import 'package:rizqmartadmin/features/auth/domain/repository/main/order_received_repository.dart';

class UpdateOrderStatusUseCase {
  final OrderReceivedRepository repository;

  UpdateOrderStatusUseCase({required this.repository});

  Future<void> call(String orderId, String status) async {
    return await repository.updateOrderStatus(orderId, status);
  }
}
