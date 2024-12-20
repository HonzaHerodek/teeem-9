import 'package:flutter/material.dart';

enum FilterType {
  none,
  following,
  similar,
  responded,
  followers,
  recentlyActive,
  topCreators,
  recommended,
  newUsers,
  traits;

  String get displayName {
    switch (this) {
      case FilterType.following:
        return 'I follow';
      case FilterType.similar:
        return 'Similar to me';
      case FilterType.responded:
        return 'I responded to';
      case FilterType.followers:
        return 'My followers';
      case FilterType.recentlyActive:
        return 'Recently active';
      case FilterType.topCreators:
        return 'Top creators';
      case FilterType.recommended:
        return 'Recommended';
      case FilterType.newUsers:
        return 'New users';
      case FilterType.traits:
        return 'Traits';
      case FilterType.none:
        return 'None';
    }
  }

  String get searchPlaceholder {
    switch (this) {
      case FilterType.following:
        return 'Search people you follow...';
      case FilterType.similar:
        return 'Search similar profiles...';
      case FilterType.responded:
        return 'Search posts you responded to...';
      case FilterType.followers:
        return 'Search your followers...';
      case FilterType.recentlyActive:
        return 'Search recently active users...';
      case FilterType.topCreators:
        return 'Search top creators...';
      case FilterType.recommended:
        return 'Search recommended users...';
      case FilterType.newUsers:
        return 'Search new users...';
      case FilterType.traits:
        return 'Search by traits...';
      case FilterType.none:
        return 'Search...';
    }
  }

  IconData get icon {
    switch (this) {
      case FilterType.following:
        return Icons.people_outline;
      case FilterType.similar:
        return Icons.person_search;
      case FilterType.responded:
        return Icons.comment_outlined;
      case FilterType.followers:
        return Icons.group_outlined;
      case FilterType.recentlyActive:
        return Icons.access_time;
      case FilterType.topCreators:
        return Icons.star_outline;
      case FilterType.recommended:
        return Icons.recommend;
      case FilterType.newUsers:
        return Icons.person_add_outlined;
      case FilterType.traits:
        return Icons.psychology;
      case FilterType.none:
        return Icons.search;
    }
  }
}
