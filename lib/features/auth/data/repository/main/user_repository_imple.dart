import 'package:rizqmartadmin/features/auth/data/data_sources/main/user_data_source.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/user_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource dataSource;

  UserRepositoryImpl({required this.dataSource});

  @override
  Future<List<UserEntity>> getAllUsers() async {
    final models = await dataSource.getAllUsers();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<UserEntity>> getUsersByRole(String role) async {
    final models = await dataSource.getUsersByRole(role);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<UserEntity> getUserById(String userId) async {
    final model = await dataSource.getUserById(userId);
    return model.toEntity();
  }

  @override
  Future<void> updateUserStatus(String userId, bool isActive) async {
    await dataSource.updateUserStatus(userId, isActive);
  }

  @override
  Future<void> deleteUser(String userId) async {
    await dataSource.deleteUser(userId);
  }
}