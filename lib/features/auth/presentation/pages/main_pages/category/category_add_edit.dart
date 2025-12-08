// ignore_for_file: deprecated_member_use
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/core/services/cloudinary_services.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/category_model.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/category/category_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/category/category_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/category/dialog/category_dialog_cubit.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/category/dialog/category_dialog_cubit_state.dart';
import 'package:uuid/uuid.dart';

class CategoryDialog extends StatefulWidget {
  final CategoryModel? existingCategory;
  final List<CategoryModel>? existingCategories;
  const CategoryDialog({
    super.key,
    this.existingCategory,
    this.existingCategories,
  });

  @override
  State<CategoryDialog> createState() => CategoryDialogState();
}

class CategoryDialogState extends State<CategoryDialog> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  final uuid = const Uuid();
  late CategoryDialogCubit dialogCubit;

  @override
  void initState() {
    super.initState();
    dialogCubit = CategoryDialogCubit();
    nameController = TextEditingController(
      text: widget.existingCategory?.name ?? '',
    );
    if (widget.existingCategory?.logoUrl != null) {
      dialogCubit.initializeImage(widget.existingCategory!.logoUrl);
    }
  }

  Future<void> pickImage() async {
    dialogCubit.setUploading(true);
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      final url = await uploadToCloudinary(result);
      if (url != null) {
        dialogCubit.updateImage(url);
      } else {
        dialogCubit.setUploading(false);
      }
    } else {
      dialogCubit.setUploading(false);
    }
  }

  bool get isEditMode => widget.existingCategory != null;

  bool isDuplicate(String name) {
    if (widget.existingCategories == null ||
        widget.existingCategories!.isEmpty) {
      return false;
    }
    if (isEditMode) {
      return widget.existingCategories!.any(
        (cat) =>
            cat.name.toLowerCase() == name.toLowerCase() &&
            cat.id != widget.existingCategory!.id,
      );
    }
    return widget.existingCategories!.any(
      (cat) => cat.name.toLowerCase() == name.toLowerCase(),
    );
  }

  void handleSubmit(String? imageUrl) {
    if (!formKey.currentState!.validate()) return;

    if (imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a category logo')),
      );
      return;
    }

    final name = nameController.text.trim();
    final category = CategoryModel(
      id: isEditMode ? widget.existingCategory!.id : uuid.v4(),
      name: name,
      logoUrl: imageUrl,
    );

    if (isEditMode) {
      context.read<CategoryBloc>().add(UpdateCategoryEvent(category));
    } else {
      context.read<CategoryBloc>().add(AddCategoryEvent(category));
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: dialogCubit,
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 250, vertical: 100),
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isEditMode
                            ? AppColors.blueAccent.withOpacity(0.1)
                            : Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isEditMode ? Icons.edit_outlined : Icons.add_circle_outline,
                        color: isEditMode ? AppColors.blueAccent : Colors.green,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEditMode ? 'Edit Category' : 'Add New Category',
                            style: GoogleFonts.poppins(
                              color: AppColors.blackHeading,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isEditMode
                                ? 'Update the category information'
                                : 'Create a new category for your products',
                            style: GoogleFonts.poppins(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  'Category Name',
                  style: GoogleFonts.poppins(
                    color: AppColors.blackHeading,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                BlocBuilder<CategoryDialogCubit, CategoryDialogCubitState>(
                  builder: (context, state) {
                    return Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: nameController,
                            autofocus: !isEditMode,
                            decoration: InputDecoration(
                              hintText: 'Enter category name',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 15,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              prefixIcon: Icon(
                                Icons.category_outlined,
                                color: Colors.grey.shade600,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade200),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade200),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: isEditMode ? AppColors.blueAccent : Colors.green,
                                  width: 2,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.red, width: 2),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a category name';
                              }
                              if (value.trim().length < 2) {
                                return 'Category name must be at least 2 characters';
                              }
                              if (isDuplicate(value.trim())) {
                                return 'Category name already exists';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            InkWell(
                              onTap: pickImage,
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
                                child: state.isUploading
                                    ? const Center(child: CircularProgressIndicator())
                                    : state.imageUrl != null
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.network(
                                              state.imageUrl!,
                                              fit: BoxFit.cover,
                                            ),
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
                              "Upload Logo *",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: state.imageUrl == null
                                    ? Colors.red.shade600
                                    : Colors.grey.shade600,
                                fontWeight:
                                    state.imageUrl == null ? FontWeight.w600 : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 32),
                BlocBuilder<CategoryDialogCubit, CategoryDialogCubitState>(
                  builder: (context, state) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => context.pop(),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () => handleSubmit(state.imageUrl),
                          icon: Icon(
                            isEditMode ? Icons.check_circle_outline : Icons.add,
                            size: 20,
                          ),
                          label: Text(
                            isEditMode ? 'Update Category' : 'Add Category',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isEditMode ? AppColors.blueAccent : Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
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
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    dialogCubit.close();
    super.dispose();
  }
}