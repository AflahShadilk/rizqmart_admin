import 'package:rizqmartadmin/features/auth/domain/entities/main/user_entity.dart';

abstract class UserRepository {
  Future<List<UserEntity>> getAllUsers();
  Future<List<UserEntity>> getUsersByRole(String role);
  Future<UserEntity> getUserById(String userId);
  Future<void> updateUserStatus(String userId, bool isActive);
  Future<void> deleteUser(String userId);
}