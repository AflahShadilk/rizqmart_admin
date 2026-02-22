// ignore_for_file: use_build_context_synchronously

import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/core/services/cloudinary_services.dart';
import 'package:rizqmartadmin/core/widgets/shimmer_image.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/coupon_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/coupon_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/page_decoration/respnsive_page.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/product_selection_dialog.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/product/product_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/coupon/add_coupon_cubit.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/coupon/add_coupon_cubit_state.dart';

class AddCouponPage extends StatelessWidget {
  final CouponEntity? couponToEdit;

  const AddCouponPage({super.key, this.couponToEdit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = AddCouponCubit();
        if (couponToEdit != null) {
          cubit.initEditMode(couponToEdit!);
        }
        return cubit;
      },
      child: _AddCouponPageView(couponToEdit: couponToEdit),
    );
  }
}

class _AddCouponPageView extends StatefulWidget {
  final CouponEntity? couponToEdit;

  const _AddCouponPageView({this.couponToEdit});

  @override
  State<_AddCouponPageView> createState() => _AddCouponPageViewState();
}

class _AddCouponPageViewState extends State<_AddCouponPageView> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController(); // This is the Code
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _minOrderController = TextEditingController();
  final TextEditingController _usageLimitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.couponToEdit != null) {
      _initEditMode();
    }
  }

  void _initEditMode() {
    final coupon = widget.couponToEdit!;
    _nameController.text = coupon.name;
    if ((coupon.percentage ?? 0) > 0) {
      _amountController.text = coupon.percentage.toString();
    } else {
      _amountController.text = (coupon.amount ?? 0).toString();
    }
    _minOrderController.text = coupon.minOrderValue.toString();
    _usageLimitController.text = coupon.usageLimit.toString();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null) {
      context.read<AddCouponCubit>().setPickedImage(result.files.first);
    }
  }

  Future<void> _selectProducts() async {
    final cubitState = context.read<AddCouponCubit>().state;
    final selectedIds = await showDialog<List<String>>(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: BlocProvider.of<ProductBloc>(context),
        child: ProductSelectionDialog(
          potentiallySelectedIds: cubitState.applicableProductIds,
        ),
      ),
    );

    if (selectedIds != null) {
      context.read<AddCouponCubit>().setApplicableProducts(selectedIds);
    }
  }

  Future<void> _pickDate() async {
    final cubitState = context.read<AddCouponCubit>().state;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: cubitState.expiryDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      context.read<AddCouponCubit>().setExpiryDate(pickedDate);
    }
  }

  Future<void> _saveOffer() async {
    final cubitState = context.read<AddCouponCubit>().state;
    if (_formKey.currentState!.validate() && cubitState.expiryDate != null) {
      context.read<AddCouponCubit>().setLoading(true);

      // Upload Image
      String imageUrl = cubitState.existingImageUrl ?? '';
      if (cubitState.pickedImage != null) {
        if (cubitState.pickedImage!.bytes == null) {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error: Image data is corrupted or empty.')));
           context.read<AddCouponCubit>().setLoading(false);
           return;
        }

        try {
          imageUrl = await ImageUploadService().uploadBytes(cubitState.pickedImage!.bytes!, cubitState.pickedImage!.name);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image Upload Failed: $e')));
          context.read<AddCouponCubit>().setLoading(false);
          return;
        }
      }

      // Parse Values
      final double value = double.tryParse(_amountController.text) ?? 0;
      final double percentage = cubitState.discountType == 'Percentage' ? value : 0;
      final double amount = cubitState.discountType == 'Fixed Amount' ? value : 0;
      final double minOrder = double.tryParse(_minOrderController.text) ?? 0;
      final int usageLimit = int.tryParse(_usageLimitController.text) ?? 0;

      final newCoupon = CouponEntity(
        id: widget.couponToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        amount: amount,
        percentage: percentage,
        minOrderValue: minOrder,
        imageurl: imageUrl,
        usageLimit: usageLimit,
        isActive: cubitState.isActive,
        expiryDate: cubitState.expiryDate!,
        applicableProductIds: cubitState.applicableProductIds,
      );

      if (widget.couponToEdit != null) {
        context.read<CouponBloc>().add(UpdatingCouponsEvent(newCoupon));
      } else {
        context.read<CouponBloc>().add(AddingCouponsEvent(newCoupon));
      }

      Navigator.pop(context);
    } else if (cubitState.expiryDate == null) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select an expiry date')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddCouponCubit, AddCouponState>(
      builder: (context, couponState) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: Responsive.isDesktop(context) ? 800 : 400,
            height: 600,
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column: Inputs
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.couponToEdit != null ? 'Edit Offer' : 'Add New Offer',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.blackHeading,
                            ),
                          ),
                          24.h,
                          
                          // Offer Name / Code
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Offer Name / Code (e.g., SUMMER50)',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              prefixIcon: const Icon(Icons.confirmation_number_outlined),
                            ),
                            validator: (v) => v!.isEmpty ? 'Required' : null,
                          ),
                          16.h,

                          // Discount Type
                          DropdownButtonFormField<String>(
                            value: couponState.discountType,
                            decoration: InputDecoration(
                              labelText: 'Discount Type',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            items: ['Percentage', 'Fixed Amount']
                                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: (v) => context.read<AddCouponCubit>().setDiscountType(v!),
                          ),
                          16.h,

                          // Amount / Percentage
                          TextFormField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: couponState.discountType == 'Percentage' ? 'Percentage Value (%)' : 'Amount Value (₹)',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              prefixIcon: Icon(
                                 couponState.discountType == 'Percentage' ? Icons.percent : Icons.currency_rupee, 
                                 size: 20
                              ),
                            ),
                            validator: (v) {
                              if (v!.isEmpty) return 'Required';
                              if (couponState.discountType == 'Percentage' && (double.tryParse(v)! > 100)) {
                                return 'Percentage cannot exceed 100';
                              }
                              return null;
                            },
                          ),
                          16.h,

                          // Min Order Value
                          TextFormField(
                            controller: _minOrderController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Minimum Order Value',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              prefixIcon: const Icon(Icons.currency_rupee, size: 20),
                            ),
                            validator: (v) => v!.isEmpty ? 'Required' : null,
                          ),
                          16.h,
                          
                           // Usage Limit
                          TextFormField(
                            controller: _usageLimitController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Usage Limit',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              prefixIcon: const Icon(Icons.repeat),
                            ),
                            validator: (v) => v!.isEmpty ? 'Required' : null,
                          ),
                          16.h,

                          // Expiry Date
                          InkWell(
                            onTap: _pickDate,
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Expiry Date',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                prefixIcon: const Icon(Icons.calendar_today),
                              ),
                              child: Text(
                                couponState.expiryDate == null 
                                    ? 'Select Date' 
                                    : '${couponState.expiryDate!.day}/${couponState.expiryDate!.month}/${couponState.expiryDate!.year}',
                                style: TextStyle(color: couponState.expiryDate == null ? Colors.grey : Colors.black),
                              ),
                            ),
                          ),
                          16.h,

                          // Status
                          Row(
                            children: [
                              const Text('Active Status'),
                              const Spacer(),
                              Switch(
                                value: couponState.isActive, 
                                onChanged: (v) => context.read<AddCouponCubit>().setActive(v),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  24.w,
                  
                  // Right Column: Image & Product Select & Actions
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        // Image Upload
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: couponState.pickedImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.memory(couponState.pickedImage!.bytes!, fit: BoxFit.cover),
                                  )
                                : couponState.existingImageUrl != null && couponState.existingImageUrl!.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: ShimmerImage(
                                          imageUrl: couponState.existingImageUrl!,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey.shade400),
                                          Text('Upload Image', style: GoogleFonts.poppins(color: Colors.grey)),
                                        ],
                                      ),
                          ),
                        ),
                        16.h,

                        // Select Products
                        OutlinedButton.icon(
                          onPressed: _selectProducts,
                          icon: const Icon(Icons.inventory_2_outlined),
                          label: Text(couponState.applicableProductIds.isEmpty 
                              ? 'Select Applicable Products' 
                              : 'Selected (${couponState.applicableProductIds.length}) Products'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        
                        const Spacer(),
                        
                        // Save Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            16.w,
                            ElevatedButton(
                              onPressed: couponState.isLoading ? null : _saveOffer,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.darkBlue,
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: couponState.isLoading 
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : Text(
                                      widget.couponToEdit != null ? 'Update' : 'Save',
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}