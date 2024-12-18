import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../../data/models/traits/trait_type_model.dart';
import '../../../../domain/repositories/trait_repository.dart';
import '../models/filter_type.dart';

class FeedHeaderState {
  final bool isSearchVisible;
  final bool isNotificationMenuOpen;
  final bool isFilterMenuOpen;
  final FilterType? activeFilterType;
  final String? selectedCategory;
  final TraitTypeModel? selectedTraitType;

  const FeedHeaderState({
    this.isSearchVisible = false,
    this.isNotificationMenuOpen = false,
    this.isFilterMenuOpen = false,
    this.activeFilterType,
    this.selectedCategory,
    this.selectedTraitType,
  });

  FeedHeaderState copyWith({
    bool? isSearchVisible,
    bool? isNotificationMenuOpen,
    bool? isFilterMenuOpen,
    FilterType? activeFilterType,
    String? selectedCategory,
    TraitTypeModel? selectedTraitType,
    bool clearFilterType = false,
    bool clearTraits = false,
  }) {
    return FeedHeaderState(
      isSearchVisible: isSearchVisible ?? this.isSearchVisible,
      isNotificationMenuOpen: isNotificationMenuOpen ?? this.isNotificationMenuOpen,
      isFilterMenuOpen: isFilterMenuOpen ?? this.isFilterMenuOpen,
      activeFilterType: clearFilterType ? null : (activeFilterType ?? this.activeFilterType),
      selectedCategory: clearTraits ? null : (selectedCategory ?? this.selectedCategory),
      selectedTraitType: clearTraits ? null : (selectedTraitType ?? this.selectedTraitType),
    );
  }
}

class FeedHeaderController extends ChangeNotifier {
  FeedHeaderState _state = const FeedHeaderState();
  FeedHeaderState get state => _state;

  // Add GlobalKey for target icon
  final GlobalKey targetIconKey = GlobalKey();

  final TraitRepository _traitRepository = GetIt.instance<TraitRepository>();
  List<TraitTypeModel> _traitTypes = [];
  List<TraitTypeModel> get traitTypes => _traitTypes;

  FeedHeaderController() {
    _loadTraitTypes();
  }

  Future<void> _loadTraitTypes() async {
    try {
      _traitTypes = await _traitRepository.getTraitTypes();
      if (_traitTypes.isNotEmpty) {
        // Set initial category when traits are loaded
        _state = _state.copyWith(
          selectedCategory: _traitTypes.first.category,
        );
      }
      notifyListeners();
    } catch (e) {
      print('Error loading trait types: $e');
    }
  }

  void toggleSearch() {
    if (_state.isSearchVisible) {
      closeSearch();
    } else {
      if (_traitTypes.isNotEmpty) {
        _state = _state.copyWith(
          isSearchVisible: true,
          activeFilterType: FilterType.group,
          selectedCategory: _traitTypes.first.category,
          isNotificationMenuOpen: false,
          isFilterMenuOpen: false,
        );
        notifyListeners();
      }
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
    final hasCategory = _traitTypes.any((t) => t.category == category);
    if (hasCategory) {
      _state = _state.copyWith(
        selectedCategory: category,
        selectedTraitType: null,
      );
      notifyListeners();
    }
  }

  void selectTraitType(TraitTypeModel traitType) {
    _state = _state.copyWith(
      selectedTraitType: traitType,
    );
    notifyListeners();
  }

  void setFilterOverlay(OverlayEntry entry) {
    // No-op as we're not using overlays in the new implementation
  }
}
