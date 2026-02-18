import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/payment/payment_page_cubit_state.dart';

class PaymentPageCubit extends Cubit<PaymentPageState> {
  PaymentPageCubit() : super(const PaymentPageState());

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
