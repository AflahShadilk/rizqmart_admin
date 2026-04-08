import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/core/theme/appcolor.dart';

/// Types of placeholder visuals for different upload contexts.
enum PlaceholderType { product, brand, category, coupon, generic }

class EmptyImagePlaceholder extends StatelessWidget {
  final double? width;
  final double? height;
  final IconData icon;
  final String text;
  final double iconSize;
  final PlaceholderType type;

  const EmptyImagePlaceholder({
    super.key,
    this.width,
    this.height,
    this.icon = Icons.add_photo_alternate_outlined,
    this.text = 'Upload Image',
    this.iconSize = 40,
    this.type = PlaceholderType.generic,
  });

  /// Returns gradient colors, icon, and label based on the placeholder type.
  _PlaceholderTheme get _theme {
    switch (type) {
      case PlaceholderType.product:
        return const _PlaceholderTheme(
          gradientStart: AppColors.productGradientStart,
          gradientEnd: AppColors.productGradientEnd,
          iconColor: AppColors.productIconColor,
          borderColor: AppColors.productBorderColor,
          defaultIcon: Icons.shopping_bag_outlined,
          defaultText: 'Upload Product',
        );
      case PlaceholderType.brand:
        return const _PlaceholderTheme(
          gradientStart: AppColors.brandGradientStart,
          gradientEnd: AppColors.brandGradientEnd,
          iconColor: AppColors.brandIconColor,
          borderColor: AppColors.brandBorderColor,
          defaultIcon: Icons.branding_watermark_outlined,
          defaultText: 'Upload Logo',
        );
      case PlaceholderType.category:
        return const _PlaceholderTheme(
          gradientStart: AppColors.categoryGradientStart,
          gradientEnd: AppColors.categoryGradientEnd,
          iconColor: AppColors.categoryIconColor,
          borderColor: AppColors.categoryBorderColor,
          defaultIcon: Icons.category_outlined,
          defaultText: 'Upload Image',
        );
      case PlaceholderType.coupon:
        return const _PlaceholderTheme(
          gradientStart: AppColors.couponGradientStart,
          gradientEnd: AppColors.couponGradientEnd,
          iconColor: AppColors.couponIconColor,
          borderColor: AppColors.couponBorderColor,
          defaultIcon: Icons.local_offer_outlined,
          defaultText: 'Upload Banner',
        );
      case PlaceholderType.generic:
        return const _PlaceholderTheme(
          gradientStart: AppColors.genericGradientStart,
          gradientEnd: AppColors.genericGradientEnd,
          iconColor: AppColors.genericIconColor,
          borderColor: AppColors.genericBorderColor,
          defaultIcon: Icons.add_photo_alternate_outlined,
          defaultText: 'Upload Image',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = _theme;
    final displayIcon = icon != Icons.add_photo_alternate_outlined ? icon : theme.defaultIcon;
    final displayText = text != 'Upload Image' ? text : theme.defaultText;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.gradientStart, theme.gradientEnd],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: theme.borderColor,
          strokeWidth: 2.0,
          dashWidth: 6,
          dashSpace: 4,
          borderRadius: 12,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.iconColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  displayIcon,
                  size: iconSize,
                  color: theme.iconColor,
                ),
              ),
              if (displayText.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  displayText,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: theme.iconColor.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Internal theme data for placeholder types.
class _PlaceholderTheme {
  final Color gradientStart;
  final Color gradientEnd;
  final Color iconColor;
  final Color borderColor;
  final IconData defaultIcon;
  final String defaultText;

  const _PlaceholderTheme({
    required this.gradientStart,
    required this.gradientEnd,
    required this.iconColor,
    required this.borderColor,
    required this.defaultIcon,
    required this.defaultText,
  });
}

/// Paints a dashed rounded-rectangle border.
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        final end = min(distance + dashWidth, metric.length);
        final extractPath = metric.extractPath(distance, end);
        canvas.drawPath(extractPath, paint);
        distance = end + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
