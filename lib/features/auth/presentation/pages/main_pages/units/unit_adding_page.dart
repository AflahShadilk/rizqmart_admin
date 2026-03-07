
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/units_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/unit/unit_dialog_category_cubit.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/unit/unit_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/unit/unit_event.dart';
import 'package:uuid/uuid.dart';

class UnitDialog extends StatefulWidget {
  final List<UnitsEntity> existingUnits;
  final UnitsEntity? existingUnit;
  final List<String> categories; 
  final String? selectedCategory;

  const UnitDialog({
    super.key,
    required this.existingUnits,
    this.existingUnit,
    required this.categories,
    this.selectedCategory,
  });

  @override
  State<UnitDialog> createState() => _UnitDialogState();
}

class _UnitDialogState extends State<UnitDialog> {
  late TextEditingController _unitNameController;
  late TextEditingController _unitTypeController;
  late TextEditingController _weightController;
  final _formKey = GlobalKey<FormState>();
  late UnitDialogCategoryCubit _categoryCubit;
  late UnitDialogLoadingCubit _loadingCubit;

  @override
  void initState() {
    super.initState();
    _categoryCubit = UnitDialogCategoryCubit(widget.existingUnit?.category);
    _loadingCubit = UnitDialogLoadingCubit();
    _unitNameController = TextEditingController(
      text: widget.existingUnit?.unitName ?? '',
    );
    _unitTypeController = TextEditingController(
      text: widget.existingUnit?.unitType ?? '',
    );
    _weightController = TextEditingController(
      text: widget.existingUnit?.wieght.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _unitNameController.dispose();
    _unitTypeController.dispose();
    _weightController.dispose();
    _categoryCubit.close();
    _loadingCubit.close();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final selectedCategory = _categoryCubit.state;
      
      if (selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a category')),
        );
        return;
      }

      _formKey.currentState!.save();

      _loadingCubit.setLoading(true);

      final unitBloc = context.read<UnitBloc>();
      final unitsEntity = UnitsEntity(
        id: widget.existingUnit?.id ?? const Uuid().v4(),
        unitName: _unitNameController.text.trim(),
        unitType: _unitTypeController.text.trim(),
        wieght: double.parse(_weightController.text), 
        category: selectedCategory,
      );

      if (widget.existingUnit == null) {
        unitBloc.add(UnitAddingEvent(unitsEntity));
      } else {
        unitBloc.add(UnitUpdatingEvent(unitsEntity));
      }

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingUnit != null;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: _categoryCubit,
        ),
        BlocProvider.value(
          value: _loadingCubit,
        ),
      ],
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 8,
        backgroundColor: AppColors.transparent,
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 500,
            minWidth: 400,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.15),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.blueAccent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isEditing ? Icons.edit_outlined : Icons.add_circle_outline,
                            color: AppColors.blueAccent,
                            size: 28,
                          ),
                        ),
                        16.w,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isEditing ? 'Edit Unit' : 'Add New Unit',
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.blackHeading,
                                ),
                              ),
                              Text(
                                isEditing
                                    ? 'Update unit information'
                                    : 'Create a new unit variant',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: AppColors.grey.shade600,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.close,
                              color: AppColors.grey.shade600,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    28.h,

                    BuildCategoryDropdown(categories: widget.categories),
                    20.h,

                    BuildInputField(
                      label: 'Unit Name',
                      hint: 'e.g., Small Pack, 1kg Bag, Bundle',
                      controller: _unitNameController,
                      icon: Icons.label_outline,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Unit name is required';
                        }
                        return null;
                      },
                    ),
                    20.h,

                    BuildInputField(
                      label: 'Unit Type',
                      hint: 'e.g., kg, gram, liter, ml, piece, box, pack',
                      controller: _unitTypeController,
                      icon: Icons.category_outlined,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Unit type is required';
                        }
                        return null;
                      },
                    ),
                    20.h,

                    BuildInputField(
                      label: 'Weight/Quantity',
                      hint: 'e.g., 1.5, 500, 2.25',
                      controller: _weightController,
                      icon: Icons.scale_outlined,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: false,
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Weight is required';
                        }
                        if (double.tryParse(value!) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    32.h,

                    BlocBuilder<UnitDialogLoadingCubit, bool>(
                      builder: (context, isLoading) {
                        return Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.grey.shade100,
                                  foregroundColor: AppColors.grey.shade700,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Cancel',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            12.w,
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: isLoading ? null : _submitForm,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.matGreen,
                                  foregroundColor: AppColors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                  shadowColor: AppColors.matGreen.withValues(alpha: 0.4),
                                  disabledBackgroundColor: AppColors.matGreen.withValues(alpha: 0.6),
                                ),
                                icon: isLoading
                                    ? SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            AppColors.white.withValues(alpha: 0.8),
                                          ),
                                        ),
                                      )
                                    : Icon(
                                        isEditing ? Icons.update : Icons.check_circle,
                                        size: 18,
                                      ),
                                label: Text(
                                  isEditing ? 'Update Unit' : 'Create Unit',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BuildCategoryDropdown extends StatelessWidget {
  final List<String> categories;

  const BuildCategoryDropdown({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.blackHeading,
          ),
        ),
        8.h,
        BlocBuilder<UnitDialogCategoryCubit, String?>(
          builder: (context, selectedCategory) {
            return DropdownButtonFormField<String>(
              isExpanded: true,
              value: selectedCategory,
              onChanged: (String? newValue) {
                context.read<UnitDialogCategoryCubit>().setCategory(newValue);
              },
              items: categories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.blackHeading,
                    ),
                  ),
                );
              }).toList(),
              decoration: InputDecoration(
                hintText: 'Select a category',
                hintStyle: GoogleFonts.poppins(
                  color: AppColors.grey.shade400,
                  fontSize: 13,
                ),
                prefixIcon: Icon(
                  Icons.category_outlined,
                  color: AppColors.blueAccent,
                  size: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.grey.shade200,
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.grey.shade200,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.blueAccent,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.matRed.shade400,
                    width: 1.5,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.matRed.shade600,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: AppColors.grey.shade50,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class BuildInputField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const BuildInputField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.blackHeading,
          ),
        ),
        8.h,
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              color: AppColors.grey.shade400,
              fontSize: 13,
            ),
            prefixIcon: Icon(
              icon,
              color: AppColors.blueAccent,
              size: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.grey.shade200,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.grey.shade200,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.blueAccent,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.matRed.shade400,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.matRed.shade600,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: AppColors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: AppColors.blackHeading,
          ),
        ),
      ],
    );
  }
}