import 'package:rizqmartadmin/features/auth/domain/entities/auth/login/login_user_entity.dart';

abstract class LoginRepository {
  Future<LoginUserEntity>login(String email,String password);
}