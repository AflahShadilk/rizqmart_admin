// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/units_entity.dart';
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
   String? _selectedCategory;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
      
   _selectedCategory=widget.existingUnit?.category;
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
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a category')),
        );
        return;
      }

      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      final unitBloc = context.read<UnitBloc>();
      final unitsEntity = UnitsEntity(
        id: widget.existingUnit?.id ?? const Uuid().v4(),
        unitName: _unitNameController.text.trim(),
        unitType: _unitTypeController.text.trim(),
        wieght: double.parse(_weightController.text), 
        category: _selectedCategory!,

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

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 8,
      backgroundColor: Colors.transparent,
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
              color: Colors.black.withOpacity(0.15),
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
                          color: AppColors.blueAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isEditing ? Icons.edit_outlined : Icons.add_circle_outline,
                          color: AppColors.blueAccent,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
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
                                color: Colors.grey.shade600,
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
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.grey.shade600,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

              
                  _buildCategoryDropdown(),
                  const SizedBox(height: 20),

                  _buildInputField(
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
                  const SizedBox(height: 20),

                  _buildInputField(
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
                  const SizedBox(height: 20),

                  _buildInputField(
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
                  const SizedBox(height: 32),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade100,
                            foregroundColor: Colors.grey.shade700,
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
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            shadowColor: AppColors.green.withOpacity(0.4),
                            disabledBackgroundColor: AppColors.green.withOpacity(0.6),
                          ),
                          icon: _isLoading
                              ? SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white.withOpacity(0.8),
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
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
      
      const SizedBox(height: 8),
      
      DropdownButtonFormField<String>(
        isExpanded: true,
        value: _selectedCategory,
        
        onChanged: (String? newValue) {
          setState(() {
            _selectedCategory = newValue;
          });
        },
        
        items: widget.categories.map<DropdownMenuItem<String>>((String value) {
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
            color: Colors.grey.shade400,
            fontSize: 13,
          ),
          prefixIcon: Icon(
            Icons.category_outlined,
            color: AppColors.blueAccent,
            size: 20,
          ),
          // suffixIcon: Icon(
          //   Icons.arrow_drop_down,
          //   color: AppColors.blueAccent,
          //   size: 24,
          // ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.grey.shade200,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.grey.shade200,
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
              color: Colors.red.shade400,
              width: 1.5,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.red.shade600,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    ],
  );
}

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
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
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              color: Colors.grey.shade400,
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
                color: Colors.grey.shade200,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.shade200,
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
                color: Colors.red.shade400,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.red.shade600,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
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