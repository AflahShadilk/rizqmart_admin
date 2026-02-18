import 'package:flutter/material.dart';
import 'package:rizqmartadmin/features/auth/data/model/add_product_model.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/products/product_adding_section.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/page_decoration/base_container_decoration.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/page_decoration/respnsive_page.dart';

class AddProduct extends StatelessWidget {
  final ProductModel? model;
  const AddProduct({super.key,this.model});

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding;
    if (Responsive.isDesktop(context)) {
      padding = const EdgeInsets.symmetric(horizontal: 120, vertical: 40);
    } else if (Responsive.isTablet(context)) {
      padding = const EdgeInsets.symmetric(horizontal: 48, vertical: 24);
    } else {
      padding = const EdgeInsets.all(16);
    }

    return Scaffold(
      body: Container(
        decoration: firstcontainerdecoration(),
        width: double.infinity,
        padding: padding,
        child: SingleChildScrollView(
          child: FormProducts(model: model,),
        ),
      ),
    );
  }
}



 