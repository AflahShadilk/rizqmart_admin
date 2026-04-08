import 'package:flutter_bloc/flutter_bloc.dart';

import 'category_state.dart';

class CategoryLayoutCubit extends Cubit<CategoryLayoutState> {
  CategoryLayoutCubit() : super(const CategoryLayoutInitial(isGridView: true));

  void toggleViewMode(bool isGridView) {
    emit(CategoryLayoutUpdated(isGridView: isGridView));
  }
}
