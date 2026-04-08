import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/domain/repository/main/order_received_repository.dart';

class MarkOrderReceivedUseCase {
  final OrderReceivedRepository repository;

  MarkOrderReceivedUseCase({required this.repository});

  Future<Either<Failure, void>> call(String orderId) async {
    return await repository.markOrderAsReceived(orderId);
  }
}