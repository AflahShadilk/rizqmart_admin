import 'package:flutter/material.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:rizqmartadmin/features/presentation/widgets/texts/icon_name.dart';

/// The side panel branding header for the Desktop login screen.
class LoginSidePanel extends StatelessWidget {
  const LoginSidePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withValues(alpha: 0.08),
            colorScheme.primary.withValues(alpha: 0.03),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const IconRizq(),
          12.h,
          const RizqMartName(),
          32.h,
          _LoginSideFeatureItem(
            assetPath: 'assets/icons_and_images/leeficon.png',
            text: 'Organic Groceries',
          ),
          Divider(color: colorScheme.outline.withValues(alpha: 0.2)),
          _LoginSideFeatureItem(
            assetPath: 'assets/icons_and_images/chickenicon.png',
            text: 'Foods and vegetables',
          ),
          Divider(color: colorScheme.outline.withValues(alpha: 0.2)),
          _LoginSideFeatureItem(
            assetPath: 'assets/icons_and_images/deliveryIcon.png',
            text: 'Fast Delivery',
          ),
          Divider(color: colorScheme.outline.withValues(alpha: 0.2)),
          _LoginSideFeatureItem(
            assetPath: 'assets/icons_and_images/refundicon.png',
            text: 'Easy Refund & Return',
          ),
          Divider(color: colorScheme.outline.withValues(alpha: 0.2)),
          _LoginSideFeatureItem(
            assetPath: 'assets/icons_and_images/secureicon.png',
            text: 'Secure & Safe',
          ),
        ],
      ),
    );
  }
}

class _LoginSideFeatureItem extends StatelessWidget {
  final String assetPath;
  final String text;

  const _LoginSideFeatureItem({
    required this.assetPath,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Image.asset(assetPath, height: 28),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            softWrap: true,
            overflow: TextOverflow.visible,
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ],
    );
  }
}
