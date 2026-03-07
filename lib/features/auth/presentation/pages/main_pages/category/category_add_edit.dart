
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/core/services/cloudinary_services.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/image/empty_image_placeholder.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/category_model.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/category/category_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/category/category_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/category/dialog/category_dialog_cubit.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/category/dialog/category_dialog_cubit_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/image/shimmer_image.dart';
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
    try {
      final url = await ImageUploadService().pickAndUpload();
      if (url != null) {
        dialogCubit.updateImage(url);
      } else {
        dialogCubit.setUploading(false);
      }
    } catch (e) {
      dialogCubit.setUploading(false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image upload failed: $e')),
        );
      }
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 800;
    final horizontalPadding = isSmallScreen ? 24.0 : 250.0;
    final verticalPadding = isSmallScreen ? 40.0 : 100.0;

    return BlocProvider.value(
      value: dialogCubit,
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Container(
          padding: EdgeInsets.all(isSmallScreen ? 20 : 32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.white,
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: SingleChildScrollView(
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
                            ? AppColors.blueAccent.withValues(alpha: 0.1)
                            : Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isEditMode ? Icons.edit_outlined : Icons.add_circle_outline,
                        color: isEditMode ? AppColors.blueAccent : Colors.green,
                        size: 28,
                      ),
                    ),
                    16.w,
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
                          4.h,
                          Text(
                            isEditMode
                                ? 'Update the category information'
                                : 'Create a new category for your products',
                            style: GoogleFonts.poppins(
                              color: AppColors.grey.shade600,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                32.h,
                Text(
                  'Category Name',
                  style: GoogleFonts.poppins(
                    color: AppColors.blackHeading,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                8.h,
                BlocBuilder<CategoryDialogCubit, CategoryDialogCubitState>(
                  builder: (context, state) {
                    final imageWidget = Column(
                      children: [
                        InkWell(
                          onTap: pickImage,
                          child: state.isUploading
                              ? Container(
                                  width: isSmallScreen ? 80 : 100,
                                  height: isSmallScreen ? 80 : 100,
                                  decoration: BoxDecoration(
                                    color: AppColors.grey.shade100,
                                    border: Border.all(color: AppColors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Center(child: CircularProgressIndicator()),
                                )
                              : state.imageUrl != null
                                  ? ShimmerImage(
                                      imageUrl: state.imageUrl!,
                                      width: isSmallScreen ? 80 : 100,
                                      height: isSmallScreen ? 80 : 100,
                                      borderRadius: 8,
                                    )
                                  : EmptyImagePlaceholder(
                                      width: isSmallScreen ? 80 : 100,
                                      height: isSmallScreen ? 80 : 100,
                                      iconSize: isSmallScreen ? 24 : 32,
                                      text: '',
                                      type: PlaceholderType.category,
                                    ),
                        ),
                        8.h,
                        Text(
                          "Upload Logo *",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: state.imageUrl == null
                                ? AppColors.black54
                                : AppColors.grey.shade600,
                            fontWeight:
                                state.imageUrl == null ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    );

                    final textFieldWidget = TextFormField(
                      controller: nameController,
                      autofocus: !isEditMode,
                      decoration: InputDecoration(
                        hintText: 'Enter category name',
                        hintStyle: TextStyle(
                          color: AppColors.grey.shade400,
                          fontSize: 15,
                        ),
                        filled: true,
                        fillColor: AppColors.grey.shade50,
                        prefixIcon: Icon(
                          Icons.category_outlined,
                          color: AppColors.grey.shade600,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.grey.shade200),
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
                          borderSide: const BorderSide(color: AppColors.matRed),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.matRed, width: 2),
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
                    );

                    if (isSmallScreen) {
                      return Column(
                        children: [
                          imageWidget,
                          16.h,
                          textFieldWidget,
                        ],
                      );
                    }

                    return Row(
                      children: [
                        Expanded(child: textFieldWidget),
                        20.w,
                        imageWidget,
                      ],
                    );
                  },
                ),
                32.h,
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
                              color: AppColors.grey.shade700,
                            ),
                          ),
                        ),
                        12.w,
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
                            foregroundColor: AppColors.white,
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