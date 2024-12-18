import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../widgets/notifications/notification_icon.dart';
import '../controllers/feed_header_controller.dart';
import '../feed_bloc/feed_bloc.dart';
import '../feed_bloc/feed_event.dart';
import 'feed_search_bar.dart';
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
    if (_controller.state.isSearchVisible && _controller.state.activeFilterType != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: FeedSearchBar(
          key: ValueKey(_controller.state.activeFilterType),
          filterType: _controller.state.activeFilterType!,
          onSearch: _handleSearch,
          onClose: _controller.closeSearch,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    const headerHeight = 64.0;

    return Material(
      type: MaterialType.transparency,
      elevation: 0,
      child: SizedBox(
        height: headerHeight + topPadding,
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            return Stack(
              fit: StackFit.expand,
              children: [
                // Gesture pass-through layer
                if (!_controller.state.isSearchVisible && 
                    !_controller.state.isNotificationMenuOpen)
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTapDown: (_) => _controller.closeSearch(),
                    ),
                  ),
                // Content layer
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.only(top: topPadding),
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
                              child: _buildSearchBar(),
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
