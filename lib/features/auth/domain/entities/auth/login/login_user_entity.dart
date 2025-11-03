import 'package:equatable/equatable.dart';

class LoginUserEntity extends Equatable{
  final String uid;
  final String email;
 const LoginUserEntity({required this.uid,required this.email});
  @override

  List<Object?> get props=>[uid,email];
}