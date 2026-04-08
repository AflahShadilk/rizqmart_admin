import 'package:flutter_bloc/flutter_bloc.dart';
import 'coupons_state.dart';

class CouponsCubit extends Cubit<CouponsState> {
  CouponsCubit() : super(CouponsState.initial());

  void toggleView(bool isGrid) {
    if (isGrid != state.isGridView) {
      emit(state.copyWith(isGridView: isGrid));
    }
  }

  void updateSearchQuery(String query) {
    if (query != state.searchQuery) {
      emit(state.copyWith(searchQuery: query));
    }
  }

  void clearSearch() {
    if (state.searchQuery.isNotEmpty) {
      emit(state.copyWith(searchQuery: ''));
    }
  }
}
