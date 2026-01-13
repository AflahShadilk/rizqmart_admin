import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:rizqmartadmin/features/auth/data/data_sources/main/brand_firestore_source.dart';
import 'package:rizqmartadmin/features/auth/data/data_sources/main/category_firestore_source.dart';
import 'package:rizqmartadmin/features/auth/data/data_sources/main/order_received_datasource.dart';
import 'package:rizqmartadmin/features/auth/data/data_sources/main/payment_data_source.dart';
import 'package:rizqmartadmin/features/auth/data/data_sources/main/product_firestore_source.dart';
import 'package:rizqmartadmin/features/auth/data/data_sources/main/unit_firestore_source.dart';
import 'package:rizqmartadmin/features/auth/data/data_sources/main/user_data_source.dart';
import 'package:rizqmartadmin/features/auth/data/repository/forgot_pass_impliment/auth_repository_impl.dart';
import 'package:rizqmartadmin/features/auth/data/data_sources/auth/login_account/login_acc_datasource.dart';
import 'package:rizqmartadmin/features/auth/data/repository/login%20account/login_auth_repository_impl.dart';
import 'package:rizqmartadmin/features/auth/data/repository/main/brand_repository_impl.dart';
import 'package:rizqmartadmin/features/auth/data/repository/main/category_repository_impl.dart';
import 'package:rizqmartadmin/features/auth/data/repository/main/order_received_repository_impl.dart';
import 'package:rizqmartadmin/features/auth/data/repository/main/payment_repository_imple.dart';
import 'package:rizqmartadmin/features/auth/data/repository/main/product_repository_impl.dart';
import 'package:rizqmartadmin/features/auth/data/repository/main/units_repository_imple.dart';
import 'package:rizqmartadmin/features/auth/data/repository/main/user_repository_imple.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/order_received_repository.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/payment_repository.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/user_repository.dart';

final sl=GetIt.instance;

void register(){
  sl.registerLazySingleton<FirebaseAuth>(()=>FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(()=>FirebaseFirestore.instance);
  
  //datasources
  sl.registerLazySingleton<LoginAccDatasource>(()=>LoginAccDatasource(firebaseAuth: sl()));
  sl.registerLazySingleton<CategoryFirestoreSource>(()=>CategoryFirestoreSource());
  sl.registerLazySingleton<BrandFirestoreSource>(()=>BrandFirestoreSource());
  sl.registerLazySingleton<ProductFirestoreSource>(()=>ProductFirestoreSource());
  sl.registerLazySingleton<UnitFirestoreSource>(()=>UnitFirestoreSource());
  sl.registerLazySingleton<OrderReceivedDataSource>(()=>OrderReceivedDataSourceImpl(firestore: sl()),);
  sl.registerLazySingleton<PaymentDataSource>(()=>PaymentDataSourceImpl(firestore: sl()));
  sl.registerLazySingleton<UserDataSource>(()=>UserDataSourceImpl(firestore: sl()));

  //repository
  sl.registerLazySingleton<LoginRepositoryImpl>(()=>LoginRepositoryImpl(loginAccDatasource: sl()));
  sl.registerLazySingleton<ForgotAuthRepositoryImpl>(()=>ForgotAuthRepositoryImpl(firebaseAuth: sl()));
  sl.registerLazySingleton<CategoryRepositoryImpl>(()=>CategoryRepositoryImpl(sl()));
  sl.registerLazySingleton<BrandRepositoryImpl>(()=>BrandRepositoryImpl(sl()));
  sl.registerLazySingleton<ProductRepositoryImpl>(()=>ProductRepositoryImpl(fireStore: sl()));
  sl.registerLazySingleton<UnitsRepositoryImple>(()=>UnitsRepositoryImple(unitFirestoreSource: sl()));
  sl.registerLazySingleton<OrderReceivedRepository>(()=>OrderReceivedRepositoryImpl(dataSource: sl()));
  sl.registerLazySingleton<PaymentRepository>(()=>PaymentRepositoryImpl(dataSource: sl()));
  sl.registerLazySingleton<UserRepository>(()=>UserRepositoryImpl(dataSource: sl()));
  

} 