// ignore_for_file: deprecated_member_use

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/core/services/cloudinary_services.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/coupon_bloc.dart';

class AddCouponPage extends StatefulWidget {
  const AddCouponPage({super.key});

  @override
  State<AddCouponPage> createState() => _AddCouponPageState();
}

class _AddCouponPageState extends State<AddCouponPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _imageUrl;
  bool _status = true;
  bool isUploading=false;

  Future<void> _pickImage() async {
    setState(() {
      isUploading=true;
    });
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      final url = await uploadToCloudinary(result);
      setState(() {
        _imageUrl = url!;
      });
    }
    setState(() {
      isUploading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 2)
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add New Brand",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Coupon Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Enter coupon name' : null,
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
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child:isUploading?const Center(child: CircularProgressIndicator(),) : _imageUrl != null
                            ? Image.network(
                                _imageUrl!,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.add_a_photo,
                                color: Colors.grey, size: 40),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text("Upload Logo"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text("Status: "),
                Switch(
                  value: _status,
                  onChanged: (val) => setState(() => _status = val),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(
                  "Save Brand",
                  style: GoogleFonts.poppins(
                    color: AppColors.gray,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                   
                    context.read<CouponBloc>();                //add here later and colums  
                    _formKey.currentState!.reset();
                    setState(() => _imageUrl = null);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}