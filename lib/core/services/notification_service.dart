import 'package:client_app/core/models/notification_models.dart';
import 'package:client_app/core/utilities/app_endpoints.dart';
import 'package:client_app/data/remote/app_request.dart';
import 'package:client_app/data/remote/helper/app_response.dart';

class NotificationService {
  // Get notifications with pagination
  static Future<NotificationResponse?> getNotifications({
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final AppResponse response = await AppRequest.get(
        AppEndPoints.notifications,
        true, // isAuth
        queryParameters: {'page': page, 'per_page': perPage},
      );

      print('Raw response: ${response.origin}'); // Debug log

      if (response.success && response.origin != null) {
        // Use the full response JSON from origin instead of just data
        return NotificationResponse.fromJson(response.origin!);
      }
      return null;
    } catch (e) {
      print('Error fetching notifications: $e');
      return null;
    }
  }

  // Mark notification as read
  static Future<MarkReadResponse?> markNotificationAsRead(
    String notificationId,
  ) async {
    try {
      final AppResponse response = await AppRequest.patch(
        '${AppEndPoints.notifications}/$notificationId/read',
        true, // isAuth
      );

      if (response.success && response.origin != null) {
        return MarkReadResponse.fromJson(response.origin!);
      }
      return null;
    } catch (e) {
      print('Error marking notification as read: $e');
      return null;
    }
  }

  // Mark all notifications as read
  static Future<MarkReadResponse?> markAllNotificationsAsRead() async {
    try {
      final AppResponse response = await AppRequest.patch(
        '${AppEndPoints.notifications}/read-all',
        true, // isAuth
      );

      if (response.success && response.origin != null) {
        return MarkReadResponse.fromJson(response.origin!);
      }
      return null;
    } catch (e) {
      print('Error marking all notifications as read: $e');
      return null;
    }
  }

  // Get unread notifications count (calculated locally)
  static Future<int> getUnreadNotificationsCount() async {
    try {
      // Get the first page of notifications to calculate unread count
      final response = await getNotifications(page: 1, perPage: 100);

      if (response != null && response.success) {
        final notifications = response.data.notifications;
        return notifications
            .where((notification) => !notification.isRead)
            .length;
      }
      return 0;
    } catch (e) {
      print('Error calculating unread notifications count: $e');
      return 0;
    }
  }

  // Get notifications by type
  static Future<NotificationResponse?> getNotificationsByType({
    required String type,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final AppResponse response = await AppRequest.get(
        AppEndPoints.notifications,
        true, // isAuth
        queryParameters: {'page': page, 'per_page': perPage, 'type': type},
      );

      if (response.success && response.origin != null) {
        return NotificationResponse.fromJson(response.origin!);
      }
      return null;
    } catch (e) {
      print('Error fetching notifications by type: $e');
      return null;
    }
  }

  // Get only unread notifications
  static Future<NotificationResponse?> getUnreadNotifications({
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final AppResponse response = await AppRequest.get(
        AppEndPoints.notifications,
        true, // isAuth
        queryParameters: {
          'page': page,
          'per_page': perPage,
          'unread_only': true,
        },
      );

      if (response.success && response.origin != null) {
        return NotificationResponse.fromJson(response.origin!);
      }
      return null;
    } catch (e) {
      print('Error fetching unread notifications: $e');
      return null;
    }
  }

  // Delete notification
  static Future<MarkReadResponse?> deleteNotification(
    String notificationId,
  ) async {
    try {
      final AppResponse response = await AppRequest.post(
        '${AppEndPoints.notifications}/$notificationId/delete',
        true, // isAuth
      );

      if (response.success && response.origin != null) {
        return MarkReadResponse.fromJson(response.origin!);
      }
      return null;
    } catch (e) {
      print('Error deleting notification: $e');
      return null;
    }
  }
}
