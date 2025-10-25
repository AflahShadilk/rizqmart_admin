abstract class ForgotPasswordEvent{}

class ForgotPasswordSubmitted extends ForgotPasswordEvent{
  final String email;
  ForgotPasswordSubmitted(this.email);
}