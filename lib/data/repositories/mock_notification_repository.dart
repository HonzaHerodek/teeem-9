import '../models/notification_model.dart';

class MockNotificationRepository {
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: '1',
      title: 'New comment on your post',
      type: NotificationType.post,
      postId: 'post_0',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    NotificationModel(
      id: '2',
      title: 'Someone liked your project',
      type: NotificationType.project,
      projectId: '1',  // Updated to match project ID from MockProjectRepository
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    NotificationModel(
      id: '3',
      title: 'New follower',
      type: NotificationType.profile,
      profileId: 'user1',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationModel(
      id: '4',
      title: 'Your post was featured',
      type: NotificationType.post,
      postId: 'post_1',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
  ];

  Future<List<NotificationModel>> getNotifications() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _notifications;
  }

  Future<void> markAsRead(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      // In a real implementation, this would update the database
    }
  }

  int getUnreadCount() {
    return _notifications.where((n) => !n.isRead).length;
  }
}
