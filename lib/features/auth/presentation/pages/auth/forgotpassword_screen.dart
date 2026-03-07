// ignore_for_file: use_build_context_synchronously

import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/features/auth/presentation/validators/email_field_validator.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/auth/bloc/forgot%20password%20bloc/auth_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/auth/bloc/forgot%20password%20bloc/auth_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/auth/bloc/forgot%20password%20bloc/auth_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/page_decoration/respnsive_page.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/form_fields/textformfield.dart';

class ForgotpasswordScreen extends StatefulWidget {
  const ForgotpasswordScreen({super.key});

  @override
  State<ForgotpasswordScreen> createState() => _ForgotpasswordScreenState();
}

class _ForgotpasswordScreenState extends State<ForgotpasswordScreen>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _emailkey = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailkey.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              backgroundColor: AppColors.matGreen[600],
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
              backgroundColor: AppColors.matRed[600],
              duration: const Duration(seconds: 4),
            ),
          );
        }
      },
      builder: (context, state) {
        bool isLoading = state is ForgotPasswordLoading;

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
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
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
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
                      color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                // Main content
                Padding(
                  padding: padding,
                  child: Center(
                    child: SingleChildScrollView(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: Responsive.isDesktop(context)
                                  ? 500
                                  : double.infinity,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardTheme.color,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                                  blurRadius: 30,
                                  spreadRadius: 8,
                                  offset: const Offset(0, 15),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Header with icon
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 32,
                                      horizontal: 24,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Theme.of(context).colorScheme.primary,
                                          Theme.of(context).colorScheme.secondary,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Theme.of(context).cardTheme.color,
                                          ),
                                          child: Icon(
                                            Icons.lock_reset_rounded,
                                            size: Responsive.isDesktop(context)
                                                ? 56
                                                : 48,
                                            color: Theme.of(context).colorScheme.onPrimary,
                                          ),
                                        ),
                                        16.h,
                                        Text(
                                          'Reset Your Password',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            fontSize: Responsive.isMobile(context)
                                                ? 20
                                                : 24,
                                            fontWeight: FontWeight.w700,
                                            color: Theme.of(context).colorScheme.onPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Form content
                                  Padding(
                                    padding: const EdgeInsets.all(32),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'We\'ll send you an email to reset your password. Please check your inbox and spam folder.',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            fontSize:
                                                Responsive.isMobile(context)
                                                    ? 13
                                                    : 14,
                                            color: Theme.of(context).textTheme.bodyMedium?.color,
                                            height: 1.6,
                                          ),
                                        ),
                                        28.h,
                                        Form(
                                          key: _formkey,
                                          child: TextFormFLogin(
                                            controller: _emailkey,
                                            hint: 'Enter your registered email',
                                            validator: emailValidator,
                                            // enabled: !isLoading,
                                          ),
                                        ),
                                        32.h,
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            style:
                                                ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 16,
                                              ),
                                              shape:
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                                backgroundColor:
                                                    Theme.of(context).colorScheme.primary,
                                                elevation: 4,
                                                disabledBackgroundColor:
                                                    Theme.of(context).disabledColor,
                                            ),
                                            onPressed: isLoading
                                                ? null
                                                : () {
                                                    if (_formkey.currentState!
                                                        .validate()) {
                                                      context
                                                          .read<
                                                              ForgotPasswordBloc>()
                                                          .add(
                                                            ForgotPasswordSubmitted(
                                                              _emailkey.text
                                                                  .trim(),
                                                            ),
                                                          );
                                                    }
                                                  },
                                            child: isLoading
                                                ? SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                              Color>(
                                                            Theme.of(context).colorScheme.onPrimary,
                                                          ),
                                                      strokeWidth: 2.5,
                                                    ),
                                                  )
                                                : Text(
                                                    'Send Reset Link',
                                                    style:
                                                        GoogleFonts.poppins(
                                                      fontSize:
                                                          Responsive
                                                                  .isMobile(
                                                                context,
                                                              )
                                                              ? 14
                                                              : 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Theme.of(context).colorScheme.onPrimary,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        16.h,
                                        SizedBox(
                                          width: double.infinity,
                                          child: TextButton(
                                            onPressed:
                                                isLoading ? null : () {
                                              context.pop();
                                            },
                                            child: Text(
                                              ' Back to Login',
                                              style: GoogleFonts.poppins(
                                                fontSize:
                                                    Responsive.isMobile(
                                                            context,
                                                          )
                                                        ? 12
                                                        : 14,
                                                color: Theme.of(context).colorScheme.primary,
                                                fontWeight: FontWeight.w500,
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}