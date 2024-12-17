import 'package:flutter/material.dart';
import '../constants/post_widget_constants.dart';

mixin ExpandableContentMixin<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T> {
  AnimationController? _controller;
  bool isExpanded = false;
  double _dragStartY = 0;
  bool _isDragging = false;
  static const double _maxDragDistance = 200.0;

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
    _isDragging = true;
    _dragStartY = details.globalPosition.dy;
  }

  void handleVerticalDragUpdate(DragUpdateDetails details, {
    required Function() onExpand,
    required Function() onCollapse,
  }) {
    if (!_isDragging) return;

    final currentY = details.globalPosition.dy;
    final delta = currentY - _dragStartY;
    
    if (isExpanded) {
      // When expanded, negative delta means dragging up
      final dragPercentage = (-delta / _maxDragDistance).clamp(0.0, 1.0);
      final newValue = 1.0 - dragPercentage;
      controller.value = newValue;
      
      // Trigger collapse if we've dragged far enough
      if (newValue <= 0.2) {
        onCollapse();
      }
    } else {
      // When collapsed, negative delta means dragging up
      final dragPercentage = (-delta / _maxDragDistance).clamp(0.0, 1.0);
      controller.value = dragPercentage;
      
      // Trigger expand if we've dragged far enough
      if (dragPercentage >= 0.8) {
        onExpand();
      }
    }
  }

  void handleVerticalDragEnd(DragEndDetails details) {
    if (!_isDragging) return;
    
    _isDragging = false;
    
    // Determine whether to complete or revert the animation based on current value
    if (isExpanded) {
      if (controller.value < 0.5) {
        controller.animateTo(0.0);
        isExpanded = false;
      } else {
        controller.animateTo(1.0);
      }
    } else {
      if (controller.value > 0.5) {
        controller.animateTo(1.0);
        isExpanded = true;
      } else {
        controller.animateTo(0.0);
      }
    }
  }

  void handleVerticalDragCancel() {
    _isDragging = false;
    // Animate back to the nearest state
    if (controller.value > 0.5) {
      controller.animateTo(1.0);
    } else {
      controller.animateTo(0.0);
    }
  }

  void initializeExpandableContent({
    bool startExpanded = false,
    Function(double)? onAnimationChanged,
  }) {
    isExpanded = startExpanded;
    controller.value = startExpanded ? 1.0 : 0.0;

    if (onAnimationChanged != null) {
      controller.addListener(() {
        onAnimationChanged(controller.value);
      });
    }
  }

  void updateExpandedState(bool expanded) {
    if (isExpanded != expanded) {
      isExpanded = expanded;
      if (expanded) {
        controller.animateTo(1.0);
      } else {
        controller.animateTo(0.0);
      }
    }
  }

  void toggleExpanded({
    required Function(bool) onExpandChanged,
    Function(double)? onAnimationChanged,
  }) {
    final newExpanded = !isExpanded;
    setState(() {
      isExpanded = newExpanded;
      if (newExpanded) {
        controller.forward();
      } else {
        controller.reverse();
      }
      onExpandChanged(newExpanded);
    });
  }
}
