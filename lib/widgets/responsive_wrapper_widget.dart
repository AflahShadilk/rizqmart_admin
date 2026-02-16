import 'package:flutter/material.dart';
import 'package:responsive_display/responsive_display.dart' as rd;
import 'package:responsive_framework/responsive_framework.dart';

class ResponsiveWrapperWidget extends StatelessWidget {
  final Widget child;

  const ResponsiveWrapperWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return rd.ResponsiveConfig(
      child: ResponsiveBreakpoints.builder(
        child: Builder(
          builder: (context) {
            return MaxWidthBox(
              maxWidth: 2460, // 4K width support
              child: ClampingScrollWrapper.builder(
                context,
                child,
                dragWithMouse: true,
              ),
            );
          },
        ),
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1200, name: DESKTOP),
          const Breakpoint(start: 1201, end: double.infinity, name: '4K'),
        ],
      ),
    );
  }
}
