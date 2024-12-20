import 'package:flutter/material.dart';

enum FilterType {
  none,
  // Individual profile filters
  individual1,
  individual2,
  individual3,
  individual4,
  individual5,
  individual6,
  individual7,
  individual8,
  // Special relation filters
  similarToMe,
  iRespondedTo,
  iFollow,
  myFollowers,
  // Group filters
  group1,
  group2,
  group3,
  // Trait filters
  traits;

  String get displayName {
    switch (this) {
      // Individual profiles
      case FilterType.individual1:
        return 'Individual 1';
      case FilterType.individual2:
        return 'Individual 2';
      case FilterType.individual3:
        return 'Individual 3';
      case FilterType.individual4:
        return 'Individual 4';
      case FilterType.individual5:
        return 'Individual 5';
      case FilterType.individual6:
        return 'Individual 6';
      case FilterType.individual7:
        return 'Individual 7';
      case FilterType.individual8:
        return 'Individual 8';
      // Special relations  
      case FilterType.similarToMe:
        return 'Similar to me';
      case FilterType.iRespondedTo:
        return 'I responded to';
      case FilterType.iFollow:
        return 'I follow them';
      case FilterType.myFollowers:
        return 'My followers';
      // Groups
      case FilterType.group1:
        return 'Group 1';
      case FilterType.group2:
        return 'Group 2';
      case FilterType.group3:
        return 'Group 3';
      // Other
      case FilterType.traits:
        return 'Traits';
      case FilterType.none:
        return 'None';
    }
  }

  String get searchPlaceholder {
    switch (this) {
      // Individual profiles
      case FilterType.individual1:
        return 'Search individual 1...';
      case FilterType.individual2:
        return 'Search individual 2...';
      case FilterType.individual3:
        return 'Search individual 3...';
      case FilterType.individual4:
        return 'Search individual 4...';
      case FilterType.individual5:
        return 'Search individual 5...';
      case FilterType.individual6:
        return 'Search individual 6...';
      case FilterType.individual7:
        return 'Search individual 7...';
      case FilterType.individual8:
        return 'Search individual 8...';
      // Special relations
      case FilterType.similarToMe:
        return 'Search similar users...';
      case FilterType.iRespondedTo:
        return 'Search users you responded to...';
      case FilterType.iFollow:
        return 'Search users you follow...';
      case FilterType.myFollowers:
        return 'Search your followers...';
      // Groups  
      case FilterType.group1:
        return 'Search in group 1...';
      case FilterType.group2:
        return 'Search in group 2...';
      case FilterType.group3:
        return 'Search in group 3...';
      // Other
      case FilterType.traits:
        return 'Search by traits...';
      case FilterType.none:
        return 'Search...';
    }
  }

  IconData get icon {
    switch (this) {
      // Individual profiles
      case FilterType.individual1:
      case FilterType.individual2:
      case FilterType.individual3:
      case FilterType.individual4:
      case FilterType.individual5:
      case FilterType.individual6:
      case FilterType.individual7:
      case FilterType.individual8:
        return Icons.person_outline;
      // Special relations  
      case FilterType.similarToMe:
        return Icons.people_outline;
      case FilterType.iRespondedTo:
        return Icons.reply_outlined;
      case FilterType.iFollow:
        return Icons.person_add_outlined;
      case FilterType.myFollowers:
        return Icons.group_outlined;
      // Groups
      case FilterType.group1:
      case FilterType.group2:
      case FilterType.group3:
        return Icons.group_work_outlined;
      // Other  
      case FilterType.traits:
        return Icons.psychology;
      case FilterType.none:
        return Icons.search;
    }
  }
}
