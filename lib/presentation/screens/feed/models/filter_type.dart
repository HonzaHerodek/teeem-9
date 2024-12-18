import 'package:flutter/material.dart';

enum FilterType {
  group,
  pair,
  self,
  none;

  String get displayName {
    switch (this) {
      case FilterType.group:
        return 'Group';
      case FilterType.pair:
        return 'Pair';
      case FilterType.self:
        return 'Self';
      case FilterType.none:
        return 'None';
    }
  }

  String get searchPlaceholder {
    return 'Describe task, people, etc. to search';
  }

  IconData get icon {
    switch (this) {
      case FilterType.group:
        return Icons.group;
      case FilterType.pair:
        return Icons.people;
      case FilterType.self:
        return Icons.person;
      case FilterType.none:
        return Icons.search;
    }
  }
}
