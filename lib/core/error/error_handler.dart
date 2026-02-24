import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';

class ErrorHandler {
  static Future<Either<Failure, T>> execute<T>(Future<T> Function() action) async {
    try {
      final result = await action();
      return Right(result);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(_getFirebaseErrorMessage(e)));
    } on SocketException {
      return Left(NetworkFailure('No Internet connection. Please check your network.'));
    } on TimeoutException {
      return Left(NetworkFailure('Connection timed out. Please try again later.'));
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  static String _getFirebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return e.message ?? 'An unexpected authentication error occurred.';
    }
  }
}
