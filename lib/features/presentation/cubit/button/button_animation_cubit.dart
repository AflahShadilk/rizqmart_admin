import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit to manage
class ButtonAnimationCubit extends Cubit<bool> {
  ButtonAnimationCubit() : super(false);

  /// Sets the button state to pressed 
  void setPressed(bool isPressed) {
    emit(isPressed);
  }
}
