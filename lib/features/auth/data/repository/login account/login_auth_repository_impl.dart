import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/error_handler.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/auth/data/data_sources/auth/login_account/login_acc_datasource.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/auth/login/login_user_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/auth/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginAccDatasource loginAccDatasource;

  LoginRepositoryImpl({required this.loginAccDatasource});

  @override
  Future<Either<Failure, LoginUserEntity>> login(String email, String password) async {
    return ErrorHandler.execute(() => loginAccDatasource.login(email, password));
  }

  @override
  Future<Either<Failure, void>> logout() async {
    return ErrorHandler.execute(() => loginAccDatasource.logout());
  }

  @override
  Future<Either<Failure, LoginUserEntity?>> getCurrentUser() async {
    return ErrorHandler.execute(() => loginAccDatasource.getCurrentUser());
  }
}