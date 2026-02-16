import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/coupon/coupons_page_cubit_state.dart';

class CouponsPageCubit extends Cubit<CouponsPageState> {
  CouponsPageCubit() : super(const CouponsPageState());

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void clearSearch() {
    emit(state.copyWith(searchQuery: ''));
  }
}
