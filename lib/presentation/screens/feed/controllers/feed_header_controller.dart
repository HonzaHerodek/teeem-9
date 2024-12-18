import 'package:flutter/material.dart';
import '../models/filter_type.dart';

class FeedHeaderState {
  final bool isSearchVisible;
  final bool isNotificationMenuOpen;
  final bool isFilterMenuOpen;
  final FilterType? activeFilterType;

  const FeedHeaderState({
    this.isSearchVisible = false,
    this.isNotificationMenuOpen = false,
    this.isFilterMenuOpen = false,
    this.activeFilterType,
  });

  FeedHeaderState copyWith({
    bool? isSearchVisible,
    bool? isNotificationMenuOpen,
    bool? isFilterMenuOpen,
    FilterType? activeFilterType,
    bool clearFilterType = false,
  }) {
    return FeedHeaderState(
      isSearchVisible: isSearchVisible ?? this.isSearchVisible,
      isNotificationMenuOpen: isNotificationMenuOpen ?? this.isNotificationMenuOpen,
      isFilterMenuOpen: isFilterMenuOpen ?? this.isFilterMenuOpen,
      activeFilterType: clearFilterType ? null : (activeFilterType ?? this.activeFilterType),
    );
  }
}

class FeedHeaderController extends ChangeNotifier {
  FeedHeaderState _state = const FeedHeaderState();
  FeedHeaderState get state => _state;

  void toggleSearch() {
    if (_state.isSearchVisible) {
      closeSearch();
    } else {
      _state = _state.copyWith(
        isSearchVisible: true,
        activeFilterType: FilterType.group,
        isNotificationMenuOpen: false,
        isFilterMenuOpen: false,
      );
      notifyListeners();
    }
  }

  void closeSearch() {
    _state = _state.copyWith(
      isSearchVisible: false,
      clearFilterType: true,
    );
    notifyListeners();
  }

  void toggleNotificationMenu() {
    _state = _state.copyWith(
      isNotificationMenuOpen: !_state.isNotificationMenuOpen,
      isSearchVisible: false,
      isFilterMenuOpen: false,
      clearFilterType: true,
    );
    notifyListeners();
  }

  void toggleFilterMenu() {
    _state = _state.copyWith(
      isFilterMenuOpen: !_state.isFilterMenuOpen,
      isNotificationMenuOpen: false,
    );
    notifyListeners();
  }

  void selectFilter(FilterType type) {
    _state = _state.copyWith(
      activeFilterType: type,
      isSearchVisible: true,
      isFilterMenuOpen: true,
    );
    notifyListeners();
  }

  void setFilterOverlay(OverlayEntry entry) {
    // No-op as we're not using overlays in the new implementation
  }
}
