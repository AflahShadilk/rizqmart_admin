
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/auth/login/login_user_entity.dart';

class LoginAccDatasource {
  final FirebaseAuth firebaseAuth;
  LoginAccDatasource({required this.firebaseAuth});
  Future<LoginUserEntity>login(String email,String password)async{
    final result=await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    final user=result.user!;
    return LoginUserEntity(uid: user.uid, email: user.email??'');
  }
}