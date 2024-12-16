import 'package:flutter/material.dart';

class PostWidgetConstants {
  // Sizes
  static const double originalAvatarSize = 38.4;
  static const double miniatureSize = 80.0;
  static const double horizontalMargin = 8.0;
  static const double starSize = 14.0;
  static const double collapsedAvatarSize = 38.4;

  // Scales
  static const double profileAvatarScale = 0.9;
  static const double textScale = 0.6;
  static const double titleScale = 0.7;
  static const double miniatureScale = 0.5;
  static const double ratingScale = 0.6;

  // Durations
  static const Duration animationDuration = Duration(milliseconds: 300);

  // Decorations
  static BoxDecoration get circularBorderDecoration => BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(
      color: Colors.white.withOpacity(0.3),
      width: 2,
    ),
  );

  static List<BoxShadow> get defaultShadows => [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 8,
      spreadRadius: 2,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: const Color(0xFF2A1635).withOpacity(0.2),
      blurRadius: 6,
      spreadRadius: 1,
    ),
  ];

  // Gradients
  static LinearGradient get defaultGradient => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.black.withOpacity(0.7),
      Colors.black.withOpacity(0.5),
      Colors.black.withOpacity(0.7),
    ],
  );
}
