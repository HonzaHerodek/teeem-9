import 'package:flutter/material.dart';

class AnimatedPostContent extends StatefulWidget {
  final Widget child;
  final bool isVisible;
  final bool isAnimatingOut;
  final double topOffset;
  final double headerHeight;
  final Animation<double> headerAnimation;
  final VoidCallback? onAnimationComplete;

  const AnimatedPostContent({
    super.key,
    required this.child,
    required this.isVisible,
    required this.topOffset,
    required this.headerHeight,
    required this.headerAnimation,
    this.isAnimatingOut = false,
    this.onAnimationComplete,
  });

  @override
  State<AnimatedPostContent> createState() => _AnimatedPostContentState();
}

class _AnimatedPostContentState extends State<AnimatedPostContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));

    if (widget.isVisible && !widget.isAnimatingOut) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(AnimatedPostContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _controller.forward().then((_) {
        widget.onAnimationComplete?.call();
      });
    } else if (!widget.isVisible && oldWidget.isVisible) {
      _controller.reverse().then((_) {
        widget.onAnimationComplete?.call();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.headerAnimation,
      builder: (context, child) {
        // Calculate the content offset based on header height and animation value
        final contentOffset = widget.headerHeight * widget.headerAnimation.value;
        
        // Calculate opacity - fade out faster during expansion
        final opacity = widget.isAnimatingOut
            ? (1.0 - widget.headerAnimation.value * 2.5).clamp(0.0, 1.0) // Fade out quickly during expansion
            : (widget.headerAnimation.value < 0.4 
                ? 1.0 // Keep fully visible until header is 40% expanded
                : (1.0 - ((widget.headerAnimation.value - 0.4) * 1.67))).clamp(0.0, 1.0); // Then fade out

        return LayoutBuilder(
          builder: (context, constraints) {
            final availableHeight = constraints.maxHeight - widget.topOffset;
            
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: EdgeInsets.only(
                top: widget.topOffset,
                bottom: 16,
              ),
              child: Transform.translate(
                offset: Offset(0, contentOffset),
                child: Opacity(
                  opacity: opacity,
                  child: SizedBox(
                    height: availableHeight,
                    child: Center(child: widget.child),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
