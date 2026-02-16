import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/product/product_selection_cubit_state.dart';

class ProductSelectionCubit extends Cubit<ProductSelectionState> {
  ProductSelectionCubit() : super(const ProductSelectionState());

  void initSelection(List<String> ids) {
    emit(state.copyWith(selectedIds: List.from(ids)));
  }

  void toggleProduct(String id) {
    final current = List<String>.from(state.selectedIds);
    if (current.contains(id)) {
      current.remove(id);
    } else {
      current.add(id);
    }
    emit(state.copyWith(selectedIds: current));
  }

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query.toLowerCase()));
  }
}
