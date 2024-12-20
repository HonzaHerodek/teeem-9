import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../data/models/traits/trait_type_model.dart';
import '../../../../widgets/notifications/notification_bar.dart';
import '../../../../widgets/notifications/notification_icon.dart';
import '../../controllers/feed_header_controller.dart';
import '../../controllers/feed_controller.dart';
import '../../feed_bloc/feed_bloc.dart';
import '../../feed_bloc/feed_event.dart';
import '../feed_search_bar.dart';
import '../target_icon.dart';

class FeedHeaderSearchSection extends StatelessWidget {
  final FeedHeaderController headerController;
  final FeedController? feedController;

  const FeedHeaderSearchSection({
    super.key,
    required this.headerController,
    this.feedController,
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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

          // Center Column: Search Bar or Notification Bar
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
                child: headerController.state.isNotificationMenuOpen
                    ? NotificationBar(
                        key: ValueKey('notification_bar'),
                        notifications: headerController.notifications ?? [],
                        onNotificationSelected: (notification) {
                          headerController.selectNotification(
                              notification, feedController);
                        },
                        onClose: headerController.toggleNotificationMenu,
                      )
                    : Padding(
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
    );
  }
}
