import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/user_repository.dart';

class UpdateUserStatusUseCase {
  final UserRepository repository;

  UpdateUserStatusUseCase(this.repository);

  Future<Either<Failure, void>> call(String userId, bool isActive) async {
    return await repository.updateUserStatus(userId, isActive);
  }
}