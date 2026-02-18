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
}
