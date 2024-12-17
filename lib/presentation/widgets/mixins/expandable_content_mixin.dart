import 'package:flutter/material.dart';
import '../constants/post_widget_constants.dart';

mixin ExpandableContentMixin<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T> {
  AnimationController? _controller;
  bool isExpanded = false;
  double dragStartY = 0;
  double totalDragDistance = 0;
  static const double _dragThreshold = 50.0;

  AnimationController get controller {
    _controller ??= AnimationController(
      duration: PostWidgetConstants.animationDuration,
      vsync: this,
    );
    return _controller!;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void handleVerticalDragStart(DragStartDetails details) {
    dragStartY = details.globalPosition.dy;
    totalDragDistance = 0;
  }

  void handleVerticalDragUpdate(DragUpdateDetails details, {
    required Function() onExpand,
    required Function() onCollapse,
  }) {
    final currentY = details.globalPosition.dy;
    final delta = currentY - dragStartY;
    totalDragDistance += delta.abs();
    
    // Only trigger if there's significant vertical movement
    if (totalDragDistance > _dragThreshold) {
      if (isExpanded && delta > 0) {
        // Swiping down while expanded - collapse
        onCollapse();
        totalDragDistance = 0;
      } else if (!isExpanded && delta < 0) {
        // Swiping up while collapsed - expand
        onExpand();
        totalDragDistance = 0;
      }
    }
    
    // Update start position for next delta calculation
    dragStartY = currentY;
  }

  void initializeExpandableContent({
    bool startExpanded = false,
    Function(double)? onAnimationChanged,
  }) {
    isExpanded = startExpanded;
    if (startExpanded) {
      controller.value = 1.0;
    }

    if (onAnimationChanged != null) {
      controller.addListener(() {
        onAnimationChanged(controller.value);
      });
    }
  }

  void toggleExpanded({
    required Function(bool) onExpandChanged,
    Function(double)? onAnimationChanged,
  }) {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        controller.forward();
      } else {
        controller.reverse();
      }
      onExpandChanged(isExpanded);
    });
  }
}
