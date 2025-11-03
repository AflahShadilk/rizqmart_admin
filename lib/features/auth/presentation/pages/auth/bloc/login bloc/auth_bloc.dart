import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/auth/login_acc_use_cases.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/auth/bloc/login%20bloc/auth_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/auth/bloc/login%20bloc/auth_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginAccUseCases loginAccUseCases;

  LoginBloc({required this.loginAccUseCases}) : super(LoginInitial()) {
    on<LoginTryEvent>(_onLoginto);
  }

  Future<void> _onLoginto(
    LoginTryEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final usercred = await loginAccUseCases.call(event.email, event.password);
      emit(LoginSuccess('Login successful! Welcome ${usercred.email}'));
    } on FirebaseAuthException catch (e) {
      emit(LoginError(_getFirebaseErrorMessage(e)));
    } on Exception catch (e) {
      emit(LoginError(e.toString().replaceFirst('Exception: ', '')));
    } catch (e) {
      emit(LoginError('Something went wrong. Please try again.'));
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