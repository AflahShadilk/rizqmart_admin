import 'package:rizqmartadmin/features/auth/domain/repository/main/user_repository.dart';

class UpdateUserStatusUseCase {
  final UserRepository repository;

  UpdateUserStatusUseCase(this.repository);

  Future<void> call(String userId, bool isActive) async {
    return await repository.updateUserStatus(userId, isActive);
  }
}