import 'package:flutter_bloc/flutter_bloc.dart';
import 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(const OrderState());

  void updateFilter(String filter) {
    emit(state.copyWith(selectedFilter: filter, currentPage: 1));
  }

  void toggleView(bool isGrid) {
    if (isGrid != state.isGridView) {
      emit(state.copyWith(isGridView: isGrid));
    }
  }

  void setPage(int page) {
    emit(state.copyWith(currentPage: page));
  }

  void nextPage() {
    emit(state.copyWith(currentPage: state.currentPage + 1));
  }

  void previousPage() {
    if (state.currentPage > 1) {
      emit(state.copyWith(currentPage: state.currentPage - 1));
    }
  }

  int getTotalPages(int dataLength) {
    return (dataLength / state.itemsPerPage).ceil();
  }

  List<T> getPaginatedList<T>(List<T> data) {
    final totalPages = getTotalPages(data.length);

    int validCurrentPage = state.currentPage;
    if (validCurrentPage > totalPages && totalPages > 0) {
      validCurrentPage = totalPages;
    }

    int startIndex = (validCurrentPage - 1) * state.itemsPerPage;
    if (startIndex >= data.length) startIndex = 0;

    int endIndex = (startIndex + state.itemsPerPage).clamp(0, data.length);
    return data.sublist(startIndex, endIndex);
  }
}
