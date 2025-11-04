// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:icons_plus/icons_plus.dart';
// import 'package:rizqmartadmin/core/services/cloudinary_services.dart';
// import 'package:rizqmartadmin/features/auth/data/model/add_product_model.dart';
// import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/brand/brand_bloc.dart';
// import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/brand/brand_state.dart';
// import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/category/category_bloc.dart';
// import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/category/category_state.dart';
// import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/products/widgets/widgets.dart';

// class ProductAdd extends StatefulWidget {
//   const ProductAdd({super.key});

//   @override
//   State<ProductAdd> createState() => _ProductAddState();
// }

// class _ProductAddState extends State<ProductAdd> {
//   ProductModel? product;
//   @override
//   Widget build(BuildContext context) {
//     final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//     final TextEditingController _productName = TextEditingController();
//     final TextEditingController _price = TextEditingController();
//     final TextEditingController _mrp = TextEditingController();
//     final TextEditingController _description = TextEditingController();
//     final TextEditingController _stockKey = TextEditingController();
//     bool _status = true;
//     String? selectedBrandId;
//     String? selectedCategoryName;
//     String? selectedCategoryId;
//     List<String> selectedVariant = ['', ''];
//     List<String> imageUrls = ["", ""];
//     List<bool> isUploading = [false, false];
//     String? productId;
//     bool isLoading = false;
//     bool isEditMode = false;
//     @override
//     void initState() {
//       super.initState();
//       isEditMode = widget.model != null;
//       if (isEditMode) {
//         editMode();
//       }
//     }

//     Future<void> editMode() async {
//       final product = widget.model!;
//       productId = product.id;
//       _productName.text = product.name;
//       _price.text = product.price.toString();
//       _mrp.text = product.mrp.toString();
//       _description.text = product.description!;
//       _stockKey.text = product.quantity.toString();
//       _status = product.status!;
//       selectedBrandId = product.brand;
//       selectedCategoryId = product.category;

//       final categoryState = context.read<CategoryBloc>().state;
//       if (categoryState is CategoryLoadedState) {
//         try {
//           final categoryObj = categoryState.cotegories.firstWhere(
//             (cat) => cat.name == product.category,
//           );
//           selectedCategoryId = categoryObj.id;
//         } catch (e) {
//           selectedCategoryId = null;
//         }
//       } else {
//         selectedCategoryId = null;
//       }
//       selectedVariant = List.from(product.variant);
//       imageUrls = List.from(product.imageUrls);
//       setState(() {});
//     }

//     Future<void> _pickImage(int imageIndex) async {
//       setState(() {
//         isUploading[imageIndex] = true;
//       });
//       try {
//         final res = await FilePicker.platform.pickFiles(
//           type: FileType.image,
//           allowMultiple: false,
//         );
//         if (res != null && res.files.isNotEmpty) {
//           final file = res.files.first;
//           final result = FilePickerResult([file]);
//           final url = await uploadToCloudinary(
//             result,
//           );
//           setState(() {
//             while (imageUrls.length <= imageIndex) {
//               imageUrls.add('');
//             }
//             imageUrls[imageIndex] = url!;
//           });
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Failed to upload image: $e')));
//       } finally {
//         setState(() {
//           isUploading[imageIndex] = false;
//         });
//       }
//     }

// // remove imge
//     void removeImage(int imageIndex) {
//       setState(() {
//         if (imageIndex < imageUrls.length) {
//           imageUrls[imageIndex] = '';
//         }
//       });
//     }

//     bool validateImage() {
//       if (imageUrls.isEmpty || imageUrls.length <= 1) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please upload at least 1 images')),
//         );
//         return false;
//       }
//       if (imageUrls[0].isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please upload 1 images')),
//         );
//         return false;
//       }
//       return true;
//     }

//     return SizedBox(
//       width: MediaQuery.of(context).size.width,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           pageHeading(isEditMode ? 'Edit Product' : 'Add New Product'),
//           const SizedBox(height: 30),
//           Drawer(
//             child:
//                 BlocBuilder<BrandBloc, BrandState>(builder: (context, state) {
//               if (state is BrandLoadingState) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (state is BrandLoadedState) {
//                 final allBrands = state.brand;
//                 return ListView.builder(
//                   itemCount: allBrands.length,
//                   itemBuilder: (context, index) {
//                     final brand = allBrands[index];
//                     return ListTile(
//                       title: Text(brand.name),
//                       onTap: () {
//                         Navigator.pop(context);
//                         // You can dispatch a brand selection event here
//                       },
//                     );
//                   },
//                 );
//               } else if (state is BrandFailureState) {
//                 return Center(child: Text('Error loading brands'));
//               }
//               return Container();
//             }),
//           )
//         ],
//       ),
//     );
//   }
// }
