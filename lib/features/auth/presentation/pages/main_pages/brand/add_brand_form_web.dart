// ignore_for_file: use_build_context_synchronously

import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/core/services/cloudinary_services.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/image/empty_image_placeholder.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/brand_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/brand/brand_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/brand/brand_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/brand/add/add_brand_form_cubit.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/image/shimmer_image.dart';
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

  Future<void> _pickImage(BuildContext context) async {
    context.read<AddBrandFormCubit>().setUploading(true);

    try {
      final url = await ImageUploadService().pickAndUpload();
      if (url != null) {
        context.read<AddBrandFormCubit>().setImage(url);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image upload failed: $e')),
        );
      }
    }

    if (context.mounted) {
      context.read<AddBrandFormCubit>().setUploading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddBrandFormCubit(
        imageUrl: _imageUrl,
        status: _status,
        isUploading: isUploading,
      ),
      child: BlocBuilder<AddBrandFormCubit, AddBrandFormCubitState>(
        builder: (context, cubitState) {
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
                      24.h,

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.label_outline),
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
                          20.w,

                          Column(
                            children: [
                              InkWell(
                                onTap: () => _pickImage(context),
                                child: cubitState.isUploading
                                    ? Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          color: AppColors.grey.shade100,
                                          border: Border.all(color: AppColors.grey.shade300),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      )
                                    : cubitState.imageUrl != null
                                        ? ShimmerImage(
                                            imageUrl: cubitState.imageUrl!,
                                            width: 100,
                                            height: 100,
                                            borderRadius: 8,
                                          )
                                        : const EmptyImagePlaceholder(
                                            width: 100,
                                            height: 100,
                                            text: 'Upload Logo',
                                            iconSize: 32,
                                            type: PlaceholderType.brand,
                                          ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      24.h,

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.grey.shade200),
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
                              value: cubitState.status,
                              onChanged: (val) =>
                                  context.read<AddBrandFormCubit>().setStatus(val),
                            ),
                            Text(
                              cubitState.status ? "Active" : "Inactive",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: cubitState.status
                                    ? AppColors.matGreen
                                    : AppColors.matRed,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      24.h,

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          12.w,
                          ElevatedButton.icon(
                            icon: const Icon(Icons.save),
                            label: Text(
                              isEditMode ? 'Update Brand' : "Save Brand",
                              style: GoogleFonts.poppins(
                                color: AppColors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: () => submitFunc(cubitState),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
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

  void submitFunc(AddBrandFormCubitState cubitState) {
    if (!_formKey.currentState!.validate()) return;

    if (cubitState.imageUrl == null || cubitState.imageUrl!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a brand logo')),
      );
      return;
    }

    final brand = BrandEntity(
      id: isEditMode ? widget.brands!.id : const Uuid().v4(),
      name: _nameController.text.trim(),
      logourl: cubitState.imageUrl!,
      description: '',
      status: cubitState.status,
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
