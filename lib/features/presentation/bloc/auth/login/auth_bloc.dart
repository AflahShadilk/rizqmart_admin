import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:rizqmartadmin/features/domain/usecases/auth/login_acc_use_cases.dart';
import 'package:rizqmartadmin/features/domain/usecases/auth/logout_usecase.dart';
import 'package:rizqmartadmin/features/presentation/bloc/auth/login/auth_event.dart';
import 'package:rizqmartadmin/features/presentation/bloc/auth/login/auth_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginAccUseCases loginAccUseCases;
  final LogoutUseCase? logoutUseCase;
  final GetCurrentUserUseCase? getCurrentUserUseCase;

  LoginBloc({
    required this.loginAccUseCases,
    this.logoutUseCase,
    this.getCurrentUserUseCase,
  }) : super(LoginInitial()) {
    on<LoginTryEvent>(_onLoginto);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<LoginState> emit,
  ) async {
    if (getCurrentUserUseCase != null) {
      final result = await getCurrentUserUseCase!.call();
      result.fold(
        (failure) => emit(AuthUnauthenticated()),
        (user) {
          if (user != null) {
            emit(AuthAuthenticated(email: user.email));
          } else {
            emit(AuthUnauthenticated());
          }
        },
      );
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginto(
    LoginTryEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    final result = await loginAccUseCases.call(event.email, event.password);
    result.fold(
      (failure) => emit(LoginError(failure.message)),
      (usercred) => emit(AuthAuthenticated(email: usercred.email)),
    );
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    if (logoutUseCase != null) {
      final result = await logoutUseCase!.call();
      result.fold(
        (failure) => emit(LoginError(failure.message)),
        (_) => emit(AuthUnauthenticated()),
      );
    } else {
      emit(AuthUnauthenticated());
    }
  }
}