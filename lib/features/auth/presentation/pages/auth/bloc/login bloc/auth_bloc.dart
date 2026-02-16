import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/auth/login_acc_use_cases.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/auth/logout_usecase.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/auth/bloc/login%20bloc/auth_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/auth/bloc/login%20bloc/auth_state.dart';

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
      try {
        final user = await getCurrentUserUseCase!.call();
        if (user != null) {
          emit(AuthAuthenticated(email: user.email));
        } else {
          emit(AuthUnauthenticated());
        }
      } catch (e) {
        emit(AuthUnauthenticated());
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginto(
    LoginTryEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final usercred = await loginAccUseCases.call(event.email, event.password);
      emit(AuthAuthenticated(email: usercred.email));
    } on FirebaseAuthException catch (e) {
      emit(LoginError(_getFirebaseErrorMessage(e)));
    } on Exception catch (e) {
      emit(LoginError(e.toString().replaceFirst('Exception: ', '')));
    } catch (e) {
      emit(LoginError('Something went wrong. Please try again.'));
    }
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      if (logoutUseCase != null) {
        await logoutUseCase!.call();
        emit(AuthUnauthenticated());
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(LoginError('Logout failed: $e'));
    }
  }

  String _getFirebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return e.message ?? 'Login failed. Please try again.';
    }
  }
}