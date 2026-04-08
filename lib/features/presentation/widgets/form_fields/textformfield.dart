import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFormFLogin extends StatelessWidget {
  const TextFormFLogin({
    super.key,
    this.hint,
    this.iconn,
    this.iconnColor,
    this.controller,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.enable,
    this.onChanged,
    this.maxLength,
    this.suffixIcon,
    this.onSuffixTap,
  });

  final String? hint;
  final IconData? iconn;
  final Color? iconnColor;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool? enable;
  final Function(String)? onChanged;
  final int? maxLength;
  final Widget? suffixIcon;
  final VoidCallback? onSuffixTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextFormField(
      controller: controller,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: keyboardType ?? TextInputType.text,
      obscureText: obscureText,
      maxLength: maxLength,
      onChanged: onChanged,
      enabled: enable,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(
          color: theme.hintColor,
          fontSize: 14,
        ),
        prefixIcon: iconn != null
            ? Icon(iconn, color: iconnColor ?? colorScheme.primary)
            : null,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.primary, width: 1.8),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: theme.inputDecorationTheme.fillColor,
      ),
      style: GoogleFonts.inter(
        color: colorScheme.onSurface,
        fontSize: 14,
      ),
    );
  }
}
