import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/auth/email_auth_repository.dart';

class ForgotPasswordUseCase {
  final ForgotAuthRepository repository;
  ForgotPasswordUseCase(this.repository);
  Future<Either<Failure, void>> call(String email) async {
    return await repository.sendPasswordReset(email);
  }
}