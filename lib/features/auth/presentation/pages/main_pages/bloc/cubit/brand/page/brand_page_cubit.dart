import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/brand/page/brand_page_cubit_state.dart';

class BrandPageCubit extends Cubit<BrandPageCubitState> {
  BrandPageCubit() : super(const BrandPageCubitState());

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void clearSearch() {
    emit(state.copyWith(searchQuery: ''));
  }

  void reset() {
    emit(const BrandPageCubitState());
  }
}