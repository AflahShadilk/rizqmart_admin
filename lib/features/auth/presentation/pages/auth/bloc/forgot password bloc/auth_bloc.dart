import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/auth/send_password_rest.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/auth/bloc/forgot%20password%20bloc/auth_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/auth/bloc/forgot%20password%20bloc/auth_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent,ForgotPasswordState>{
  final ForgotPasswordUseCase forgotPasswordUseCase;
  ForgotPasswordBloc({required this.forgotPasswordUseCase}):super(ForgotPasswordInitial()){
    on<ForgotPasswordSubmitted>((event, emit)async{
     emit(ForgotPasswordLoading());
     try{
      await forgotPasswordUseCase(event.email);
      emit(ForgotPasswordSuccess());
     }catch (e){
      emit(ForgotPasswordFailed(e.toString()));
     }
    });
  }

}