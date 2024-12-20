import 'package:flutter/material.dart';
import '../../models/filter_type.dart';
import '../profile_miniature_chip.dart';
import '../../controllers/feed_header_controller.dart';
import 'feed_header_filters_section.dart';

class FeedHeaderProfilesSection extends StatelessWidget {
  final FeedHeaderController headerController;

  const FeedHeaderProfilesSection({
    super.key,
    required this.headerController,
  });

  @override
  Widget build(BuildContext context) {
    // Map profile types to their corresponding filter types
    final profileFilters = [
      FilterType.individual1,
      FilterType.individual2,
      FilterType.individual3,
      FilterType.individual4,
      FilterType.individual5,
      FilterType.individual6,
      FilterType.individual7,
      FilterType.individual8,
    ];

    // Map of usernames for each individual
    final usernames = {
      FilterType.individual1: 'alex_morgan',
      FilterType.individual2: 'sophia.lee',
      FilterType.individual3: 'james_walker',
      FilterType.individual4: 'olivia_chen',
      FilterType.individual5: 'ethan_brown',
      FilterType.individual6: 'mia_patel',
      FilterType.individual7: 'lucas_kim',
      FilterType.individual8: 'emma_davis',
    };

    final profileChips = profileFilters.map((filterType) => ProfileMiniatureChip(
      label: usernames[filterType]!,
      onTap: () => headerController.selectFilter(filterType),
      isSelected: headerController.state.activeFilterType == filterType,
      spacing: 20,
    )).toList();

    // Use the reusable filter section for layout
    return FeedHeaderFiltersSection(
      headerController: headerController,
      height: 80,
      spacing: 20,
      children: profileChips,
    );
  }
}
