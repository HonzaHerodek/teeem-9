import 'package:flutter/material.dart';

/// Defines the visual style for a profile image frame
class ProfileImageFrameStyle {
  /// The size of the frame
  final double size;

  /// Edge blur configuration
  final double borderWidth;
  final Color borderColor;
  final double borderBlur;

  /// Outer glow/shadow configuration
  final Color glowColor;
  final double glowSpread;
  final double glowBlur;
  final Offset glowOffset;

  /// Inner shadow configuration
  final Color innerShadowColor;
  final double innerShadowBlur;
  final double innerShadowSpread;
  final Offset innerShadowOffset;
  final double innerShadowOpacity;

  const ProfileImageFrameStyle({
    this.size = 40,
    this.borderWidth = 6,
    this.borderColor = Colors.white,
    this.borderBlur = 4.0,
    this.glowColor = Colors.transparent,
    this.glowSpread = 0,
    this.glowBlur = 0,
    this.glowOffset = Offset.zero,
    this.innerShadowColor = Colors.black26,
    this.innerShadowBlur = 0,
    this.innerShadowSpread = 0,
    this.innerShadowOffset = Offset.zero,
    this.innerShadowOpacity = 0.3,
  });

  /// Style for compact post collapsed state
  factory ProfileImageFrameStyle.compactCollapsed({
    required double size,
    Color borderColor = Colors.white,
  }) {
    return ProfileImageFrameStyle(
      size: size,
      borderWidth: 4,
      borderColor: borderColor.withOpacity(0.8),
      borderBlur: 3.0,
      innerShadowBlur: 2,
      innerShadowSpread: 1,
      innerShadowOffset: const Offset(0, 1),
    );
  }

  /// Style for compact post expanded state
  factory ProfileImageFrameStyle.compactExpanded({
    required double size,
    Color borderColor = Colors.white,
  }) {
    return ProfileImageFrameStyle(
      size: size,
      borderWidth: 6,
      borderColor: borderColor.withOpacity(0.85),
      borderBlur: 4.0,
      glowColor: Colors.black38,
      glowBlur: 8,
      glowSpread: 2,
      glowOffset: const Offset(0, 2),
      innerShadowBlur: 4,
      innerShadowSpread: 2,
      innerShadowOffset: const Offset(0, 2),
    );
  }

  /// Style for post header collapsed state
  factory ProfileImageFrameStyle.headerCollapsed({
    required double size,
    Color borderColor = Colors.white,
  }) {
    return ProfileImageFrameStyle(
      size: size,
      borderWidth: 4,
      borderColor: borderColor.withOpacity(0.8),
      borderBlur: 3.0,
      innerShadowBlur: 2,
      innerShadowSpread: 1,
      innerShadowOffset: const Offset(0, 1),
    );
  }

  /// Style for post header expanded state
  factory ProfileImageFrameStyle.headerExpanded({
    required double size,
    Color borderColor = Colors.white,
  }) {
    return ProfileImageFrameStyle(
      size: size,
      borderWidth: 8,
      borderColor: borderColor.withOpacity(0.9),
      borderBlur: 5.0,
      glowColor: Colors.black45,
      glowBlur: 12,
      glowSpread: 4,
      glowOffset: const Offset(0, 4),
      innerShadowBlur: 6,
      innerShadowSpread: 3,
      innerShadowOffset: const Offset(0, 3),
      innerShadowOpacity: 0.4,
    );
  }

  /// Style for profile section in sliding panel
  factory ProfileImageFrameStyle.profile({
    required double size,
    Color borderColor = Colors.white,
  }) {
    return ProfileImageFrameStyle(
      size: size,
      borderWidth: 6,
      borderColor: borderColor.withOpacity(0.85),
      borderBlur: 4.0,
      glowColor: Colors.black38,
      glowBlur: 10,
      glowSpread: 3,
      glowOffset: const Offset(0, 3),
      innerShadowBlur: 5,
      innerShadowSpread: 2,
      innerShadowOffset: const Offset(0, 2),
    );
  }

  /// Creates a copy of this style with the given fields replaced with new values
  ProfileImageFrameStyle copyWith({
    double? size,
    double? borderWidth,
    Color? borderColor,
    double? borderBlur,
    Color? glowColor,
    double? glowSpread,
    double? glowBlur,
    Offset? glowOffset,
    Color? innerShadowColor,
    double? innerShadowBlur,
    double? innerShadowSpread,
    Offset? innerShadowOffset,
    double? innerShadowOpacity,
  }) {
    return ProfileImageFrameStyle(
      size: size ?? this.size,
      borderWidth: borderWidth ?? this.borderWidth,
      borderColor: borderColor ?? this.borderColor,
      borderBlur: borderBlur ?? this.borderBlur,
      glowColor: glowColor ?? this.glowColor,
      glowSpread: glowSpread ?? this.glowSpread,
      glowBlur: glowBlur ?? this.glowBlur,
      glowOffset: glowOffset ?? this.glowOffset,
      innerShadowColor: innerShadowColor ?? this.innerShadowColor,
      innerShadowBlur: innerShadowBlur ?? this.innerShadowBlur,
      innerShadowSpread: innerShadowSpread ?? this.innerShadowSpread,
      innerShadowOffset: innerShadowOffset ?? this.innerShadowOffset,
      innerShadowOpacity: innerShadowOpacity ?? this.innerShadowOpacity,
    );
  }
}
