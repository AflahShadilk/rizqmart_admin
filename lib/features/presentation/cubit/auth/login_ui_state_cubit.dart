import 'package:flutter_bloc/flutter_bloc.dart';

class LoginUIState {
  final bool isPasswordVisible;
  final bool rememberMe;

  const LoginUIState({
    required this.isPasswordVisible,
    required this.rememberMe,
  });

  LoginUIState copyWith({
    bool? isPasswordVisible,
    bool? rememberMe,
  }) {
    return LoginUIState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }
}

/// Cubit to manage UI states (password visibility and remember me) on the login screen
class LoginUIStateCubit extends Cubit<LoginUIState> {
  LoginUIStateCubit()
      : super(const LoginUIState(isPasswordVisible: false, rememberMe: false));

  /// Toggles the visibility of the password field
  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  /// Sets the state of the remember me checkbox
  void setRememberMe(bool value) {
    emit(state.copyWith(rememberMe: value));
  }
}
