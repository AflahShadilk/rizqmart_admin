// ignore_for_file: use_build_context_synchronously

import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/core/services/cloudinary_services.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/image/empty_image_placeholder.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/coupon_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/coupon_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/image/shimmer_image.dart';
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
  final TextEditingController _usageLimitController = TextEditingController(text: '1');

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
    final isWide = Responsive.isDesktop(context);
    final screenSize = MediaQuery.of(context).size;

    return BlocBuilder<AddCouponCubit, AddCouponState>(
      builder: (context, couponState) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: isWide
                ? 800
                : (screenSize.width * 0.9).clamp(300.0, 500.0),
            constraints: BoxConstraints(
              maxHeight: screenSize.height * 0.85,
            ),
            padding: EdgeInsets.all(isWide ? 24 : 16),
            child: Form(
              key: _formKey,
              child: isWide
                  ? _buildDesktopLayout(couponState)
                  : _buildMobileLayout(couponState),
            ),
          ),
        );
      },
    );
  }

  // ── Desktop: side-by-side ──
  Widget _buildDesktopLayout(AddCouponState couponState) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            child: _buildFormFields(couponState),
          ),
        ),
        24.w,
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildImagePicker(couponState, 200),
              16.h,
              _buildProductSelectButton(couponState),
              const Spacer(),
              _buildActionButtons(couponState),
            ],
          ),
        ),
      ],
    );
  }

  // ── Mobile / Tablet: single column, fully scrollable ──
  Widget _buildMobileLayout(AddCouponState couponState) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormFields(couponState),
          24.h,
          _buildImagePicker(couponState, 160),
          16.h,
          _buildProductSelectButton(couponState),
          24.h,
          _buildActionButtons(couponState),
        ],
      ),
    );
  }

  // ── Shared form fields ──
  Widget _buildFormFields(AddCouponState couponState) {
    return Column(
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
        TextFormField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: couponState.discountType == 'Percentage'
                ? 'Percentage Value (%)'
                : 'Amount Value (₹)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            prefixIcon: Icon(
              couponState.discountType == 'Percentage'
                  ? Icons.percent
                  : Icons.currency_rupee,
              size: 20,
            ),
          ),
          validator: (v) {
            if (v!.isEmpty) return 'Required';
            if (couponState.discountType == 'Percentage' &&
                (double.tryParse(v)! > 100)) {
              return 'Percentage cannot exceed 100';
            }
            return null;
          },
        ),
        16.h,
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
        TextFormField(
          controller: _usageLimitController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Usage Limit',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            prefixIcon: IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () {
                int currentVal = int.tryParse(_usageLimitController.text) ?? 1;
                if (currentVal > 1) {
                  _usageLimitController.text = (currentVal - 1).toString();
                }
              },
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {
                int currentVal = int.tryParse(_usageLimitController.text) ?? 1;
                _usageLimitController.text = (currentVal + 1).toString();
              },
            ),
          ),
          textAlign: TextAlign.center,
          validator: (v) {
            if (v == null || v.isEmpty) return 'Required';
            if (int.tryParse(v) == null || int.parse(v) < 1) return 'Must be >= 1';
            return null;
          },
        ),
        16.h,
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
              style: TextStyle(
                color: couponState.expiryDate == null ? AppColors.grey : AppColors.black,
              ),
            ),
          ),
        ),
        16.h,
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
    );
  }

  // ── Image picker ──
  Widget _buildImagePicker(AddCouponState couponState, double height) {
    return GestureDetector(
      onTap: _pickImage,
      child: couponState.pickedImage != null
          ? Container(
              height: height,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(couponState.pickedImage!.bytes!, fit: BoxFit.cover),
              ),
            )
          : couponState.existingImageUrl != null &&
                  couponState.existingImageUrl!.isNotEmpty
              ? Container(
                  height: height,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ShimmerImage(
                      imageUrl: couponState.existingImageUrl!,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : EmptyImagePlaceholder(height: height, width: double.infinity, type: PlaceholderType.coupon),
    );
  }

  // ── Product select button ──
  Widget _buildProductSelectButton(AddCouponState couponState) {
    return OutlinedButton.icon(
      onPressed: _selectProducts,
      icon: const Icon(Icons.inventory_2_outlined),
      label: Text(
        couponState.applicableProductIds.isEmpty
            ? 'Select Applicable Products'
            : 'Selected (${couponState.applicableProductIds.length}) Products',
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // ── Action buttons ──
  Widget _buildActionButtons(AddCouponState couponState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ),
        8.w,
        Flexible(
          child: ElevatedButton(
            onPressed: couponState.isLoading ? null : _saveOffer,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkBlue,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: couponState.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2),
                  )
                : Text(
                    widget.couponToEdit != null ? 'Update' : 'Save',
                    style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ],
    );
  }
}
