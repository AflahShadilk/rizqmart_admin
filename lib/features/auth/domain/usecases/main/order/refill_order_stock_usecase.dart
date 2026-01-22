import 'package:rizqmartadmin/features/auth/domain/entities/main/order_recieved_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/product_repository.dart';

class RefillOrderStockUseCase {
  final ProductRepository repository;

  RefillOrderStockUseCase({required this.repository});

  Future<void> call(OrderReceivedEntity order) async {
    for (var item in order.items) {
      if (item.productId.isNotEmpty && item.quantity > 0) {
        try {
          // Add quantity back to stock (positive quantityChange)
          await repository.updateProductStock(
            item.productId, 
            item.variantId, 
            item.quantity
          );
        } catch (e) {
          // Log error but continue with other items? 
          // Ideally we might want some transaction consistency but for now we try best effort.
          print('Failed to refill stock for product ${item.productId}: $e');
        }
      }
    }
  }
}
