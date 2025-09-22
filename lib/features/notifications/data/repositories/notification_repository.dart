import 'package:client_app/core/models/notification_models.dart';
import 'package:client_app/core/services/notification_service.dart';

class NotificationRepository {
  // Get paginated notifications
  Future<NotificationResponse?> getNotifications({
    int page = 1,
    int perPage = 10,
  }) async {
    return await NotificationService.getNotifications(
      page: page,
      perPage: perPage,
    );
  }

  // Mark a specific notification as read
  Future<MarkReadResponse?> markNotificationAsRead(
    String notificationId,
  ) async {
    return await NotificationService.markNotificationAsRead(notificationId);
  }

  // Mark all notifications as read
  Future<MarkReadResponse?> markAllNotificationsAsRead() async {
    return await NotificationService.markAllNotificationsAsRead();
  }

  // Get unread notifications count
  Future<int> getUnreadNotificationsCount() async {
    return await NotificationService.getUnreadNotificationsCount();
  }

  // Get notifications by type (e.g., 'pickup_notification', 'promotional', etc.)
  Future<NotificationResponse?> getNotificationsByType({
    required String type,
    int page = 1,
    int perPage = 10,
  }) async {
    return await NotificationService.getNotificationsByType(
      type: type,
      page: page,
      perPage: perPage,
    );
  }

  // Get only unread notifications
  Future<NotificationResponse?> getUnreadNotifications({
    int page = 1,
    int perPage = 10,
  }) async {
    return await NotificationService.getUnreadNotifications(
      page: page,
      perPage: perPage,
    );
  }

  // Delete a specific notification
  Future<MarkReadResponse?> deleteNotification(String notificationId) async {
    return await NotificationService.deleteNotification(notificationId);
  }

  // Get notifications with filters
  Future<NotificationResponse?> getFilteredNotifications({
    int page = 1,
    int perPage = 10,
    String? type,
    bool? unreadOnly,
  }) async {
    if (type != null) {
      return await getNotificationsByType(
        type: type,
        page: page,
        perPage: perPage,
      );
    } else if (unreadOnly == true) {
      return await getUnreadNotifications(page: page, perPage: perPage);
    } else {
      return await getNotifications(page: page, perPage: perPage);
    }
  }

  // Batch mark notifications as read
  Future<List<MarkReadResponse?>> markMultipleNotificationsAsRead(
    List<String> notificationIds,
  ) async {
    final List<Future<MarkReadResponse?>> futures =
        notificationIds.map((id) => markNotificationAsRead(id)).toList();

    return await Future.wait(futures);
  }

  // Get notification statistics
  Future<Map<String, dynamic>> getNotificationStats() async {
    try {
      final allNotifications = await getNotifications(page: 1, perPage: 100);

      if (allNotifications != null && allNotifications.success) {
        final notifications = allNotifications.data.notifications;
        final totalCount = allNotifications.data.total;

        // Calculate unread count from notifications
        final unreadCount = notifications.where((n) => !n.isRead).length;
        final readCount = totalCount - unreadCount;

        // Count notifications by type
        final typeCount = <String, int>{};
        for (final notification in notifications) {
          typeCount[notification.type] =
              (typeCount[notification.type] ?? 0) + 1;
        }

        return {
          'total_count': totalCount,
          'unread_count': unreadCount,
          'read_count': readCount,
          'type_distribution': typeCount,
        };
      }

      return {
        'total_count': 0,
        'unread_count': 0,
        'read_count': 0,
        'type_distribution': <String, int>{},
      };
    } catch (e) {
      print('Error getting notification stats: $e');
      return {
        'total_count': 0,
        'unread_count': 0,
        'read_count': 0,
        'type_distribution': <String, int>{},
      };
    }
  }
}
