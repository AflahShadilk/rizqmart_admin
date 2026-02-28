import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/order/order_page_cubit_state.dart';

class OrderPageCubit extends Cubit<OrderPageState> {
  OrderPageCubit() : super(const OrderPageState());

  void updateFilter(String filter) {
    emit(state.copyWith(selectedFilter: filter, currentPage: 1));
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

  /// Calculates total pages
  int getTotalPages(int dataLength, int itemsPerPage) {
    return (dataLength / itemsPerPage).ceil();
  }

  /// Calculates the safely bounded sublist for the current page
  List<T> getPaginatedList<T>(List<T> data, int itemsPerPage) {
    final totalPages = getTotalPages(data.length, itemsPerPage);
    
    // Auto-correct page bounds logically
    int validCurrentPage = state.currentPage;
    if (validCurrentPage > totalPages && totalPages > 0) {
      validCurrentPage = totalPages;
      // We don't emit here to avoid build collisions; we just use the forced valid page.
    }

    int startIndex = (validCurrentPage - 1) * itemsPerPage;
    if (startIndex >= data.length) startIndex = 0;
    
    int endIndex = (startIndex + itemsPerPage).clamp(0, data.length);
    return data.sublist(startIndex, endIndex);
  }
}

