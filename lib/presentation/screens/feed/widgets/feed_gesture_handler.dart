import 'package:flutter/material.dart';

mixin FeedGestureHandler {
  void handleHorizontalDrag({
    required DragEndDetails details,
    required ScrollController scrollController,
    required double topPadding,
    required int totalItemCount,
    required BuildContext context,
  }) {
    if (details.primaryVelocity == null) return;
    
    final screenHeight = MediaQuery.of(context).size.height;
    final itemHeight = screenHeight - topPadding;
    final currentPosition = scrollController.position.pixels;
    final currentIndex = (currentPosition / itemHeight).round();

    if (details.primaryVelocity! > 0 && currentIndex > 0) {
      // Swipe right - go to previous item
      scrollController.animateTo(
        (currentIndex - 1) * itemHeight,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else if (details.primaryVelocity! < 0 && currentIndex < totalItemCount - 1) {
      // Swipe left - go to next item
      scrollController.animateTo(
        (currentIndex + 1) * itemHeight,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}
