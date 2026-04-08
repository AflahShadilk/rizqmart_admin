// ignore_for_file: use_build_context_synchronously

import 'package:rizqmartadmin/core/theme/appcolor.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rizqmartadmin/features/presentation/validators/email_field_validator.dart';
import 'package:rizqmartadmin/features/presentation/bloc/auth/forgot/auth_bloc.dart';
import 'package:rizqmartadmin/features/presentation/bloc/auth/forgot/auth_event.dart';
import 'package:rizqmartadmin/features/presentation/bloc/auth/forgot/auth_state.dart';
import 'package:rizqmartadmin/features/presentation/widgets/page_decoration/respnsive_page.dart';
import 'package:rizqmartadmin/features/presentation/widgets/form_fields/textformfield.dart';
import 'package:rizqmartadmin/features/presentation/pages/auth/widgets/auth_form_container.dart';
import 'package:rizqmartadmin/features/presentation/pages/auth/widgets/auth_header.dart';
import 'package:rizqmartadmin/features/presentation/pages/auth/widgets/auth_submit_button.dart';

class ForgotpasswordScreen extends StatefulWidget {
  const ForgotpasswordScreen({super.key});

  @override
  State<ForgotpasswordScreen> createState() => _ForgotpasswordScreenState();
}

class _ForgotpasswordScreenState extends State<ForgotpasswordScreen> with TickerProviderStateMixin {
  
  // ---------------- Controllers ----------------
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _emailkey = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // ---------------- Init State ----------------
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  // ---------------- Dispose ----------------
  @override
  void dispose() {
    _animationController.dispose();
    _emailkey.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMobile = Responsive.isMobile(context);
    
    final EdgeInsets padding;
    if (Responsive.isDesktop(context)) {
      padding = const EdgeInsets.symmetric(horizontal: 120, vertical: 40);
    } else if (Responsive.isTablet(context)) {
      padding = const EdgeInsets.symmetric(horizontal: 48, vertical: 24);
    } else {
      padding = const EdgeInsets.all(16);
    }

    return BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Reset email sent! Check your inbox (and spam folder).',
              ),
              backgroundColor: AppColors.matGreen,
              duration: const Duration(seconds: 4),
            ),
          );
          _emailkey.clear();
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) context.pop();
          });
        }
        if (state is ForgotPasswordFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: AppColors.matRed,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      },
      builder: (context, state) {
        final bool isLoading = state is ForgotPasswordLoading;

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
            ),
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                Positioned(
                  top: -100,
                  right: -100,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.primary.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -80,
                  left: -80,
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.secondary.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                
                // ---------------- Main content ----------------
                Padding(
                  padding: padding,
                  child: Center(
                    child: SingleChildScrollView(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: AuthFormContainer(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // ---------------- Forgot Password Header ----------------
                                const AuthHeader(
                                  icon: Icons.lock_reset_rounded,
                                  title: 'Reset Your Password',
                                ),
                                
                                Padding(
                                  padding: const EdgeInsets.all(32),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'We\'ll send you an email to reset your password. Please check your inbox and spam folder.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: isMobile ? 13 : 14,
                                          color: theme.textTheme.bodyMedium?.color,
                                          height: 1.6,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                      28.h,
                                      
                                      // ---------------- Email Input Section ----------------
                                      Form(
                                        key: _formkey,
                                        child: TextFormFLogin(
                                          controller: _emailkey,
                                          hint: 'Enter your registered email',
                                          validator: emailValidator,
                                        ),
                                      ),
                                      32.h,
                                      
                                      // ---------------- Reset Password Button ----------------
                                      AuthSubmitButton(
                                        isLoading: isLoading,
                                        text: 'Send Reset Link',
                                        onPressed: () {
                                          if (_formkey.currentState!.validate()) {
                                            context.read<ForgotPasswordBloc>().add(
                                              ForgotPasswordSubmitted(_emailkey.text.trim()),
                                            );
                                          }
                                        },
                                      ),
                                      16.h,
                                      
                                      // ---------------- Back to Login Link ----------------
                                      SizedBox(
                                        width: double.infinity,
                                        child: TextButton(
                                          onPressed: isLoading ? null : () {
                                            context.pop();
                                          },
                                          child: Text(
                                            ' Back to Login',
                                            style: TextStyle(
                                              fontSize: isMobile ? 12 : 14,
                                              color: colorScheme.primary,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}