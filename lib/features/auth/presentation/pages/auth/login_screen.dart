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
import 'package:rizqmartadmin/features/auth/presentation/widgets/page_decoration/base_container_decoration.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/texts/icon_name.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/texts/login_headtext.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/page_decoration/respnsive_page.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/sized_boxes/sized_box.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/form_fields/textformfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _loginPageFormKey = GlobalKey<FormState>();
  final _emailKey = TextEditingController();
  final _passwordKey = TextEditingController();
  @override
  void dispose() {
    _emailKey.dispose();
    _passwordKey.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

    return BlocConsumer<LoginBloc, LoginState>(listener: (context, state) {
      if (state is LoginSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ));
        _emailKey.clear();
        _passwordKey.clear();

         context.go('/dashBoard');
      } else if (state is LoginError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3)));
      }
    }, builder: (context, state) {
      return Scaffold(
        body: Container(
          decoration: first_container_decoration(),
          padding: padding,
          width:
              Responsive.isDesktop(context) ? double.infinity : double.infinity,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 800),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color.fromARGB(255, 168, 136, 190),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 5,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- LEFT SIDE ---
                  if (!Responsive.isMobile(context))
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const IconRizq(),
                            const SizedBox(height: 12),
                            const RizqMartName(),
                            const SizedBox(height: 32),
                            loginSideShowIconAndText(
                              assetIm: 'assets/icons_and_images/leeficon.png',
                              textF: 'Organic Groceries',
                            ),
                            const Divider(),
                            loginSideShowIconAndText(
                              assetIm:
                                  'assets/icons_and_images/chickenicon.png',
                              textF: 'Foods and vegetables',
                            ),
                            const Divider(),
                            loginSideShowIconAndText(
                              assetIm:
                                  'assets/icons_and_images/deliveryIcon.png',
                              textF: 'Fast Delivery',
                            ),
                            const Divider(),
                            loginSideShowIconAndText(
                              assetIm: 'assets/icons_and_images/refundicon.png',
                              textF: 'Easy Refund & Return',
                            ),
                            const Divider(),
                            loginSideShowIconAndText(
                              assetIm: 'assets/icons_and_images/secureicon.png',
                              textF: 'Secure & Safe',
                            ),
                          ],
                        ),
                      ),
                    ),

                  // --- RIGHT SIDE LOGIN  ---
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          HeadingLogin(fontSize, "Login to your account"),
                          const SizedBox(height: 24),
                          Form(
                            //form field
                            key: _loginPageFormKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //Email form
                                TextFormFLogin(
                                  controller: _emailKey,
                                  keyboardType: TextInputType.emailAddress,
                                  hint: 'Enter your email',
                                  iconn: AntDesign.mail_fill,
                                  iconnColor: Colors.red,
                                  validator: emailValidator,
                                ),
                                const SizedBox(height: 20),
                                TextFormFLogin(
                                  controller: _passwordKey,
                                  obscureText: true,
                                  hint: 'Enter your password',
                                  iconn: AntDesign.lock_fill,
                                  iconnColor: Colors.black,
                                  validator: passwordValidator,
                                ),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton(
                                    onPressed: () {
                                      context.push('/forgotPasswordPage');
                                    },
                                    child: Text(
                                      "Forgot Password?",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                

                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: state is LoginLoading
                                        ? null
                                        : () async {
                                            if (_loginPageFormKey.currentState!
                                                .validate()) {
                                              context.read<LoginBloc>().add(
                                                    LoginTryEvent(
                                                      email:
                                                          _emailKey.text.trim(),
                                                      password: _passwordKey
                                                          .text
                                                          .trim(),
                                                    ),
                                                  );
                                            }
                                           final pref=await SharedPreferences.getInstance();
                                           await pref.setBool('UserLoggIn', true);
                                          },
                                    child: state is LoginLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.white),
                                            ),
                                          )
                                        : Text(
                                            "Login",
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 16),
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
    });
  }

  Row loginSideShowIconAndText(
      {required String assetIm, required String textF}) {
    return Row(
      children: [
        Image.asset(assetIm, height: 28),
        CommonSizedboxWidth10(),
        Text(
          textF,
          maxLines: 2,
          softWrap: true,
          overflow: TextOverflow.visible,
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}
