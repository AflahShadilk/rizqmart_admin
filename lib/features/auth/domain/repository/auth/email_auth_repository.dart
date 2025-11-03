abstract class ForgotAuthRepository{
  Future<void>sendPasswordReset(String email);
}