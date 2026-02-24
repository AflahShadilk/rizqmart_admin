import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';

abstract class ForgotAuthRepository {
  Future<Either<Failure, void>> sendPasswordReset(String email);
}