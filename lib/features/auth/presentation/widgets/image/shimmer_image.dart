import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';

/// A reusable widget that displays a network image with a shimmer loading
/// placeholder and an error fallback.
/// Uses plain Image.network (web-safe) instead of CachedNetworkImage.
class ShimmerImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;

  const ShimmerImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildShimmer(context);
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: AppColors.grey200,
            child: Icon(
              Icons.broken_image_outlined,
              size: _iconSize,
              color: AppColors.grey400,
            ),
          );
        },
      ),
    );
  }

  double get _iconSize {
    if (width != null && height != null) {
      final smaller = width! < height! ? width! : height!;
      return (smaller * 0.4).clamp(16, 40);
    }
    return 32;
  }

  Widget _buildShimmer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.grey800 : AppColors.grey300,
      highlightColor: isDark ? AppColors.grey700 : AppColors.grey100,
      child: Container(
        width: width,
        height: height,
        color: AppColors.white,
      ),
    );
  }
}
