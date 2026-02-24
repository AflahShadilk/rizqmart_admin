import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/auth/login_repository.dart';

class LogoutUseCase {
  final LoginRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.logout();
  }
}
