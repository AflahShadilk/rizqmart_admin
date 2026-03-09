import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GlobalAddButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData icon;

  const GlobalAddButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.add_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadowColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
      ),
    );
  }
}
