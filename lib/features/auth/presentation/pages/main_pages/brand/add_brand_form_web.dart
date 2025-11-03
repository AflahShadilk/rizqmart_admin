// ignore_for_file: deprecated_member_use

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/core/services/cloudinary_services.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/brand_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/brand/brand_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/brand/brand_event.dart';
import 'package:uuid/uuid.dart';

class AddBrandFormWeb extends StatefulWidget {
  final BrandEntity? brands;
  final List<BrandEntity>? brandslist;
  const AddBrandFormWeb({super.key, this.brands, this.brandslist});

  @override
  State<AddBrandFormWeb> createState() => _AddBrandFormWebState();
}

class _AddBrandFormWebState extends State<AddBrandFormWeb> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _imageUrl;
  bool _status = true;
  bool isUploading = false;
  late bool isEditMode;

  @override
  void initState() {
    super.initState();
    isEditMode = widget.brands != null;
    if (widget.brands != null) {
      _nameController.text = widget.brands!.name;
      _imageUrl = widget.brands!.logourl;
      _status = widget.brands!.status;
    }
  }

  Future<void> _pickImage() async {
    setState(() {
      isUploading = true;
    });
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      final url = await uploadToCloudinary(result);
      setState(() {
        _imageUrl = url!;
      });
    }
    setState(() {
      isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEditMode ? 'Edit Brand' : "Add New Brand",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackHeading,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Brand Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Enter brand name';
                          }
                          if (isDuplicate(val.trim())) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Brand name already exists'),
                              ),
                            );
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        InkWell(
                          onTap: _pickImage,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              border: Border.all(
                                color: Colors.grey.shade300,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: isUploading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : _imageUrl != null
                                    ? Image.network(
                                        _imageUrl!,
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(
                                        Icons.add_a_photo,
                                        color: Colors.grey,
                                        size: 40,
                                      ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Upload Logo",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Status: ",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Switch(
                        value: _status,
                        onChanged: (val) => setState(() => _status = val),
                      ),
                      Text(
                        _status ? "Active" : "Inactive",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: _status ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.poppins(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: Text(
                        isEditMode ? 'Update Brand' : "Save Brand",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blueAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: submitFunc,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isDuplicate(String name) {
    if (widget.brandslist == null || widget.brandslist!.isEmpty) {
      return false;
    }

    if (isEditMode) {
      return widget.brandslist!.any(
        (brand) =>
            brand.name.toLowerCase() == name.toLowerCase() &&
            brand.id != widget.brands!.id,
      );
    }
    return widget.brandslist!.any(
      (brand) => brand.name.toLowerCase() == name.toLowerCase(),
    );
  }

  void submitFunc() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_imageUrl == null || _imageUrl!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a brand logo')),
      );
      return;
    }
    if (isEditMode && isDuplicate(_nameController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Brand name already exists')),
      );
      return;
    }
    final brand = BrandEntity(
      id: isEditMode ? widget.brands!.id : const Uuid().v4(),
      name: _nameController.text.trim(),
      logourl: _imageUrl ?? '',
      description: '',
      status: _status,
    );
    if (isEditMode) {
      context.read<BrandBloc>().add(UpdateBrandEvent(brand));
    } else {
      context.read<BrandBloc>().add(AddBrandEvent(brand));
    }
    Navigator.pop(context);
    _formKey.currentState!.reset();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}