import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFormFLogin extends StatefulWidget {
  const TextFormFLogin({
    super.key,
    this.hint,
    this.iconn,
    this.iconnColor,
    this.controller,
    this.validator,
    this.keyboardType,
    this.obscureText,
    this.enable,
    this.onChanged,
    this.maxLength,
  });

  final String? hint;
  final IconData? iconn;
  final Color? iconnColor;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final bool? enable;
  final Function(String)? onChanged;
  final int? maxLength;

  @override
  State<TextFormFLogin> createState() => _TextFormFLoginState();
}

class _TextFormFLoginState extends State<TextFormFLogin> {
  bool obscureText=true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      autovalidateMode:AutovalidateMode.onUnfocus ,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      obscureText: widget.obscureText ??false,
      maxLength: widget.maxLength,
      onChanged: widget.onChanged,
      
      decoration: InputDecoration(
        hintText: widget.hint,
        labelStyle: GoogleFonts.poppins(),
        prefixIcon: widget.iconn != null
            ? Icon(widget.iconn, color: widget.iconnColor ?? Colors.orange)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.orange, width: 1.8),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        
      ),
      style: GoogleFonts.poppins(),
    );
  }
}
