import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable{
  @override
  List<Object?>get props=>[];
} 

class LoginInitial extends LoginState{}

class LoginLoading extends LoginState{}

class LoginSuccess extends LoginState{
 final String message;
  LoginSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class LoginError extends LoginState{
 final String error;
 LoginError(this.error);
 @override
  List<Object?> get props => [error];
}

class LogoutSuccess extends LoginState {}

class AuthAuthenticated extends LoginState {
  final String email;
  AuthAuthenticated({required this.email});
  @override
  List<Object?> get props => [email];
}

class AuthUnauthenticated extends LoginState {}