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

  Future<void> scrollToIndex(int index) async {
    final targetOffset = index * 400.0; // Approximate height of each item
    await scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    super.dispose();
  }
}
