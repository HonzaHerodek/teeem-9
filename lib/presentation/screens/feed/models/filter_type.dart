import 'package:flutter/material.dart';

enum FilterType {
  traits,
  none;

  String get displayName {
    switch (this) {
      case FilterType.traits:
        return 'Traits';
      case FilterType.none:
        return 'None';
    }
  }

  String get searchPlaceholder {
    return 'Search by traits...';
  }

  IconData get icon {
    switch (this) {
      case FilterType.traits:
        return Icons.psychology;
      case FilterType.none:
        return Icons.search;
    }
  }
}
