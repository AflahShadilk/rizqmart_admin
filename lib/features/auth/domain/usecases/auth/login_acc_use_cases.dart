import 'package:rizqmartadmin/features/auth/domain/entities/auth/login/login_user_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/auth/login_repository.dart';

class LoginAccUseCases {
  final LoginRepository loginRepository;
  LoginAccUseCases(this.loginRepository);
  Future<LoginUserEntity>call(String email,String password){
    return loginRepository.login(email, password);
  }
}