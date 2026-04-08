import 'package:flutter_bloc/flutter_bloc.dart';

class FocusCubit extends Cubit<bool> {
  FocusCubit() : super(false);

  void onFocusChanged(bool isFocused) {
    emit(isFocused);
  }
}
