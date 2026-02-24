import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, List<UserEntity>>> getAllUsers();
  Future<Either<Failure, List<UserEntity>>> getUsersByRole(String role);
  Future<Either<Failure, UserEntity>> getUserById(String userId);
  Future<Either<Failure, void>> updateUserStatus(String userId, bool isActive);
  Future<Either<Failure, void>> deleteUser(String userId);
}