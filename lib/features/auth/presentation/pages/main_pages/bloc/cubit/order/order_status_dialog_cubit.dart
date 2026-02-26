import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit to manage the state of the order status dropdown dialog
class OrderStatusDialogCubit extends Cubit<String> {
  OrderStatusDialogCubit(super.initialStatus);

  /// Updates the selected status when the user changes the dropdown value
  void updateStatus(String newStatus) {
    emit(newStatus);
  }
}
