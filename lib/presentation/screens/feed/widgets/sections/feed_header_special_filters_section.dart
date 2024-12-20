import 'package:flutter/material.dart';
import '../../controllers/feed_header_controller.dart';
import '../../models/filter_type.dart';
import 'feed_header_filters_section.dart';

class FeedHeaderSpecialFiltersSection extends StatelessWidget {
  final FeedHeaderController headerController;

  const FeedHeaderSpecialFiltersSection({
    super.key,
    required this.headerController,
  });

  @override
  Widget build(BuildContext context) {
    final specialFilters = [
      FilterChipData(
        label: 'Similar to me',
        icon: Icons.people_outline,
        filterType: FilterType.similarToMe,
      ),
      FilterChipData(
        label: 'I responded to',
        icon: Icons.reply_outlined,
        filterType: FilterType.iRespondedTo,
      ),
      FilterChipData(
        label: 'I follow them',
        icon: Icons.person_add_outlined,
        filterType: FilterType.iFollow,
      ),
      FilterChipData(
        label: 'My followers',
        icon: Icons.group_outlined,
        filterType: FilterType.myFollowers,
        useWhiteBackground: true,
      ),
    ];

    return FeedHeaderFiltersSection.withFilterChips(
      headerController: headerController,
      filters: specialFilters,
    );
  }
}
