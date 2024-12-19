import 'package:flutter/material.dart';
import '../../../../core/utils/dimming_effect.dart';
import '../../../../data/models/notification_model.dart';
import '../controllers/feed_header_controller.dart';

class DimmingManager {
  final FeedHeaderController headerController;
  final GlobalKey plusActionButtonKey;
  final Function(
      {required bool isDimmed,
      required List<GlobalKey> excludedKeys,
      required DimmingConfig config,
      Offset? source}) onDimmingUpdate;

  const DimmingManager({
    required this.headerController,
    required this.plusActionButtonKey,
    required this.onDimmingUpdate,
  });

  DimmingConfig _getConfigForNotification(NotificationModel? notification) {
    // Default config used for all cases
    const defaultConfig = DimmingConfig(
      dimmingColor: Colors.black,
      dimmingStrength: 0.7,
      glowColor: Colors.blue,
      glowSpread: 8.0,
      glowBlur: 16.0,
      glowStrength: 0.4,
    );

    if (notification == null) {
      return defaultConfig;
    }

    switch (notification.type) {
      case NotificationType.post:
        return defaultConfig.copyWith(
          excludeShape: DimmingExcludeShape.circle,
        );
      case NotificationType.project:
        return defaultConfig.copyWith(
          excludeShape: DimmingExcludeShape.rectangle,
          borderRadius: BorderRadius.circular(12),
        );
      case NotificationType.profile:
      default:
        return defaultConfig.copyWith(
          excludeShape: DimmingExcludeShape.circle,
        );
    }
  }

  List<GlobalKey> _getExcludedKeys({
    required bool isSearchVisible,
    GlobalKey? selectedItemKey,
    NotificationModel? selectedNotification,
  }) {
    final keys = [
      plusActionButtonKey,
      if (isSearchVisible) headerController.targetIconKey,
    ];

    if (selectedItemKey != null && 
        selectedNotification != null && 
        selectedItemKey.currentContext?.findRenderObject() != null) {
      keys.add(selectedItemKey);
    }

    return keys;
  }

  void updateDimming({
    required bool isProfileOpen,
    GlobalKey? selectedItemKey,
  }) {
    final RenderBox? targetBox = headerController.targetIconKey.currentContext
        ?.findRenderObject() as RenderBox?;
    final Offset? targetPosition = targetBox?.localToGlobal(Offset.zero);

    final isSearchVisible = headerController.state.isSearchVisible;
    final isNotificationMenuOpen = headerController.state.isNotificationMenuOpen;
    final selectedNotification = headerController.selectedNotification;

    onDimmingUpdate(
      isDimmed: isSearchVisible || isProfileOpen || isNotificationMenuOpen,
      excludedKeys: _getExcludedKeys(
        isSearchVisible: isSearchVisible,
        selectedItemKey: selectedItemKey,
        selectedNotification: selectedNotification,
      ),
      source: isSearchVisible && targetPosition != null
          ? targetPosition + Offset(targetBox!.size.width / 2, targetBox.size.height / 2)
          : null,
      config: _getConfigForNotification(selectedNotification),
    );
  }
}
