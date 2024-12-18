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
    switch (this) {
      case FilterType.group:
        return 'Search in groups...';
      case FilterType.pair:
        return 'Search in pairs...';
      case FilterType.self:
        return 'Search in my posts...';
      case FilterType.none:
        return 'Search...';
    }
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
