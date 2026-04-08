import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:rizqmartadmin/features/data/data_sources/main/brand_firestore_source.dart';
import 'package:rizqmartadmin/features/data/data_sources/main/category_firestore_source.dart';
import 'package:rizqmartadmin/features/data/data_sources/main/order_received_datasource.dart';
import 'package:rizqmartadmin/features/data/data_sources/main/payment_data_source.dart';
import 'package:rizqmartadmin/features/data/data_sources/main/product_firestore_source.dart';
import 'package:rizqmartadmin/features/data/data_sources/main/unit_firestore_source.dart';
import 'package:rizqmartadmin/features/data/data_sources/main/sales_report_datasource.dart';
import 'package:rizqmartadmin/features/data/data_sources/main/dashboard_datasource.dart';
import 'package:rizqmartadmin/features/data/data_sources/main/user_data_source.dart';
import 'package:rizqmartadmin/features/data/repository/auth_repository_impl.dart';
import 'package:rizqmartadmin/features/data/data_sources/auth/login_account/login_acc_datasource.dart';
import 'package:rizqmartadmin/features/data/repository/login_auth_repository_impl.dart';
import 'package:rizqmartadmin/features/data/repository/brand_repository_impl.dart';
import 'package:rizqmartadmin/features/data/repository/category_repository_impl.dart';
import 'package:rizqmartadmin/features/data/repository/order_received_repository_impl.dart';
import 'package:rizqmartadmin/features/data/repository/payment_repository_imple.dart';
import 'package:rizqmartadmin/features/data/repository/product_repository_impl.dart';
import 'package:rizqmartadmin/features/data/repository/units_repository_imple.dart';
import 'package:rizqmartadmin/features/data/repository/sales_report_repository_impl.dart';
import 'package:rizqmartadmin/features/data/repository/user_repository_imple.dart';
import 'package:rizqmartadmin/features/data/repository/dashboard_repository_impl.dart';
import 'package:rizqmartadmin/features/domain/repository/main/sales_report_repository.dart';
import 'package:rizqmartadmin/features/domain/repository/main/order_received_repository.dart';
import 'package:rizqmartadmin/features/domain/repository/main/payment_repository.dart';
import 'package:rizqmartadmin/features/domain/repository/main/user_repository.dart';
import 'package:rizqmartadmin/features/domain/repository/main/dashboard_repository.dart';
import 'package:rizqmartadmin/features/data/data_sources/main/coupon_firestore_source.dart';
import 'package:rizqmartadmin/features/data/repository/coupon_repository_impl.dart';
import 'package:rizqmartadmin/features/data/data_sources/main/chat_datasource.dart';
import 'package:rizqmartadmin/features/data/repository/chat_repository_impl.dart';

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
  sl.registerLazySingleton<SalesReportDataSource>(()=>SalesReportDataSourceImpl(firestore: sl()));
  sl.registerLazySingleton<DashboardDataSource>(()=>DashboardDataSourceImpl(firestore: sl()));
  sl.registerLazySingleton<CouponFirestoreSource>(()=>CouponFirestoreSource());

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
  sl.registerLazySingleton<SalesReportRepository>(()=>SalesReportRepositoryImpl(dataSource: sl()));


  sl.registerLazySingleton<DashboardRepository>(()=>DashboardRepositoryImpl(dataSource: sl()));
  sl.registerLazySingleton<CouponRepositoryImpl>(()=>CouponRepositoryImpl(sl()));
  sl.registerLazySingleton<ChatRepositoryImpl>(()=>ChatRepositoryImpl(sl()));
  sl.registerLazySingleton<ChatDataSource>(()=>ChatDataSourceImpl());

} 