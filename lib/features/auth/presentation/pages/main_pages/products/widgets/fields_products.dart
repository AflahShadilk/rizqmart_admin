import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/products/widgets/widgets.dart';

class WebTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final int maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool readOnly;

  const WebTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.readOnly = false,
  });

  @override
  State<WebTextField> createState() => _WebTextFieldState();
}

class _WebTextFieldState extends State<WebTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty) ...[
          fieldLabel(widget.label),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          autovalidateMode: AutovalidateMode.onUnfocus,
          keyboardType: widget.keyboardType,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          maxLength: widget.maxLength,
          obscureText: widget.obscureText,
          readOnly: widget.readOnly,
          validator: widget.validator,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: GoogleFonts.inter(
              color: Colors.grey.shade500,
              fontSize: 14,
            ),
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: _isFocused
                        ? AppColors.blueAccent
                        : Colors.grey.shade500,
                    size: 20,
                  )
                : null,
            suffixIcon: widget.suffixIcon,
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.blueAccent,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.red.shade400,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.red.shade600,
                width: 2,
              ),
            ),
            errorStyle: GoogleFonts.inter(
              color: Colors.red.shade600,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

/// Multi-line textarea for longer text input
class WebTextArea extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final int minLines;
  final int maxLines;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  const WebTextArea({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.minLines = 3,
    this.maxLines = 6,
    this.validator,
    this.onChanged,
  });

  @override
  State<WebTextArea> createState() => _WebTextAreaState();
}

class _WebTextAreaState extends State<WebTextArea> {
  late FocusNode _focusNode;
  // ignore: unused_field
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        fieldLabel(widget.label),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          autovalidateMode: AutovalidateMode.onUnfocus,
          focusNode: _focusNode,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          validator: widget.validator,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: GoogleFonts.inter(
              color: Colors.grey.shade500,
              fontSize: 14,
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.blueAccent,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.red.shade400,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.red.shade600,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

//Drop down field :
class WebTextFields extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final int maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool readOnly;
  
  // Dropdown support
  final bool isDropdown;
  final List<DropdownMenuItem<String>>? dropdownItems;
  final String? selectedValue;
  final Function(String?)? onDropdownChanged;
   final List<Widget> Function(BuildContext)? selectedItemBuilder;
  const WebTextFields({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.readOnly = false,
    this.isDropdown = false,
    this.dropdownItems,
    this.selectedValue,
    this.onDropdownChanged,
    this.selectedItemBuilder
  });

  @override
  State<WebTextFields> createState() => _WebTextFieldsState();
}

class _WebTextFieldsState extends State<WebTextFields> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  InputDecoration _buildDecoration() {
    return InputDecoration(
      hintText: widget.hintText,
      hintStyle: GoogleFonts.inter(
        color: Colors.grey.shade500,
        fontSize: 14,
      ),
      prefixIcon: widget.prefixIcon != null
          ? Icon(
              widget.prefixIcon,
              color: _isFocused ? Colors.blue : Colors.grey.shade500,
              size: 20,
            )
          : null,
      suffixIcon: widget.suffixIcon,
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Colors.blue,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Colors.red.shade400,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Colors.red.shade600,
          width: 2,
        ),
      ),
      errorStyle: GoogleFonts.inter(
        color: Colors.red.shade600,
        fontSize: 12,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty) ...[
          Text(
            widget.label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
        ],
        if (widget.isDropdown)
          DropdownButtonFormField<String>(
            value: widget.selectedValue,
            items: widget.dropdownItems,
            onChanged: widget.onDropdownChanged,
            validator: widget.validator,
            decoration: _buildDecoration(),
            isExpanded: true,
            selectedItemBuilder: widget.selectedItemBuilder,
          )
        else
          TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            autovalidateMode: AutovalidateMode.onUnfocus,
            keyboardType: widget.keyboardType,
            maxLines: widget.obscureText ? 1 : widget.maxLines,
            maxLength: widget.maxLength,
            obscureText: widget.obscureText,
            readOnly: widget.readOnly,
            validator: widget.validator,
            onChanged: widget.onChanged,
            decoration: _buildDecoration(),
          ),
      ],
    );
  }
}