import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyImagePlaceholder extends StatelessWidget {
  final double? width;
  final double? height;
  final IconData icon;
  final String text;
  final double iconSize;

  const EmptyImagePlaceholder({
    super.key,
    this.width,
    this.height,
    this.icon = Icons.add_photo_alternate_outlined,
    this.text = 'Upload Image',
    this.iconSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: Colors.grey.shade400,
            ),
            if (text.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
