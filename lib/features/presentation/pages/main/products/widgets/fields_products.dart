import 'package:rizqmartadmin/core/theme/appcolor.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/features/presentation/cubit/products/focus_cubit.dart';

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
  late FocusCubit _focusCubit;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusCubit = FocusCubit();
    _focusNode.addListener(() {
      _focusCubit.onFocusChanged(_focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusCubit.close();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider.value(
      value: _focusCubit,
      child: BlocBuilder<FocusCubit, bool>(
        builder: (context, isFocused) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.label.isNotEmpty) ...[
                Text(
                  widget.label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.blackHeading,
                  ),
                ),
                8.h,
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
                style: GoogleFonts.inter(
                  color: theme.textTheme.bodyLarge?.color,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: GoogleFonts.inter(
                    color: theme.hintColor,
                    fontSize: 14,
                  ),
                  prefixIcon: widget.prefixIcon != null
                      ? Icon(
                          widget.prefixIcon,
                          color: isFocused
                              ? theme.colorScheme.primary
                              : theme.iconTheme.color?.withValues(alpha: 0.5) ?? AppColors.grey,
                          size: 20,
                        )
                      : null,
                  suffixIcon: widget.suffixIcon,
                  filled: true,
                  fillColor: theme.cardTheme.color ?? theme.colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: theme.dividerColor.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: theme.colorScheme.error.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: theme.colorScheme.error,
                      width: 2,
                    ),
                  ),
                  errorStyle: GoogleFonts.inter(
                    color: theme.colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

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
  late FocusCubit _focusCubit;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusCubit = FocusCubit();
    _focusNode.addListener(() {
      _focusCubit.onFocusChanged(_focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusCubit.close();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider.value(
      value: _focusCubit,
      child: BlocBuilder<FocusCubit, bool>(
        builder: (context, isFocused) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              8.h,
              TextFormField(
                controller: widget.controller,
                autovalidateMode: AutovalidateMode.onUnfocus,
                focusNode: _focusNode,
                minLines: widget.minLines,
                maxLines: widget.maxLines,
                validator: widget.validator,
                onChanged: widget.onChanged,
                style: GoogleFonts.inter(
                  color: theme.textTheme.bodyLarge?.color,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: GoogleFonts.inter(
                    color: theme.hintColor,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: theme.cardTheme.color ?? theme.colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: theme.dividerColor.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: theme.colorScheme.error.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: theme.colorScheme.error,
                      width: 2,
                    ),
                  ),
                  errorStyle: GoogleFonts.inter(
                    color: theme.colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

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
  late FocusCubit _focusCubit;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusCubit = FocusCubit();
    _focusNode.addListener(() {
      _focusCubit.onFocusChanged(_focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusCubit.close();
    _focusNode.dispose();
    super.dispose();
  }

  InputDecoration _buildDecoration(ThemeData theme, bool isFocused) {
    return InputDecoration(
      hintText: widget.hintText,
      hintStyle: GoogleFonts.inter(
        color: theme.hintColor,
        fontSize: 14,
      ),
      prefixIcon: widget.prefixIcon != null
          ? Icon(
              widget.prefixIcon,
              color: isFocused ? theme.colorScheme.primary : theme.iconTheme.color?.withValues(alpha: 0.5) ?? AppColors.grey,
              size: 20,
            )
          : null,
      suffixIcon: widget.suffixIcon,
      filled: true,
      fillColor: theme.cardTheme.color ?? theme.colorScheme.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: theme.dividerColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: theme.colorScheme.primary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: theme.colorScheme.error.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: theme.colorScheme.error,
          width: 2,
        ),
      ),
      errorStyle: GoogleFonts.inter(
        color: theme.colorScheme.error,
        fontSize: 12,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider.value(
      value: _focusCubit,
      child: BlocBuilder<FocusCubit, bool>(
        builder: (context, isFocused) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.label.isNotEmpty) ...[
                Text(
                  widget.label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.blackHeading,
                  ),
                ),
                8.h,
              ],
              if (widget.isDropdown)
                DropdownButtonFormField<String>(
                  value: widget.selectedValue,
                  items: widget.dropdownItems,
                  onChanged: widget.onDropdownChanged,
                  validator: widget.validator,
                  decoration: _buildDecoration(theme, isFocused),
                  isExpanded: true,
                  selectedItemBuilder: widget.selectedItemBuilder,
                  style: GoogleFonts.inter(
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                  dropdownColor: theme.cardTheme.color ?? theme.colorScheme.surface,
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
                  style: GoogleFonts.inter(
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                  decoration: _buildDecoration(theme, isFocused),
                ),
            ],
          );
        },
      ),
    );
  }
}