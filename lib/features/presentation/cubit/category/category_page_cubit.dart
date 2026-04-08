import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/presentation/cubit/category/category_page_state_cubit.dart';

class CategoryPageCubit extends Cubit<CategoryPageState> {
  CategoryPageCubit() : super(const CategoryPageState());

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void clearSearch() {
    emit(state.copyWith(searchQuery: ''));
  }

  void reset() {
    emit(const CategoryPageState());
  }
}