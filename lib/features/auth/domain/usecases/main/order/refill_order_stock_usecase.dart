import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/error_handler.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/order_recieved_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/product_repository.dart';

class RefillOrderStockUseCase {
  final ProductRepository repository;

  RefillOrderStockUseCase({required this.repository});

  Future<Either<Failure, void>> call(OrderReceivedEntity order) async {
    return ErrorHandler.execute(() async {
      for (var item in order.items) {
        if (item.productId.isNotEmpty && item.quantity > 0) {
          final result = await repository.updateProductStock(
            item.productId,
            item.variantId,
            item.quantity,
          );
          if (result.isLeft) {
            return;
          }
        }
      }
    });
  }
}
