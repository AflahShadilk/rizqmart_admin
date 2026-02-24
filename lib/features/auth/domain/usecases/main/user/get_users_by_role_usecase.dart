import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/user_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/user_repository.dart';

class GetUsersByRoleUseCase {
  final UserRepository repository;

  GetUsersByRoleUseCase(this.repository);

  Future<Either<Failure, List<UserEntity>>> call(String role) async {
    return await repository.getUsersByRole(role);
  }
}