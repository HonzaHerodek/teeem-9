import 'package:flutter/material.dart';
import '../controllers/feed_header_controller.dart';
import 'sections/feed_header_search_section.dart';
import 'sections/feed_header_traits_section.dart';
import 'sections/feed_header_profiles_section.dart';
import 'sections/feed_header_groups_section.dart';
import 'sections/feed_header_filters_section.dart';

class FeedHeader extends StatelessWidget {
  final FeedHeaderController headerController;

  const FeedHeader({
    super.key,
    required this.headerController,
  });

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
                FeedHeaderSearchSection(headerController: headerController),

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
                      // First row - Profile miniatures
                      SizedBox(
                        height: 80,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: FeedHeaderProfilesSection(
                            headerController: headerController,
                          ),
                        ),
                      ),
                      const SizedBox(height: 9), // Spacing between rows
                      // Second row - Group chips
                      SizedBox(
                        height: 80,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: FeedHeaderGroupsSection(
                            headerController: headerController,
                          ),
                        ),
                      ),
                      const SizedBox(height: 9), // Spacing between rows
                      // Third row - Relation filter chips
                      SizedBox(
                        height: 35,
                        child: FeedHeaderFiltersSection(
                          headerController: headerController,
                        ),
                      ),
                      const SizedBox(height: 9), // Spacing between rows
                      // Fourth row - Trait chips
                      SizedBox(
                        height: 35,
                        child: FeedHeaderTraitsSection(
                          headerController: headerController,
                        ),
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
