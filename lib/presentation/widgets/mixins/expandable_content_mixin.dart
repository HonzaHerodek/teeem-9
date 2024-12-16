import 'package:flutter/material.dart';
import '../constants/post_widget_constants.dart';

mixin ExpandableContentMixin<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T> {
  AnimationController? _controller;
  bool isExpanded = false;
  double dragStartY = 0;

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
  }

  void handleVerticalDragUpdate(DragUpdateDetails details, {
    required Function() onExpand,
    required Function() onCollapse,
  }) {
    final deltaY = details.globalPosition.dy - dragStartY;
    if (!isExpanded && deltaY > 20) {
      onExpand();
    } else if (isExpanded && deltaY < -20) {
      onCollapse();
    }
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
