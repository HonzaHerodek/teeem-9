import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../widgets/notifications/notification_icon.dart';
import '../controllers/feed_header_controller.dart';
import '../feed_bloc/feed_bloc.dart';
import '../feed_bloc/feed_event.dart';
import '../models/filter_type.dart';
import 'feed_search_bar.dart';
import 'filter_chips.dart';
import 'target_icon.dart';

class FeedHeader extends StatefulWidget {
  const FeedHeader({super.key});

  @override
  State<FeedHeader> createState() => _FeedHeaderState();
}

class _FeedHeaderState extends State<FeedHeader> {
  late final FeedHeaderController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FeedHeaderController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    context.read<FeedBloc>().add(FeedSearchChanged(query));
  }

  Widget _buildSearchBar() {
    if (!_controller.state.isSearchVisible || _controller.state.activeFilterType == null) {
      return const SizedBox.shrink();
    }

    return FeedSearchBar(
      key: ValueKey(_controller.state.activeFilterType),
      filterType: _controller.state.activeFilterType!,
      onSearch: _handleSearch,
      onClose: _controller.closeSearch,
    );
  }

  Widget _buildChips() {
    if (!_controller.state.isSearchVisible || _controller.state.activeFilterType == null) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // First row - Regular chips
        SizedBox(
          height: 40,
          child: FilterChipGroup(
            filterTypes: FilterType.values.where((t) => t != FilterType.none).toList(),
            selectedFilter: _controller.state.activeFilterType!,
            onFilterSelected: _controller.selectFilter,
          ),
        ),
        const SizedBox(height: 8), // Spacing between rows
        // Second row - Circular chips
        SizedBox(
          height: 40,
          child: FilterChipGroup(
            filterTypes: FilterType.values.where((t) => t != FilterType.none).toList(),
            selectedFilter: _controller.state.activeFilterType!,
            onFilterSelected: _controller.selectFilter,
            circular: true,
          ),
        ),
      ],
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
          listenable: _controller,
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
                            onTap: _controller.toggleNotificationMenu,
                            isActive: _controller.state.isNotificationMenuOpen,
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
                              child: _buildSearchBar(),
                            ),
                          ),
                        ),
                      ),
                      
                      // Right Column: Target Icon
                      SizedBox(
                        width: 56,
                        child: Center(
                          child: TargetIcon(
                            onTap: _controller.toggleSearch,
                            isActive: _controller.state.isSearchVisible,
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
                  child: _buildChips(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
