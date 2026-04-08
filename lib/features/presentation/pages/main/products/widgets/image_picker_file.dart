

import 'package:rizqmartadmin/core/theme/appcolor.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:rizqmartadmin/features/presentation/widgets/image/empty_image_placeholder.dart';
import 'package:rizqmartadmin/features/presentation/widgets/image/shimmer_image.dart';


Widget imageAddingSection({
  required List<bool> isUploading,
  required List<String> imageUrls,
  required void Function(int) onPickImage,
  required void Function(int) onRemoveImage,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Optional: Show image count
      if (imageUrls.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            'Images: ${imageUrls.where((e) => e.isNotEmpty).length}/${imageUrls.length}',
            style: const TextStyle(fontSize: 12, color: AppColors.grey),
          ),
        ),

      Row(
        children: [
          // Add Image Button
          GestureDetector(
            onTap: () {
          
              int index = imageUrls.indexWhere((url) => url.isEmpty);
              if (index == -1) {
                imageUrls.add('');
                isUploading.add(false);
                index = imageUrls.length - 1;
              }
              onPickImage(index);
            },
            child: const EmptyImagePlaceholder(
              width: 120,
              height: 120,
              iconSize: 32,
              icon: Icons.add_a_photo,
              text: 'Add Image',
              type: PlaceholderType.product,
            ),
          ),

          16.w,

          
          Expanded(
            child: SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  final hasImage = imageUrls[index].isNotEmpty;

                  if (!hasImage) return const SizedBox.shrink();

                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.matBlue.shade300,
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: ShimmerImage(
                              imageUrl: imageUrls[index],
                              width: 100,
                              height: 100,
                              borderRadius: 6,
                            ),
                          ),
                        ),
                        // Delete Button
                        Positioned(
                          top: -8,
                          right: -8,
                          child: GestureDetector(
                            onTap: () => onRemoveImage(index),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.matRed,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.black.withValues(alpha: 0.3),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(Icons.close, color: AppColors.white, size: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
