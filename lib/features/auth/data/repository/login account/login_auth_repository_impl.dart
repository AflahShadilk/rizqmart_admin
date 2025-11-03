import 'package:firebase_auth/firebase_auth.dart';
import 'package:rizqmartadmin/features/auth/data/data_sources/auth/login_account/login_acc_datasource.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/auth/login/login_user_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/auth/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginAccDatasource loginAccDatasource;

  LoginRepositoryImpl({required this.loginAccDatasource});

  @override
  Future<LoginUserEntity> login(String email, String password) async {
    try {
      return await loginAccDatasource.login(email, password);
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      // Handle any other errors
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  Exception _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('No user found with this email.');
      case 'wrong-password':
        return Exception('Wrong password provided.');
      case 'invalid-email':
        return Exception('The email address is badly formatted.');
      case 'user-disabled':
        return Exception('This user account has been disabled.');
      case 'too-many-requests':
        return Exception('Too many attempts. Please try again later.');
      case 'invalid-credential':
        return Exception('Invalid email or password.');
      default:
        return Exception(e.message ?? 'Authentication failed.');
    }
  }
}