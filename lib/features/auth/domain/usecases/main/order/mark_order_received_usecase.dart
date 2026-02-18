import 'package:rizqmartadmin/features/auth/domain/repository/main/order_received_repository.dart';

class MarkOrderReceivedUseCase {
  final OrderReceivedRepository repository;

  MarkOrderReceivedUseCase({required this.repository});

  Future<void> call(String orderId) async {
    return await repository.markOrderAsReceived(orderId);
  }
}