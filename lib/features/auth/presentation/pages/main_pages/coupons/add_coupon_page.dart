import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/core/services/cloudinary_services.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/coupon_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/coupon_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/page_decoration/respnsive_page.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/product_selection_dialog.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/product/product_bloc.dart';

class AddCouponPage extends StatefulWidget {
  final CouponEntity? couponToEdit;

  const AddCouponPage({super.key, this.couponToEdit});

  @override
  State<AddCouponPage> createState() => _AddCouponPageState();
}

class _AddCouponPageState extends State<AddCouponPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController(); // This is the Code
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _minOrderController = TextEditingController();
  final TextEditingController _usageLimitController = TextEditingController();
  
  // State
  String _discountType = 'Percentage'; // Percentage or Fixed Amount
  DateTime? _expiryDate;
  bool _isActive = true;
  PlatformFile? _pickedImage;
  String? _existingImageUrl;
  List<String> _applicableProductIds = [];
  bool _isLoading = false;

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
    // Determine type based on data
    if ((coupon.percentage ?? 0) > 0) {
      _discountType = 'Percentage';
      _amountController.text = coupon.percentage.toString();
    } else {
      _discountType = 'Fixed Amount';
      _amountController.text = (coupon.amount ?? 0).toString();
    }
    _minOrderController.text = coupon.minOrderValue.toString();
    _usageLimitController.text = coupon.usageLimit.toString();
    _expiryDate = coupon.expiryDate;
    _isActive = coupon.isActive;
    _existingImageUrl = coupon.imageurl;
    _applicableProductIds = List.from(coupon.applicableProductIds);
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true, // Ensure bytes are loaded on Desktop
    );
    if (result != null) {
      setState(() {
        _pickedImage = result.files.first;
      });
    }
  }



  Future<void> _selectProducts() async {
    final selectedIds = await showDialog<List<String>>(
      context: context,
      builder: (context) => BlocProvider.value(
        value: BlocProvider.of<ProductBloc>(this.context),
        child: ProductSelectionDialog(
          potentiallySelectedIds: _applicableProductIds,
        ),
      ),
    );

    if (selectedIds != null) {
      setState(() {
        _applicableProductIds = selectedIds;
      });
    }
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _expiryDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _expiryDate = pickedDate;
      });
    }
  }

  Future<void> _saveOffer() async {
    if (_formKey.currentState!.validate() && _expiryDate != null) {
      setState(() => _isLoading = true);

      // Upload Image
      String imageUrl = _existingImageUrl ?? '';
      if (_pickedImage != null) {
        if (_pickedImage!.bytes == null) {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error: Image data is corrupted or empty.')));
           setState(() => _isLoading = false);
           return;
        }

        final cloudService = CloudinaryServices();
        try {
          imageUrl = await cloudService.uploadImage(_pickedImage!.bytes!, _pickedImage!.name);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image Upload Failed: $e')));
          setState(() => _isLoading = false);
          return;
        }
      }

      // Parse Values
      final double value = double.tryParse(_amountController.text) ?? 0;
      final double percentage = _discountType == 'Percentage' ? value : 0;
      final double amount = _discountType == 'Fixed Amount' ? value : 0;
      final double minOrder = double.tryParse(_minOrderController.text) ?? 0;
      final int usageLimit = int.tryParse(_usageLimitController.text) ?? 0;

      final newCoupon = CouponEntity(
        id: widget.couponToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text, // Code
        amount: amount,
        percentage: percentage,
        minOrderValue: minOrder,
        imageurl: imageUrl,
        usageLimit: usageLimit,
        isActive: _isActive,
        expiryDate: _expiryDate!,
        applicableProductIds: _applicableProductIds,
      );

      if (widget.couponToEdit != null) {
        context.read<CouponBloc>().add(UpdatingCouponsEvent(newCoupon));
      } else {
        context.read<CouponBloc>().add(AddingCouponsEvent(newCoupon));
      }

      Navigator.pop(context); // Close dialog
    } else if (_expiryDate == null) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select an expiry date')));
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        const SizedBox(height: 24),
                        
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
                        const SizedBox(height: 16),

                        // Discount Type
                        DropdownButtonFormField<String>(
                          value: _discountType,
                          decoration: InputDecoration(
                            labelText: 'Discount Type',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          items: ['Percentage', 'Fixed Amount']
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (v) => setState(() => _discountType = v!),
                        ),
                        const SizedBox(height: 16),

                        // Amount / Percentage
                        TextFormField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: _discountType == 'Percentage' ? 'Percentage Value (%)' : 'Amount Value (₹)',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            prefixIcon: Icon(
                               _discountType == 'Percentage' ? Icons.percent : Icons.currency_rupee, 
                               size: 20
                            ),
                          ),
                          validator: (v) {
                            if (v!.isEmpty) return 'Required';
                            if (_discountType == 'Percentage' && (double.tryParse(v)! > 100)) {
                              return 'Percentage cannot exceed 100';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

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
                        const SizedBox(height: 16),
                        
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
                        const SizedBox(height: 16),

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
                              _expiryDate == null 
                                  ? 'Select Date' 
                                  : '${_expiryDate!.day}/${_expiryDate!.month}/${_expiryDate!.year}',
                              style: TextStyle(color: _expiryDate == null ? Colors.grey : Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Status
                        Row(
                          children: [
                            const Text('Active Status'),
                            const Spacer(),
                            Switch(
                              value: _isActive, 
                              onChanged: (v) => setState(() => _isActive = v),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(width: 24),
                
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
                          child: _pickedImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.memory(_pickedImage!.bytes!, fit: BoxFit.cover),
                                )
                              : _existingImageUrl != null && _existingImageUrl!.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(_existingImageUrl!, fit: BoxFit.cover),
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
                      const SizedBox(height: 16),

                      // Select Products
                      OutlinedButton.icon(
                        onPressed: _selectProducts,
                        icon: const Icon(Icons.inventory_2_outlined),
                        label: Text(_applicableProductIds.isEmpty 
                            ? 'Select Applicable Products' 
                            : 'Selected (${_applicableProductIds.length}) Products'),
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
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: _isLoading ? null : _saveOffer,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.darkBlue,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: _isLoading 
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
  }
}