import 'package:flutter/material.dart';
import '../../../../data/models/notification_model.dart';
import '../../../../data/repositories/mock_notification_repository.dart';

class NotificationController extends ChangeNotifier {
  final MockNotificationRepository _repository;
  List<NotificationModel> _notifications = [];
  NotificationModel? _selectedNotification;
  final GlobalKey notificationBarKey = GlobalKey();

  NotificationController({
    MockNotificationRepository? repository,
  }) : _repository = repository ?? MockNotificationRepository() {
    _loadNotifications();
  }

  List<NotificationModel> get notifications => _notifications;
  NotificationModel? get selectedNotification => _selectedNotification;
  int get unreadCount => _repository.getUnreadCount();
  bool get hasNotifications => _notifications.isNotEmpty;

  String? get selectedItemId {
    if (_selectedNotification == null) return null;
    switch (_selectedNotification!.type) {
      case NotificationType.post:
        return _selectedNotification!.postId;
      case NotificationType.project:
        return _selectedNotification!.projectId;
      case NotificationType.profile:
        return _selectedNotification!.profileId;
    }
  }

  Future<void> _loadNotifications() async {
    try {
      _notifications = await _repository.getNotifications();
      notifyListeners();
    } catch (e) {
      print('Error loading notifications: $e');
    }
  }

  void selectNotification(NotificationModel notification) {
    _selectedNotification = notification;
    _repository.markAsRead(notification.id);
    notifyListeners();
  }

  void clearSelection() {
    _selectedNotification = null;
    notifyListeners();
  }

  bool isPostNotification(NotificationModel notification) {
    return notification.type == NotificationType.post;
  }

  bool isProjectNotification(NotificationModel notification) {
    return notification.type == NotificationType.project;
  }

  bool isProfileNotification(NotificationModel notification) {
    return notification.type == NotificationType.profile;
  }
}
