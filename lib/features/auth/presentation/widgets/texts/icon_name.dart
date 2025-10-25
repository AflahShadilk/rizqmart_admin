
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IconRizq extends StatelessWidget {
  const IconRizq({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset("assets/icons_and_images/appIcon.png");
  }
}

class RizqMartName extends StatelessWidget {
  const RizqMartName({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'RIZQ',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        
        
        Text(
          ' MART',
          style: GoogleFonts.poppins(
            color: Colors.orange,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
