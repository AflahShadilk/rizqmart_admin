import 'package:flutter_bloc/flutter_bloc.dart';
import 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentCubitState> {
  PaymentCubit() : super(PaymentCubitState.initial());

  void setPage(int page) {
    if (page > 0 && page != state.currentPage) {
      emit(state.copyWith(currentPage: page));
    }
  }

  void nextPage() {
    emit(state.copyWith(currentPage: state.currentPage + 1));
  }

  void previousPage() {
    if (state.currentPage > 1) {
      emit(state.copyWith(currentPage: state.currentPage - 1));
    }
  }

  void updateFilter(String filter) {
    if (filter != state.selectedFilter) {
      emit(state.copyWith(selectedFilter: filter, currentPage: 1)); // Reset page on filter
    }
  }

  void toggleGridView(bool isGrid) {
    if (isGrid != state.isGridView) {
      emit(state.copyWith(isGridView: isGrid));
    }
  }
}
