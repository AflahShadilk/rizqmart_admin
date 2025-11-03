import 'package:flutter/material.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/products/widgets/widgets.dart';

Column imageContainer({
  required void Function()? onTap,
   String? label,
  required double? width,
  required double? height,
  bool? circular,
  required String? imageUrl,
  void Function()? onRemove,
}) {
  return Column(
    
    children: [
      Align(
        alignment: Alignment.topLeft,
        child: fieldLabel(label!)),
      Align(
        alignment: Alignment.topLeft,
        child: Stack(
          children: [
            InkWell(
              onTap: onTap,
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: circular!
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : imageUrl != null && imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                          )
                        : const Icon(
                            Icons.add_a_photo,
                            color: Colors.grey,
                            size: 40,
                          ),
              ),
            ),
            // Remove button overlay
            if (imageUrl != null && imageUrl.isNotEmpty && onRemove != null)
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ],
  );
}