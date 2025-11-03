import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:rizqmartadmin/features/auth/data/data_sources/main/brand_firestore_source.dart';
import 'package:rizqmartadmin/features/auth/data/data_sources/main/category_firestore_source.dart';
import 'package:rizqmartadmin/features/auth/data/data_sources/main/product_firestore_source.dart';
import 'package:rizqmartadmin/features/auth/data/repository/forgot_pass_impliment/auth_repository_impl.dart';
import 'package:rizqmartadmin/features/auth/data/data_sources/auth/login_account/login_acc_datasource.dart';
import 'package:rizqmartadmin/features/auth/data/repository/login%20account/login_auth_repository_impl.dart';
import 'package:rizqmartadmin/features/auth/data/repository/main/brand_repository_impl.dart';
import 'package:rizqmartadmin/features/auth/data/repository/main/category_repository_impl.dart';
import 'package:rizqmartadmin/features/auth/data/repository/main/product_repository_impl.dart';


// class RepositoryProvidersPage extends StatelessWidget {
//   const RepositoryProvidersPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiRepositoryProvider(
//         providers: [
//           //create account repository injected
//           RepositoryProvider<CreateAuthRepositoryImpl>(
//               create: (_) => CreateAuthRepositoryImpl(
//                   createAuthRemoteDatasource: CreateAuthRemoteDatasourceImpl(
//                       firebaseAuth: FirebaseAuth.instance,
//                       fireStore: FirebaseFirestore.instance))),

//           RepositoryProvider<ForgotAuthRepository>(
//               create: (_) => ForgotAuthRepositoryImpl(
//                   firebaseAuth: FirebaseAuth.instance)),

//           RepositoryProvider<LoginRepository>(
//               create: (_) => LoginAuthRepositoryImpl(
//                   loginAccDatasource:
//                       LoginAccDatasource(firebaseAuth: FirebaseAuth.instance)))
//         ],
//         //providers bloc
//         child: MultiBlocProvider(providers: [
//           BlocProvider<AuthBloc>(
//               create: (context) => AuthBloc(
//                   createAccountUsecases: CreateAccountUsecases(
//                       context.read<CreateAuthRepositoryImpl>()))),

//           BlocProvider<ForgotPasswordBloc>(
//               create: (context) => ForgotPasswordBloc(
//                   forgotPasswordUseCase: ForgotPasswordUseCase(
//                       context.read<ForgotAuthRepository>()))),

//           BlocProvider<LoginBloc>(
//               create: (context) => LoginBloc(
//                   loginAccUseCases:
//                       LoginAccUseCases(context.read<LoginRepository>())))
//         ], child: const MyApp()));
//   }
// }
final sl=GetIt.instance;

void register(){
  sl.registerLazySingleton<FirebaseAuth>(()=>FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(()=>FirebaseFirestore.instance);
  
  //datasources
  // sl.registerLazySingleton<CreateAuthRemoteDatasourceImpl>(()=>CreateAuthRemoteDatasourceImpl(firebaseAuth: sl(), fireStore: sl()));
  sl.registerLazySingleton<LoginAccDatasource>(()=>LoginAccDatasource(firebaseAuth: sl()));
  sl.registerLazySingleton<CategoryFirestoreSource>(()=>CategoryFirestoreSource());
  sl.registerLazySingleton<BrandFirestoreSource>(()=>BrandFirestoreSource());
  sl.registerLazySingleton<ProductFirestoreSource>(()=>ProductFirestoreSource());
  //repository
  // sl.registerLazySingleton<CreateAuthRepositoryImpl>(()=>CreateAuthRepositoryImpl(createAuthRemoteDatasource: sl()));
  sl.registerLazySingleton<LoginRepositoryImpl>(()=>LoginRepositoryImpl(loginAccDatasource: sl()));
  sl.registerLazySingleton<ForgotAuthRepositoryImpl>(()=>ForgotAuthRepositoryImpl(firebaseAuth: sl()));
  sl.registerLazySingleton<CategoryRepositoryImpl>(()=>CategoryRepositoryImpl(sl()));
  sl.registerLazySingleton<BrandRepositoryImpl>(()=>BrandRepositoryImpl(sl()));
  sl.registerLazySingleton<ProductRepositoryImpl>(()=>ProductRepositoryImpl(fireStore: sl()));
} 