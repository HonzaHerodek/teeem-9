import 'package:flutter/material.dart';
import '../../models/filter_type.dart';
import '../profile_miniature_chip.dart';
import '../../controllers/feed_header_controller.dart';

class FeedHeaderProfilesSection extends StatelessWidget {
  final FeedHeaderController headerController;

  const FeedHeaderProfilesSection({
    super.key,
    required this.headerController,
  });

  @override
  Widget build(BuildContext context) {
    if (!headerController.state.isSearchVisible) {
      return const SizedBox.shrink();
    }

    // Map profile types to their corresponding filter types
    final profileFilters = [
      FilterType.following,
      FilterType.similar,
      FilterType.responded,
      FilterType.followers,
      FilterType.recentlyActive,
      FilterType.topCreators,
      FilterType.recommended,
      FilterType.newUsers,
    ];

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: profileFilters.length,
      itemBuilder: (context, index) {
        final filterType = profileFilters[index];
        return ProfileMiniatureChip(
          label: filterType.displayName,
          onTap: () {
            headerController.selectFilter(filterType);
          },
          isSelected: headerController.state.activeFilterType == filterType,
          spacing: 20, // Increased spacing between chips
        );
      },
    );
  }
}
