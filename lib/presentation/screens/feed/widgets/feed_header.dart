import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../widgets/filtering/menu/filter_menu.dart';
import '../../../widgets/filtering/models/filter_type.dart';
import '../../../widgets/notifications/notification_icon.dart';
import '../feed_bloc/feed_bloc.dart';
import '../feed_bloc/feed_event.dart';

class FeedHeader extends StatelessWidget {
  const FeedHeader({super.key});

  void _applyFilter(BuildContext context, FilterType filterType) {
    context.read<FeedBloc>().add(FeedFilterChanged(filterType));
  }

  void _handleSearch(BuildContext context, String query) {
    context.read<FeedBloc>().add(FeedSearchChanged(query));
  }

  void _handleNotificationTap() {
    // TODO: Implement notifications handling
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64 + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 16,
        right: 16,
      ),
      child: Row(
        children: [
          // Left: Notifications
          NotificationIcon(
            notificationCount: 0,
            onTap: _handleNotificationTap,
          ),
          
          // Center and Right: Filter Menu with search
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: FilterMenu(
                onGroupFilter: () => _applyFilter(context, FilterType.group),
                onPairFilter: () => _applyFilter(context, FilterType.pair),
                onSelfFilter: () => _applyFilter(context, FilterType.self),
                onSearch: (query) => _handleSearch(context, query),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
