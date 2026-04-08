import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/core/theme/appcolor.dart';

Text headingLogin(double fontSize, String textt) {
  return Text(
    textt,
    style: GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: AppColors.black,
    ),
    textAlign: TextAlign.center,
  );
}
