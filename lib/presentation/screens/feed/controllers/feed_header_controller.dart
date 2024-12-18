import 'package:flutter/material.dart';
import '../../../../core/services/trait_service.dart';
import '../../../../data/models/trait_model.dart';
import '../models/filter_type.dart';

class FeedHeaderState {
  final bool isSearchVisible;
  final bool isNotificationMenuOpen;
  final bool isFilterMenuOpen;
  final FilterType? activeFilterType;
  final String? selectedCategory;
  final TraitModel? selectedTrait;

  const FeedHeaderState({
    this.isSearchVisible = false,
    this.isNotificationMenuOpen = false,
    this.isFilterMenuOpen = false,
    this.activeFilterType,
    this.selectedCategory,
    this.selectedTrait,
  });

  FeedHeaderState copyWith({
    bool? isSearchVisible,
    bool? isNotificationMenuOpen,
    bool? isFilterMenuOpen,
    FilterType? activeFilterType,
    String? selectedCategory,
    TraitModel? selectedTrait,
    bool clearFilterType = false,
    bool clearTraits = false,
  }) {
    return FeedHeaderState(
      isSearchVisible: isSearchVisible ?? this.isSearchVisible,
      isNotificationMenuOpen: isNotificationMenuOpen ?? this.isNotificationMenuOpen,
      isFilterMenuOpen: isFilterMenuOpen ?? this.isFilterMenuOpen,
      activeFilterType: clearFilterType ? null : (activeFilterType ?? this.activeFilterType),
      selectedCategory: clearTraits ? null : (selectedCategory ?? this.selectedCategory),
      selectedTrait: clearTraits ? null : (selectedTrait ?? this.selectedTrait),
    );
  }
}

class FeedHeaderController extends ChangeNotifier {
  FeedHeaderState _state = const FeedHeaderState();
  FeedHeaderState get state => _state;

  // Add GlobalKey for target icon
  final GlobalKey targetIconKey = GlobalKey();

  void toggleSearch() {
    if (_state.isSearchVisible) {
      closeSearch();
    } else {
      _state = _state.copyWith(
        isSearchVisible: true,
        activeFilterType: FilterType.group,
        selectedCategory: TraitService.getAvailableCategories().first,
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
      clearTraits: true,
    );
    notifyListeners();
  }

  void toggleNotificationMenu() {
    _state = _state.copyWith(
      isNotificationMenuOpen: !_state.isNotificationMenuOpen,
      isSearchVisible: false,
      isFilterMenuOpen: false,
      clearFilterType: true,
      clearTraits: true,
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

  void selectCategory(String category) {
    if (TraitService.isValidCategory(category)) {
      _state = _state.copyWith(
        selectedCategory: category,
        selectedTrait: null,
      );
      notifyListeners();
    }
  }

  void selectTrait(TraitModel trait) {
    _state = _state.copyWith(
      selectedTrait: trait,
    );
    notifyListeners();
  }

  void setFilterOverlay(OverlayEntry entry) {
    // No-op as we're not using overlays in the new implementation
  }
}
