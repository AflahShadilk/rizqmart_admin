import 'package:rizqmartadmin/features/auth/domain/entities/auth/login/login_user_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/auth/login_repository.dart';

class GetCurrentUserUseCase {
  final LoginRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<LoginUserEntity?> call() {
    return repository.getCurrentUser();
  }
}
