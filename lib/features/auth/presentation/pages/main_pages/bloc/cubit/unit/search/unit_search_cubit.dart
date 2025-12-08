import 'package:flutter_bloc/flutter_bloc.dart';

class UnitsSearchCubit extends Cubit<String> {
  UnitsSearchCubit() : super('');

  void updateSearch(String query) => emit(query);

  void clearSearch() => emit('');
}