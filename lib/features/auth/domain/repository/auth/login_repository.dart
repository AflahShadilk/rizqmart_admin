import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/auth/login/login_user_entity.dart';

abstract class LoginRepository {
  Future<Either<Failure, LoginUserEntity>> login(String email, String password);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, LoginUserEntity?>> getCurrentUser();
}