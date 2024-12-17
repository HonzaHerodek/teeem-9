import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../components/filter_button.dart';
import '../components/filter_overlay.dart';
import '../controllers/filter_menu_controller.dart';
import '../models/filter_type.dart';
import '../search/filter_search_bar.dart';
import '../../../../presentation/screens/feed/feed_bloc/feed_bloc.dart';
import '../../../../presentation/screens/feed/feed_bloc/feed_event.dart';

class FilterMenu extends StatefulWidget {
  final VoidCallback onGroupFilter;
  final VoidCallback onPairFilter;
  final VoidCallback onSelfFilter;
  final ValueChanged<String>? onSearch;

  const FilterMenu({
    Key? key,
    required this.onGroupFilter,
    required this.onPairFilter,
    required this.onSelfFilter,
    this.onSearch,
  }) : super(key: key);

  @override
  State<FilterMenu> createState() => _FilterMenuState();
}

class _FilterMenuState extends State<FilterMenu> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final FilterMenuController _menuController;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _menuController = FilterMenuController();
    _menuController.addListener(_handleMenuStateChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _menuController.dispose();
    super.dispose();
  }

  void _handleMenuStateChanged() {
    if (_menuController.isOpen) {
      _showOverlay();
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _handleFilterSelected(FilterType type) {
    switch (type) {
      case FilterType.group:
        widget.onGroupFilter();
        break;
      case FilterType.pair:
        widget.onPairFilter();
        break;
      case FilterType.self:
        widget.onSelfFilter();
        break;
      case FilterType.none:
        break;
    }
    _menuController.selectFilter(type);
    context.read<FeedBloc>().add(const FeedSearchChanged(''));
  }

  void _showOverlay() {
    final overlay = OverlayEntry(
      builder: (context) => FilterOverlay(
        layerLink: _layerLink,
        animation: _controller,
        onFilterSelected: _handleFilterSelected,
        onDismiss: _menuController.toggleMenu,
      ),
    );
    _menuController.setOverlay(overlay);
    Overlay.of(context).insert(overlay);
  }

  void _handleSearch(String query) {
    if (widget.onSearch != null) {
      widget.onSearch!(query);
    }
  }

  void _handleSearchClose() {
    _menuController.closeSearch();
    context.read<FeedBloc>().add(const FeedSearchChanged(''));
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _menuController,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Search bar (when active)
            if (_menuController.isSearchVisible && _menuController.activeFilterType != null)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: FilterSearchBar(
                    key: ValueKey(_menuController.activeFilterType),
                    filterType: _menuController.activeFilterType!,
                    onSearch: _handleSearch,
                    onClose: _handleSearchClose,
                  ),
                ),
              ),
            
            // Filter button (always visible)
            FilterButton(
              layerLink: _layerLink,
              isActive: _menuController.isActive,
              onPressed: _menuController.toggleMenu,
            ),
          ],
        );
      },
    );
  }
}
