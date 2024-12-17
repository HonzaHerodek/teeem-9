import 'package:flutter/material.dart';

class StepIndicatorsUtils {
  /// Centers the scroll view to a specific item
  static void centerScrollToItem({
    required ScrollController scrollController,
    required int currentStep,
    required int totalSteps,
    required double itemWidth,
    bool animate = true,
  }) {
    if (!scrollController.hasClients) return;

    final screenWidth = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width;
    final totalContentWidth = totalSteps * itemWidth;

    if (totalContentWidth <= screenWidth) {
      // If content fits the screen, center all dots
      _scrollToPosition(scrollController, 0, animate);
      return;
    }

    // If content doesn't fit, center current step
    final visibleItems = (screenWidth / itemWidth).floor();
    final halfVisibleItems = visibleItems ~/ 2;
    final maxScroll = scrollController.position.maxScrollExtent;
    
    final idealOffset = (currentStep - halfVisibleItems) * itemWidth;
    final offset = idealOffset.clamp(0.0, maxScroll);

    _scrollToPosition(scrollController, offset, animate);
  }

  static void _scrollToPosition(
    ScrollController scrollController, 
    double offset, 
    bool animate
  ) {
    if (animate) {
      scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      scrollController.jumpTo(offset);
    }
  }

  /// Creates diffused shadows for step indicators
  static List<BoxShadow> createDiffusedShadows(Color color, bool isSelected) {
    final List<BoxShadow> shadows = [
      // Base ultra-wide black shadow
      BoxShadow(
        color: Colors.black.withOpacity(0.15),
        blurRadius: 40,
        spreadRadius: 25,
      ),
      // Secondary wider black shadow
      BoxShadow(
        color: Colors.black.withOpacity(0.15),
        blurRadius: 30,
        spreadRadius: 20,
      ),
      // Core black shadow
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 20,
        spreadRadius: 15,
      ),
    ];

    if (isSelected) {
      // Multiple layered colored shadows for selected state
      shadows.addAll([
        // Outer colored glow
        BoxShadow(
          color: color.withOpacity(0.2),
          blurRadius: 50,
          spreadRadius: 30,
        ),
        // Middle colored glow
        BoxShadow(
          color: color.withOpacity(0.25),
          blurRadius: 40,
          spreadRadius: 25,
        ),
        // Inner colored glow
        BoxShadow(
          color: color.withOpacity(0.3),
          blurRadius: 30,
          spreadRadius: 20,
        ),
      ]);
    }

    return shadows;
  }
}
