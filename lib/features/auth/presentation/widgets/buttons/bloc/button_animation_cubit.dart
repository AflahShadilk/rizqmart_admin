import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit to manage the pressed animation state of buttons
class ButtonAnimationCubit extends Cubit<bool> {
  ButtonAnimationCubit() : super(false);

  /// Sets the button state to pressed (true) or released (false)
  void setPressed(bool isPressed) {
    emit(isPressed);
  }
}
