import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/domain/usecases/auth/send_password_rest.dart';
import 'package:rizqmartadmin/features/presentation/bloc/auth/forgot/auth_event.dart';
import 'package:rizqmartadmin/features/presentation/bloc/auth/forgot/auth_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordUseCase forgotPasswordUseCase;
  ForgotPasswordBloc({required this.forgotPasswordUseCase}) : super(ForgotPasswordInitial()) {
    on<ForgotPasswordSubmitted>((event, emit) async {
      emit(ForgotPasswordLoading());
      final result = await forgotPasswordUseCase(event.email);
      result.fold(
        (failure) => emit(ForgotPasswordFailed(failure.message)),
        (_) => emit(ForgotPasswordSuccess()),
      );
    });
  }
}