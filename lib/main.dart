import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rizqmartadmin/core/services/repository_providers_page.dart';
import 'package:rizqmartadmin/core/services/routes/app_routes.dart';
import 'package:rizqmartadmin/core/services/web_messaging_service.dart';
import 'package:rizqmartadmin/firebase_options.dart';
import 'package:rizqmartadmin/widgets/responsive_wrapper_widget.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/auth/login_acc_use_cases.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/auth/logout_usecase.dart';
import 'package:rizqmartadmin/features/auth/data/repository/login%20account/login_auth_repository_impl.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/auth/bloc/login%20bloc/auth_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/auth/bloc/login%20bloc/auth_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
     WebMessagingService.initialize();
  register();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(
        loginAccUseCases: LoginAccUseCases(sl<LoginRepositoryImpl>()),
        logoutUseCase: LogoutUseCase(sl<LoginRepositoryImpl>()),
        getCurrentUserUseCase: GetCurrentUserUseCase(sl<LoginRepositoryImpl>()),
      )..add(CheckAuthStatusEvent()),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Rizq Mart',
        routerConfig: AppRoutes.router,
        builder: (context, child) => ResponsiveWrapperWidget(child: child!),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      ),
    );
  }
}
