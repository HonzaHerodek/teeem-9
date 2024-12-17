import 'package:flutter/material.dart';
import '../models/filter_type.dart';

class FilterMenuController extends ChangeNotifier {
  bool _isOpen = false;
  bool _isSearchVisible = false;
  FilterType? _activeFilterType;
  OverlayEntry? _overlayEntry;

  bool get isOpen => _isOpen;
  bool get isSearchVisible => _isSearchVisible;
  FilterType? get activeFilterType => _activeFilterType;
  bool get isActive => _isOpen || _isSearchVisible;

  void toggleMenu() {
    _isOpen = !_isOpen;
    if (!_isOpen && !_isSearchVisible) {
      _activeFilterType = null;
    }
    notifyListeners();
  }

  void selectFilter(FilterType type) {
    _isOpen = false;
    _activeFilterType = type;
    _isSearchVisible = true;
    _removeOverlay();
    notifyListeners();
  }

  void closeSearch() {
    _activeFilterType = null;
    _isSearchVisible = false;
    notifyListeners();
  }

  void setOverlay(OverlayEntry entry) {
    _removeOverlay();
    _overlayEntry = entry;
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }
}
