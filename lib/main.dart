import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rizqmartadmin/di/repository_providers_page.dart';
import 'package:rizqmartadmin/features/presentation/routes/app_routes.dart';
import 'package:rizqmartadmin/core/theme/app_theme.dart';
import 'package:rizqmartadmin/features/data/data_sources/services/web_messaging_service.dart';
import 'package:rizqmartadmin/features/data/repository/login_auth_repository_impl.dart';
import 'package:rizqmartadmin/firebase_options.dart';
import 'package:rizqmartadmin/features/presentation/widgets/common/responsive_wrapper_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:rizqmartadmin/features/domain/usecases/auth/login_acc_use_cases.dart';
import 'package:rizqmartadmin/features/domain/usecases/auth/logout_usecase.dart';
import 'package:rizqmartadmin/features/presentation/bloc/auth/login/auth_bloc.dart';
import 'package:rizqmartadmin/features/presentation/bloc/auth/login/auth_event.dart';
import 'package:rizqmartadmin/features/presentation/cubit/theme/theme_cubit.dart';
import 'package:rizqmartadmin/features/presentation/cubit/theme/theme_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/config.env");
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(
            loginAccUseCases: LoginAccUseCases(sl<LoginRepositoryImpl>()),
            logoutUseCase: LogoutUseCase(sl<LoginRepositoryImpl>()),
            getCurrentUserUseCase:
                GetCurrentUserUseCase(sl<LoginRepositoryImpl>()),
          )..add(CheckAuthStatusEvent()),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Rizq Mart',
            routerConfig: AppRoutes.router,
            builder: (context, child) => ResponsiveWrapperWidget(child: child!),
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.themeMode,
          );
        },
      ),
    );
  }
}
