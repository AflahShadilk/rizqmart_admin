import 'package:flutter/material.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/products/widgets/widgets.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/image/empty_image_placeholder.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/image/shimmer_image.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';

Column imageContainer({
  required void Function()? onTap,
   String? label,
  required double? width,
  required double? height,
  bool? circular,
  required String? imageUrl,
  void Function()? onRemove,
  PlaceholderType placeholderType = PlaceholderType.generic,
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
              child: circular!
                  ? Container(
                      width: width,
                      height: height,
                      decoration: BoxDecoration(
                        color: AppColors.grey.shade100,
                        border: Border.all(color: AppColors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : imageUrl != null && imageUrl.isNotEmpty
                      ? ShimmerImage(
                          imageUrl: imageUrl,
                          width: width,
                          height: height,
                          borderRadius: 8,
                        )
                      : EmptyImagePlaceholder(
                          width: width,
                          height: height,
                          iconSize: 32,
                          icon: Icons.add_a_photo,
                          text: '',
                          type: placeholderType,
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
                      color: AppColors.red,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.close,
                      color: AppColors.white,
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
