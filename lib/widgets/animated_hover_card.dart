import 'package:flutter/material.dart';

class AnimatedHoverCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;

  const AnimatedHoverCard({
    super.key,
    required this.child,
    this.onTap,
    this.color,
    this.padding,
    this.borderRadius,
  });

  @override
  State<AnimatedHoverCard> createState() => _AnimatedHoverCardState();
}

class _AnimatedHoverCardState extends State<AnimatedHoverCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _elevationAnimation = Tween<double>(begin: 2.0, end: 8.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHoverChanged(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    if (isHovered) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHoverChanged(true),
      onExit: (_) => _onHoverChanged(false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                padding: widget.padding,
                decoration: BoxDecoration(
                  color: widget.color ?? Theme.of(context).cardTheme.color,
                  borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withValues(alpha: _isHovered ? 0.15 : 0.05),
                      blurRadius: _elevationAnimation.value * 2,
                      offset: Offset(0, _elevationAnimation.value),
                    ),
                  ],
                  border: Border.all(
                    color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: widget.child,
              ),
            );
          },
        ),
      ),
    );
  }
}
