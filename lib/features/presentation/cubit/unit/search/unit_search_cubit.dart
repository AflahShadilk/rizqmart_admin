import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/presentation/cubit/unit/search/unit_search_state.dart';

class UnitsSearchCubit extends Cubit<UnitSearchState> {
  UnitsSearchCubit() : super(const UnitSearchState());

  void updateSearch(String query) => emit(state.copyWith(searchQuery: query));

  void clearSearch() => emit(state.copyWith(searchQuery: ''));

  void toggleView(bool isGrid) => emit(state.copyWith(isGridView: isGrid));
}