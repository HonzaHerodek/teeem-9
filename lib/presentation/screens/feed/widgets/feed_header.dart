import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/models/traits/trait_type_model.dart';
import '../../../widgets/notifications/notification_icon.dart';
import '../controllers/feed_header_controller.dart';
import '../feed_bloc/feed_bloc.dart';
import '../feed_bloc/feed_event.dart';
import '../models/filter_type.dart';
import 'feed_search_bar.dart';
import 'filter_chips.dart';
import 'target_icon.dart';

class TraitTypeChip extends StatelessWidget {
  final TraitTypeModel traitType;
  final String selectedValue;
  final bool isSelected;
  final VoidCallback onTap;

  const TraitTypeChip({
    super.key,
    required this.traitType,
    required this.selectedValue,
    required this.isSelected,
    required this.onTap,
  });

  IconData? _parseIconData(String iconData) {
    try {
      final codePoint = int.parse(iconData, radix: 16);
      return IconData(codePoint, fontFamily: 'MaterialIcons');
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected 
              ? Colors.white.withOpacity(0.2)
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Icon(
                  _parseIconData(traitType.iconData) ?? Icons.star,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  selectedValue,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeedHeader extends StatelessWidget {
  final FeedHeaderController headerController;

  const FeedHeader({
    super.key,
    required this.headerController,
  });

  void _handleSearch(BuildContext context, String query) {
    context.read<FeedBloc>().add(FeedSearchChanged(query));
  }

  Widget _buildSearchBar(BuildContext context) {
    if (!headerController.state.isSearchVisible || 
        headerController.state.activeFilterType == null) {
      return const SizedBox.shrink();
    }

    return FeedSearchBar(
      key: ValueKey(headerController.state.activeFilterType),
      filterType: headerController.state.activeFilterType!,
      onSearch: (query) => _handleSearch(context, query),
      onClose: headerController.closeSearch,
    );
  }

  Widget _buildTraitChips() {
    if (!headerController.state.isSearchVisible || 
        headerController.state.selectedCategory == null) {
      return const SizedBox.shrink();
    }

    final filteredTraitTypes = headerController.traitTypes
        .where((t) => t.category == headerController.state.selectedCategory)
        .toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 16),
          ...filteredTraitTypes.map((TraitTypeModel traitType) {
            final String selectedValue = traitType.possibleValues.first; // Default to first value
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TraitTypeChip(
                traitType: traitType,
                selectedValue: selectedValue,
                isSelected: traitType == headerController.state.selectedTraitType,
                onTap: () => headerController.selectTraitType(traitType),
              ),
            );
          }).toList(),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    if (!headerController.state.isSearchVisible || 
        headerController.state.activeFilterType == null) {
      return const SizedBox.shrink();
    }

    return FilterChipGroup(
      filterTypes: FilterType.values.where((t) => t != FilterType.none).toList(),
      selectedFilter: headerController.state.activeFilterType!,
      onFilterSelected: headerController.selectFilter,
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Material(
      type: MaterialType.transparency,
      elevation: 0,
      child: Container(
        padding: EdgeInsets.only(top: topPadding),
        child: ListenableBuilder(
          listenable: headerController,
          builder: (context, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header row with buttons and search bar
                SizedBox(
                  height: 64,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left Column: Notifications
                      SizedBox(
                        width: 56,
                        child: Center(
                          child: NotificationIcon(
                            notificationCount: 0,
                            onTap: headerController.toggleNotificationMenu,
                            isActive: headerController.state.isNotificationMenuOpen,
                          ),
                        ),
                      ),
                      
                      // Center Column: Search Bar
                      Expanded(
                        child: Center(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SizeTransition(
                                  sizeFactor: animation,
                                  axis: Axis.horizontal,
                                  child: child,
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: _buildSearchBar(context),
                            ),
                          ),
                        ),
                      ),
                      
                      // Right Column: Target Icon
                      SizedBox(
                        width: 56,
                        child: Center(
                          child: TargetIcon(
                            key: headerController.targetIconKey,
                            onTap: headerController.toggleSearch,
                            isActive: headerController.state.isSearchVisible,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Chips below header
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SizeTransition(
                        sizeFactor: animation,
                        axisAlignment: -1.0,
                        axis: Axis.vertical,
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // First row - Trait chips
                      SizedBox(
                        height: 40,
                        child: _buildTraitChips(),
                      ),
                      const SizedBox(height: 8), // Spacing between rows
                      // Second row - Filter chips
                      SizedBox(
                        height: 40,
                        child: _buildFilterChips(),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
