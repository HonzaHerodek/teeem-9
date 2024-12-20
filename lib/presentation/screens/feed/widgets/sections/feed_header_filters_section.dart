import 'package:flutter/material.dart';
import '../../controllers/feed_header_controller.dart';
import '../../models/filter_type.dart';
import '../filter_relation_chip.dart';

/// A generic horizontal list section that can be reused across different filter sections.
/// This helps standardize the layout pattern and reduce code duplication while allowing
/// different types of filter chips.
class FeedHeaderFiltersSection extends StatelessWidget {
  final FeedHeaderController headerController;
  final List<Widget> children;
  final double height;
  final double spacing;
  final EdgeInsets? padding;
  final bool showDivider;
  final ScrollPhysics? physics;

  const FeedHeaderFiltersSection({
    super.key,
    required this.headerController,
    required this.children,
    this.height = 35,
    this.spacing = 15,
    this.padding,
    this.showDivider = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    if (!headerController.state.isSearchVisible) {
      return const SizedBox.shrink();
    }

    final list = SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: physics ?? const ClampingScrollPhysics(),
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
        itemCount: children.length,
        itemBuilder: (context, index) => children[index],
        separatorBuilder: (context, index) => SizedBox(width: spacing),
      ),
    );

    if (!showDivider) return list;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        list,
        const Divider(height: 1),
      ],
    );
  }

  /// Factory constructor for creating a section with filter chips
  factory FeedHeaderFiltersSection.withFilterChips({
    Key? key,
    required FeedHeaderController headerController,
    required List<FilterChipData> filters,
    double height = 35,
    double spacing = 15,
    EdgeInsets? padding,
    bool showDivider = false,
  }) {
    final children = filters.map((filter) {
      if (filter.useWhiteBackground) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: _buildFilterChip(filter, headerController),
        );
      }
      return _buildFilterChip(filter, headerController);
    }).toList();

    return FeedHeaderFiltersSection(
      key: key,
      headerController: headerController,
      height: height,
      spacing: spacing,
      padding: padding,
      showDivider: showDivider,
      children: children,
    );
  }

  static Widget _buildFilterChip(
    FilterChipData filter,
    FeedHeaderController headerController,
  ) {
    return FilterRelationChip(
      label: filter.label,
      icon: filter.icon,
      onTap: () => headerController.selectFilter(filter.filterType),
      isSelected: headerController.state.activeFilterType == filter.filterType,
      useWhiteStyle: filter.useWhiteBackground,
    );
  }
}

/// Data class to hold filter chip configuration
class FilterChipData {
  final String label;
  final IconData icon;
  final FilterType filterType;
  final bool useWhiteBackground;

  const FilterChipData({
    required this.label,
    required this.icon,
    required this.filterType,
    this.useWhiteBackground = false,
  });
}
