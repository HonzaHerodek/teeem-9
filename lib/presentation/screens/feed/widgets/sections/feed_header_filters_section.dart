import 'package:flutter/material.dart';
import '../../models/filter_type.dart';
import '../filter_relation_chip.dart';
import '../../controllers/feed_header_controller.dart';

class FeedHeaderFiltersSection extends StatelessWidget {
  final FeedHeaderController headerController;

  const FeedHeaderFiltersSection({
    super.key,
    required this.headerController,
  });

  @override
  Widget build(BuildContext context) {
    if (!headerController.state.isSearchVisible ||
        headerController.state.activeFilterType == null) {
      return const SizedBox.shrink();
    }

    final filterTypes = FilterType.values
        .where((type) => type != FilterType.none && type != FilterType.traits)
        .toList();

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filterTypes.length,
      itemBuilder: (context, index) {
        final filterType = filterTypes[index];
        return FilterRelationChip(
          label: filterType.displayName,
          icon: filterType.icon,
          onTap: () => headerController.selectFilter(filterType),
          isSelected: headerController.state.activeFilterType == filterType,
          spacing: 15,
        );
      },
    );
  }
}
