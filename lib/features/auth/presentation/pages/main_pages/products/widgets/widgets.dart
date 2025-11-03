// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:rizqmartadmin/core/constants/appcolor.dart';

// Text fieldHeadings(String name) {
//     return Text(name,
//                   style: GoogleFonts.poppins(
//                       color: AppColors.blackHeading,
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500));
//   }

//   //TextField

// class ReusableTextField extends StatelessWidget {
//   final String hintText;
//   final TextEditingController? controller;
//   final TextInputType? keyboardType;
//   final int maxLines;
//   final String? Function(String?)? validator;

//   /// New optional parameters
//   final Color? backgroundColor;
//   final Color? borderColor;
//   final IconData? prefixIcon;

//   const ReusableTextField({
//     super.key,
//     required this.hintText,
//     this.controller,
//     this.keyboardType,
//     this.maxLines = 1,
//     this.validator,
//     this.backgroundColor,
//     this.borderColor,
//     this.prefixIcon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       maxLines: maxLines,
//       validator: validator,
//       decoration: InputDecoration(
//         prefixIcon: prefixIcon != null
//             ? Icon(prefixIcon, color: Colors.grey.shade600)
//             : null,
//         hintText: hintText,
//         hintStyle: GoogleFonts.inter(
//           color: Colors.grey.shade600,
//           fontSize: 14,
//         ),
//         filled: true,

//         fillColor: backgroundColor ?? Colors.grey.shade100,
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: BorderSide(
//             color: borderColor ?? Colors.grey.shade300,
//             width: 1.2,
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: BorderSide(
//             color: borderColor ?? const Color(0xFF7B61FF), // cute purple-blue
//             width: 2,
//           ),
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';



Text pageHeading(String text) {
  return Text(
    text,
    style: GoogleFonts.poppins(
      color: AppColors.blackHeading,
      fontSize: 28,
      fontWeight: FontWeight.w700,
    ),
  );
}

/// Section heading - Medium sized heading for sections
Text sectionHeading(String text) {
  return Text(
    text,
    style: GoogleFonts.poppins(
      color: AppColors.blackHeading,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  );
}

/// Field label - For form field labels
Text fieldLabel(String text) {
  return Text(
    text,
    style: GoogleFonts.poppins(
      color: AppColors.blackHeading,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  );
}

/// Body text - Regular body text
Text bodyText(String text, {Color? color}) {
  return Text(
    text,
    style: GoogleFonts.inter(
      color: color ?? Colors.grey.shade700,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
  );
}

/// Error text - For validation errors
Text errorText(String text) {
  return Text(
    text,
    style: GoogleFonts.inter(
      color: Colors.red.shade600,
      fontSize: 13,
      fontWeight: FontWeight.w500,
    ),
  );
}

// ============================================================================
// INPUT COMPONENTS
// ============================================================================

/// Standard website text input field


// ============================================================================
// BUTTON COMPONENTS
// ============================================================================

/// Primary action button (blue/accent color)
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 44,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(
                    Colors.grey.shade700,
                  ),
                ),
              )
            : Icon(icon ?? Icons.check, size: 18),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blueAccent,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

/// Secondary action button (outline style)
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final double? width;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 35,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon ?? Icons.close, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.blueAccent,
          side: BorderSide(
            color: AppColors.blueAccent,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

/// Danger button (red color for delete actions)
class DangerButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final double? width;

  const DangerButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 44,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon ?? Icons.delete, size: 18),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade600,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// FORM CONTAINERS
// ============================================================================

/// Standard form card wrapper
class FormCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final double? width;

  const FormCard({
    super.key,
    required this.title,
    required this.children,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionHeading(title),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }
}

//Field with drop down



