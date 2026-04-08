import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/domain/entities/auth/login/login_user_entity.dart';
import 'package:rizqmartadmin/features/domain/repository/auth/login_repository.dart';

class LoginAccUseCases {
  final LoginRepository loginRepository;
  LoginAccUseCases(this.loginRepository);
  Future<Either<Failure, LoginUserEntity>> call(String email, String password) {
    return loginRepository.login(email, password);
  }
}