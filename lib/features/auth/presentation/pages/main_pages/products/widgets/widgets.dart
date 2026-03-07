import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
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

Text bodyText(String text, {Color? color}) {
  return Text(
    text,
    style: GoogleFonts.inter(
      color: color ?? AppColors.grey.shade700,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
  );
}

Text errorText(String text) {
  return Text(
    text,
    style: GoogleFonts.inter(
      color: AppColors.matRed.shade600,
      fontSize: 13,
      fontWeight: FontWeight.w500,
    ),
  );
}

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
                    AppColors.grey.shade700,
                  ),
                ),
              )
            : Icon(icon ?? Icons.check, size: 18),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blueAccent,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

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
          backgroundColor: AppColors.matRed.shade600,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

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
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionHeading(title),
          20.h,
          ...children,
        ],
      ),
    );
  }
}


