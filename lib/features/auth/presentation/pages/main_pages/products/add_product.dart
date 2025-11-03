import 'package:flutter/material.dart';
import 'package:rizqmartadmin/features/auth/data/model/add_product_model.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/products/product_adding_section.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/page_decoration/base_container_decoration.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/page_decoration/respnsive_page.dart';

class AddProduct extends StatefulWidget {
  final ProductModel? model;
  const AddProduct({super.key,this.model});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
 
  

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final double fontSize;
    final EdgeInsets padding;

    if (Responsive.isDesktop(context)) {
      fontSize = 28;
      padding = const EdgeInsets.symmetric(horizontal: 120, vertical: 40);
    } else if (Responsive.isTablet(context)) {
      fontSize = 22;
      padding = const EdgeInsets.symmetric(horizontal: 48, vertical: 24);
    } else {
      fontSize = 18;
      padding = const EdgeInsets.all(16);
    }

    return Scaffold(
      body: Container(
        decoration: first_container_decoration(),
        width: double.infinity,
        padding: padding,
        child: SingleChildScrollView(
          child: FormProducts(model: widget.model,),
        ),
      ),
    );
  }
}



 