abstract class ForgotPasswordState{}

class ForgotPasswordInitial extends ForgotPasswordState{}
class ForgotPasswordLoading extends ForgotPasswordState{}
class ForgotPasswordSuccess extends ForgotPasswordState{}
class ForgotPasswordFailed  extends ForgotPasswordState{
  final String error;
  ForgotPasswordFailed(this.error);
}