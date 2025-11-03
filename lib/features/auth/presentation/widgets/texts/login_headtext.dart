import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Text HeadingLogin(double fontSize, String textt) {
  return Text(
    textt,
    style: GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    textAlign: TextAlign.center,
  );
}
