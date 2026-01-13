import 'package:flutter_bloc/flutter_bloc.dart';

class UserSearchCubit extends Cubit<String> {
  UserSearchCubit() : super('');

  void updateSearch(String query) {
    emit(query);
  }

  void clearSearch() {
    emit('');
  }
}