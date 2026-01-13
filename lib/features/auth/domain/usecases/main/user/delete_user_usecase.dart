import 'package:rizqmartadmin/features/auth/domain/repository/main/user_repository.dart';

class DeleteUserUseCase {
  final UserRepository repository;

  DeleteUserUseCase(this.repository);

  Future<void> call(String userId) async {
    return await repository.deleteUser(userId);
  }
}