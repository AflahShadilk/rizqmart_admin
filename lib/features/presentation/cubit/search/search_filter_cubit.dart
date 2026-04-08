import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/presentation/cubit/search/search_filter_cubit_state.dart';

class SearchFilterCubit extends Cubit<SearchFilterState> {
  SearchFilterCubit() : super(const SearchFilterState());

  void setCategory(String? category) {
    emit(state.copyWith(selectedCategory: category, clearCategory: category == null));
  }

  void setBrand(String? brand) {
    emit(state.copyWith(selectedBrand: brand, clearBrand: brand == null));
  }

  void clearAll() {
    emit(const SearchFilterState());
  }
}
