// ignore_for_file: use_build_context_synchronously

import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:rizqmartadmin/features/auth/presentation/validators/email_field_validator.dart';
import 'package:rizqmartadmin/features/auth/presentation/validators/password_field_validator.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/auth/bloc/login%20bloc/auth_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/auth/bloc/login%20bloc/auth_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/auth/bloc/login%20bloc/auth_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/texts/icon_name.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/texts/login_headtext.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/page_decoration/respnsive_page.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/sized_boxes/sized_box.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/form_fields/textformfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/auth/bloc/login%20ui%20cubit/login_ui_state_cubit.dart';

/// The primary authenticating point of RizqMart Admin Panel
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
              backgroundColor: const Color(0xFF10B981),
              duration: const Duration(seconds: 2),
            ));
            context.go('/dashBoard');
          }
        } else if (state is LoginError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error),
            backgroundColor: const Color(0xFFEF4444),
            duration: const Duration(seconds: 3),
          ));
        }
      },
      builder: (context, state) {
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
                      color: theme.shadowColor.withValues(alpha: 0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!Responsive.isMobile(context))
                      Expanded(
                        flex: 4,
                        child: Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                colorScheme.primary.withValues(alpha: 0.08),
                                colorScheme.primary.withValues(alpha: 0.03),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const IconRizq(),
                              12.h,
                              const RizqMartName(),
                              32.h,
                              loginSideShowIconAndText(
                                assetIm:
                                    'assets/icons_and_images/leeficon.png',
                                textF: 'Organic Groceries',
                              ),
                              Divider(
                                  color: colorScheme.outline
                                      .withValues(alpha: 0.2)),
                              loginSideShowIconAndText(
                                assetIm:
                                    'assets/icons_and_images/chickenicon.png',
                                textF: 'Foods and vegetables',
                              ),
                              Divider(
                                  color: colorScheme.outline
                                      .withValues(alpha: 0.2)),
                              loginSideShowIconAndText(
                                assetIm:
                                    'assets/icons_and_images/deliveryIcon.png',
                                textF: 'Fast Delivery',
                              ),
                              Divider(
                                  color: colorScheme.outline
                                      .withValues(alpha: 0.2)),
                              loginSideShowIconAndText(
                                assetIm:
                                    'assets/icons_and_images/refundicon.png',
                                textF: 'Easy Refund & Return',
                              ),
                              Divider(
                                  color: colorScheme.outline
                                      .withValues(alpha: 0.2)),
                              loginSideShowIconAndText(
                                assetIm:
                                    'assets/icons_and_images/secureicon.png',
                                textF: 'Secure & Safe',
                              ),
                            ],
                          ),
                        ),
                      ),
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            headingLogin(fontSize, "Login to your account"),
                            24.h,
                            Form(
                              key: _loginPageFormKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextFormFLogin(
                                    controller: _emailKey,
                                    keyboardType: TextInputType.emailAddress,
                                    hint: 'Enter your email',
                                    iconn: AntDesign.mail_fill,
                                    iconnColor: colorScheme.primary,
                                    validator: emailValidator,
                                  ),
                                  20.h,
                                  TextFormFLogin(
                                    controller: _passwordKey,
                                    obscureText: !uiState.isPasswordVisible,
                                    hint: 'Enter your password',
                                    iconn: AntDesign.lock_fill,
                                    iconnColor: colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                    validator: passwordValidator,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        uiState.isPasswordVisible
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: theme.textTheme.bodySmall?.color,
                                      ),
                                      onPressed: () {
                                        context
                                            .read<LoginUIStateCubit>()
                                            .togglePasswordVisibility();
                                      },
                                    ),
                                  ),
                                  12.h,
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: uiState.rememberMe,
                                            activeColor: colorScheme.primary,
                                            onChanged: (value) {
                                              context
                                                  .read<LoginUIStateCubit>()
                                                  .setRememberMe(value ?? false);
                                            },
                                          ),
                                          Text(
                                            "Remember Me",
                                            style: GoogleFonts.inter(
                                              fontSize: 13,
                                              color: theme.textTheme.bodyMedium
                                                  ?.color,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          context
                                              .push('/forgotPasswordPage');
                                        },
                                        child: Text(
                                          "Forgot Password?",
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            color: colorScheme.primary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  16.h,
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: colorScheme.primary,
                                        foregroundColor:
                                            colorScheme.onPrimary,
                                        padding:
                                            const EdgeInsets.symmetric(
                                                vertical: 16),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      onPressed: state is LoginLoading
                                          ? null
                                          : () {
                                              if (_loginPageFormKey
                                                  .currentState!
                                                  .validate()) {
                                                context
                                                    .read<LoginBloc>()
                                                    .add(
                                                      LoginTryEvent(
                                                        email: _emailKey
                                                            .text
                                                            .trim(),
                                                        password:
                                                            _passwordKey
                                                                .text
                                                                .trim(),
                                                      ),
                                                    );
                                              }
                                            },
                                      child: state is LoginLoading
                                          ?  SizedBox(
                                              height: 20,
                                              width: 20,
                                              child:
                                                  CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                            Color>(
                                                        theme.colorScheme.onPrimary),
                                              ),
                                            )
                                          : Text(
                                              "Login",
                                              style: GoogleFonts.inter(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                    ),
                                  ),
                                  16.h,
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
              ));
            },
          );
      },
    ),
    );
  }

  Row loginSideShowIconAndText(
      {required String assetIm, required String textF}) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Image.asset(assetIm, height: 28),
        commonSizedboxWidth10(),
        Expanded(
          child: Text(
            textF,
            maxLines: 2,
            softWrap: true,
            overflow: TextOverflow.visible,
            style: GoogleFonts.inter(
              color: theme.textTheme.bodyMedium?.color,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
