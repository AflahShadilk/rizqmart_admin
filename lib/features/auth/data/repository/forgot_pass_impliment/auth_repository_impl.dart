import 'package:firebase_auth/firebase_auth.dart';
import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/error_handler.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/auth/email_auth_repository.dart';

class ForgotAuthRepositoryImpl implements ForgotAuthRepository {
  final FirebaseAuth firebaseAuth;
  ForgotAuthRepositoryImpl({required this.firebaseAuth});

  @override
  Future<Either<Failure, void>> sendPasswordReset(String email) async {
    return ErrorHandler.execute(() => firebaseAuth.sendPasswordResetEmail(email: email));
  }
}