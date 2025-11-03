import 'package:rizqmartadmin/features/auth/domain/repository/auth/email_auth_repository.dart';

class ForgotPasswordUseCase{
  final ForgotAuthRepository repository;
  ForgotPasswordUseCase(this.repository);
  Future<void>call(String email)async{
    return await repository.sendPasswordReset(email);
  }
}