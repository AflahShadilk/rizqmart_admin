import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/features/data/error_handler.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/data/data_sources/main/user_data_source.dart';
import 'package:rizqmartadmin/features/domain/entities/main/user_entity.dart';
import 'package:rizqmartadmin/features/domain/repository/main/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource dataSource;

  UserRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<UserEntity>>> getAllUsers() async {
    return ErrorHandler.execute(() async {
      final models = await dataSource.getAllUsers();
      return models.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getUsersByRole(String role) async {
    return ErrorHandler.execute(() async {
      final models = await dataSource.getUsersByRole(role);
      return models.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, UserEntity>> getUserById(String userId) async {
    return ErrorHandler.execute(() async {
      final model = await dataSource.getUserById(userId);
      return model.toEntity();
    });
  }

  @override
  Future<Either<Failure, void>> updateUserStatus(String userId, bool isActive) async {
    return ErrorHandler.execute(() => dataSource.updateUserStatus(userId, isActive));
  }

  @override
  Future<Either<Failure, void>> deleteUser(String userId) async {
    return ErrorHandler.execute(() => dataSource.deleteUser(userId));
  }
}