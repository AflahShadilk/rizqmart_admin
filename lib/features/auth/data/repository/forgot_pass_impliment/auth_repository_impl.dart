import 'package:firebase_auth/firebase_auth.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/auth/email_auth_repository.dart';

class ForgotAuthRepositoryImpl implements ForgotAuthRepository{
  final FirebaseAuth firebaseAuth;
  ForgotAuthRepositoryImpl({required this.firebaseAuth});
  
  @override
  Future<void> sendPasswordReset(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Failed to send reset email');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }
}