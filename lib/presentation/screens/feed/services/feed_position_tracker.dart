import 'package:flutter/material.dart';

class FeedPosition {
  final int index;
  final double scrollOffset;
  final String? selectedItemId;
  final bool isProject;

  const FeedPosition({
    required this.index,
    required this.scrollOffset,
    this.selectedItemId,
    this.isProject = false,
  });
}

class FeedPositionTracker extends ChangeNotifier {
  FeedPosition _currentPosition = const FeedPosition(index: 0, scrollOffset: 0);
  final ScrollController scrollController;

  FeedPositionTracker({required this.scrollController}) {
    scrollController.addListener(_onScroll);
  }

  FeedPosition get currentPosition => _currentPosition;

  void _onScroll() {
    _currentPosition = FeedPosition(
      index: _currentPosition.index,
      scrollOffset: scrollController.offset,
      selectedItemId: _currentPosition.selectedItemId,
      isProject: _currentPosition.isProject,
    );
    notifyListeners();
  }

  void updatePosition({
    int? index,
    String? selectedItemId,
    bool? isProject,
  }) {
    _currentPosition = FeedPosition(
      index: index ?? _currentPosition.index,
      scrollOffset: _currentPosition.scrollOffset,
      selectedItemId: selectedItemId ?? _currentPosition.selectedItemId,
      isProject: isProject ?? _currentPosition.isProject,
    );
    notifyListeners();
  }

  void reset() {
    _currentPosition = const FeedPosition(index: 0, scrollOffset: 0);
    notifyListeners();
  }

  double _topPadding = 0;

  void setTopPadding(double padding) {
    _topPadding = padding;
  }

  Future<void> scrollToIndex(int index) async {
    // Calculate estimated position
    final estimatedItemHeight = 400.0; // Average height of a post/project
    final targetOffset = _topPadding + (index * estimatedItemHeight);
    
    // Get viewport dimensions
    final viewportHeight = scrollController.position.viewportDimension;
    final maxScroll = scrollController.position.maxScrollExtent;
    
    // Calculate position that will show item in upper portion of screen
    final adjustedOffset = targetOffset - (viewportHeight * 0.2);
    
    // Ensure we don't scroll beyond bounds
    final safeOffset = adjustedOffset.clamp(0.0, maxScroll);
    
    // Perform scroll with easing
    await scrollController.animateTo(
      safeOffset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    super.dispose();
  }
}
