// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

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
            style: const TextStyle(fontSize: 12, color: Colors.grey),
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
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_a_photo, size: 32, color: Colors.grey),
                    const SizedBox(height: 4),
                    Text(
                      'Add Image',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          
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
                              color: Colors.blue.shade300,
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              imageUrls[index],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.shade200,
                                  child: const Icon(Icons.error, color: Colors.red),
                                );
                              },
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
                                color: Colors.red,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(Icons.close, color: Colors.white, size: 16),
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
