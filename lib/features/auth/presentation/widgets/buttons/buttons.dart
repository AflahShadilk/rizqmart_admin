import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/buttons/bloc/button_animation_cubit.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';

/// Standard gradient Sign Up button
ElevatedButton signupButton(void Function()? onPress) {
  return ElevatedButton(
    onPressed: onPress,
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      backgroundColor: AppColors.transparent,
    ),
    child: Ink(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.indigo, AppColors.indigoDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        alignment: Alignment.center,
        constraints: const BoxConstraints(minHeight: 50, minWidth: 150),
        child: Text(
          'Sign Up',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ),
    ),
  );
}

/// Animated reusable text button that uses ButtonAnimationCubit instead of setState
class ReusableTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;

  const ReusableTextButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color bgColor = backgroundColor ?? AppColors.transparent;
    final Color overlay =
        (bgColor != AppColors.transparent ? bgColor : theme.colorScheme.primary)
            .withValues(alpha: 0.1);

    return BlocProvider(
      create: (_) => ButtonAnimationCubit(),
      child: BlocBuilder<ButtonAnimationCubit, bool>(
        builder: (context, isPressed) {
          return GestureDetector(
            onTapDown: (_) => context.read<ButtonAnimationCubit>().setPressed(true),
            onTapUp: (_) => context.read<ButtonAnimationCubit>().setPressed(false),
            onTapCancel: () => context.read<ButtonAnimationCubit>().setPressed(false),
            onTap: onPressed,
            child: AnimatedScale(
              scale: isPressed ? 0.95 : 1.0,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
              child: TextButton(
                onPressed: onPressed,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(bgColor),
                  padding: WidgetStateProperty.all(padding ??
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  overlayColor: WidgetStateProperty.all(overlay),
                ),
                child: Text(
                  text,
                  style: GoogleFonts.inter(
                    color: textColor ?? theme.colorScheme.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

ElevatedButton elevatedButtonForSave(
    {required String text, required void Function()? onPressed}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.teal,
      foregroundColor: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    onPressed: onPressed,
    child: Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}