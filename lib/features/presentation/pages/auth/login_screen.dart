// ignore_for_file: use_build_context_synchronously, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rizqmartadmin/core/theme/appcolor.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:rizqmartadmin/features/presentation/validators/email_field_validator.dart';
import 'package:rizqmartadmin/features/presentation/validators/password_field_validator.dart';
import 'package:rizqmartadmin/features/presentation/bloc/auth/login/auth_bloc.dart';
import 'package:rizqmartadmin/features/presentation/bloc/auth/login/auth_event.dart';
import 'package:rizqmartadmin/features/presentation/bloc/auth/login/auth_state.dart';
import 'package:rizqmartadmin/features/presentation/cubit/auth/login_ui_state_cubit.dart';
import 'package:rizqmartadmin/features/presentation/widgets/page_decoration/respnsive_page.dart';
import 'package:rizqmartadmin/features/presentation/widgets/form_fields/textformfield.dart';
import 'package:rizqmartadmin/features/presentation/pages/auth/widgets/auth_submit_button.dart';
import 'package:rizqmartadmin/features/presentation/pages/auth/widgets/login_side_panel.dart';

/// The primary authenticating point of RizqMart Admin Panel
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ---------------- Controllers ----------------
  final GlobalKey<FormState> _loginPageFormKey = GlobalKey<FormState>();
  final _emailKey = TextEditingController();
  final _passwordKey = TextEditingController();

  Future<void> _loadSavedEmail(LoginUIStateCubit cubit) async {
    final pref = await SharedPreferences.getInstance();
    final savedEmail = pref.getString('saved_email');
    if (savedEmail != null && savedEmail.isNotEmpty) {
      _emailKey.text = savedEmail;
      cubit.setRememberMe(true);
    }
  }

  // ---------------- Dispose ----------------
  @override
  void dispose() {
    _emailKey.dispose();
    _passwordKey.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMobile = Responsive.isMobile(context);
    
    final double fontSize;
    final EdgeInsets padding;
    if (Responsive.isDesktop(context)) {
      fontSize = 28;
      padding = const EdgeInsets.symmetric(horizontal: 120, vertical: 40);
    } else if (Responsive.isTablet(context)) {
      fontSize = 22;
      padding = const EdgeInsets.symmetric(horizontal: 48, vertical: 24);
    } else {
      fontSize = 18;
      padding = const EdgeInsets.all(16);
    }

    return BlocProvider(
      create: (context) {
        final cubit = LoginUIStateCubit();
        _loadSavedEmail(cubit);
        return cubit;
      },
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) async {
          if (state is AuthAuthenticated) {
            final pref = await SharedPreferences.getInstance();
            final rememberMe = context.read<LoginUIStateCubit>().state.rememberMe;
            if (rememberMe) {
              await pref.setString('saved_email', _emailKey.text.trim());
            } else {
              await pref.remove('saved_email');
            }
            await pref.setBool('isLoggedIn', true);

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Welcome back, ${state.email}!'),
                backgroundColor: AppColors.emerald,
                duration: const Duration(seconds: 2),
              ));
              context.go('/dashBoard');
            }
          } else if (state is LoginError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.error),
              backgroundColor: AppColors.chartRed,
              duration: const Duration(seconds: 3),
            ));
          }
        },
        builder: (context, state) {
          final isLoading = state is LoginLoading;
          
          return BlocBuilder<LoginUIStateCubit, LoginUIState>(
            builder: (context, uiState) {
              return Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                  ),
                  padding: padding,
                  width: double.infinity,
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 900),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: theme.cardTheme.color,
                        boxShadow: [
                          BoxShadow(
                            color: theme.shadowColor.withOpacity(0.2),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // ---------------- Login Page Header (Side Panel) ----------------
                          if (!isMobile)
                            const Expanded(
                              flex: 4,
                              child: LoginSidePanel(),
                            ),
                            
                          // ---------------- Login Form Container ----------------
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: const EdgeInsets.all(40),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Login to your account",
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.w700,
                                      color: theme.textTheme.titleLarge?.color,
                                    ),
                                  ),
                                  24.h,
                                  
                                  // ---------------- Login Form ----------------
                                  Form(
                                    key: _loginPageFormKey,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        // ---------------- Demo Credentials Box ----------------
                                        _buildDemoCredentialsBox(context),
                                        16.h,

                                        // ---------------- Email Field ----------------
                                        TextFormFLogin(
                                          controller: _emailKey,
                                          keyboardType: TextInputType.emailAddress,
                                          hint: 'Enter your email',
                                          iconn: AntDesign.mail_fill,
                                          iconnColor: colorScheme.primary,
                                          validator: emailValidator,
                                        ),
                                        20.h,
                                        
                                        // ---------------- Password Field ----------------
                                        TextFormFLogin(
                                          controller: _passwordKey,
                                          obscureText: !uiState.isPasswordVisible,
                                          hint: 'Enter your password',
                                          iconn: AntDesign.lock_fill,
                                          iconnColor: colorScheme.onSurface.withOpacity(0.6),
                                          validator: passwordValidator,
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              uiState.isPasswordVisible
                                                  ? Icons.visibility_outlined
                                                  : Icons.visibility_off_outlined,
                                              color: theme.textTheme.bodySmall?.color,
                                            ),
                                            onPressed: () {
                                              context.read<LoginUIStateCubit>().togglePasswordVisibility();
                                            },
                                          ),
                                        ),
                                        12.h,
                                        
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Checkbox(
                                                    value: uiState.rememberMe,
                                                    activeColor: colorScheme.primary,
                                                    onChanged: (value) {
                                                      context.read<LoginUIStateCubit>().setRememberMe(value ?? false);
                                                    },
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      "Remember Me",
                                                      style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        fontSize: 13,
                                                        color: theme.textTheme.bodyMedium?.color,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            
                                            // ---------------- Forgot Password Link ----------------
                                            Flexible(
                                              child: TextButton(
                                                onPressed: () {
                                                  context.push('/forgotPasswordPage');
                                                },
                                                child: Text(
                                                  "Forgot Password?",
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: 13,
                                                    color: colorScheme.primary,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        16.h,
                                        
                                        // ---------------- Login Button ----------------
                                        AuthSubmitButton(
                                          isLoading: isLoading,
                                          text: 'Login',
                                          onPressed: () {
                                            if (_loginPageFormKey.currentState!.validate()) {
                                              context.read<LoginBloc>().add(
                                                LoginTryEvent(
                                                  email: _emailKey.text.trim(),
                                                    password: _passwordKey.text.trim(),
                                                  ),
                                                );
                                            }
                                          },
                                        ),
                                        16.h,
                                        Text(
                                          "App Version: 2026-03-14 v1.2",
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 10,
                                            color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDemoCredentialsBox(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                "Demo Credentials (Click to Autofill & Copy)",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildCredentialRow(
            context: context,
            label: "Email",
            value: "shadilpml@gmail.com",
            icon: AntDesign.mail_fill,
            onTap: () {
              _emailKey.text = "shadilpml@gmail.com";
              Clipboard.setData(const ClipboardData(text: "shadilpml@gmail.com"));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Email copied & autofilled!"),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          _buildCredentialRow(
            context: context,
            label: "Password",
            value: "Rizq@12345",
            icon: AntDesign.lock_fill,
            onTap: () {
              _passwordKey.text = "Rizq@12345";
              Clipboard.setData(const ClipboardData(text: "Rizq@12345"));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Password copied & autofilled!"),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCredentialRow({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colorScheme.outline.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 14,
                color: colorScheme.primary.withOpacity(0.8),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "$label: $value",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
              ),
              Icon(
                Icons.copy_all_rounded,
                size: 16,
                color: colorScheme.primary.withOpacity(0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
