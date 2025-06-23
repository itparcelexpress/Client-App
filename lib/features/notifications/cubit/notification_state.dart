import 'package:client_app/core/models/notification_models.dart';
import 'package:equatable/equatable.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

// Initial state
class NotificationInitial extends NotificationState {}

// Loading states
class NotificationLoading extends NotificationState {}

class NotificationLoadingMore extends NotificationState {
  final List<NotificationModel> existingNotifications;

  const NotificationLoadingMore(this.existingNotifications);

  @override
  List<Object?> get props => [existingNotifications];
}

// Success states
class NotificationLoaded extends NotificationState {
  final List<NotificationModel> notifications;
  final int currentPage;
  final int totalPages;
  final int totalNotifications;
  final bool hasMorePages;
  final int unreadCount;

  const NotificationLoaded({
    required this.notifications,
    required this.currentPage,
    required this.totalPages,
    required this.totalNotifications,
    required this.hasMorePages,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [
    notifications,
    currentPage,
    totalPages,
    totalNotifications,
    hasMorePages,
    unreadCount,
  ];

  // Helper method to get unread notifications
  List<NotificationModel> get unreadNotifications =>
      notifications.where((n) => !n.isRead).toList();

  // Helper method to get read notifications
  List<NotificationModel> get readNotifications =>
      notifications.where((n) => n.isRead).toList();

  // Copy method for updating state
  NotificationLoaded copyWith({
    List<NotificationModel>? notifications,
    int? currentPage,
    int? totalPages,
    int? totalNotifications,
    bool? hasMorePages,
    int? unreadCount,
  }) {
    return NotificationLoaded(
      notifications: notifications ?? this.notifications,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalNotifications: totalNotifications ?? this.totalNotifications,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

// Action success states
class NotificationMarkAsReadSuccess extends NotificationState {
  final int notificationId;
  final List<NotificationModel> updatedNotifications;

  const NotificationMarkAsReadSuccess(
    this.notificationId,
    this.updatedNotifications,
  );

  @override
  List<Object?> get props => [notificationId, updatedNotifications];
}

class NotificationMarkAllAsReadSuccess extends NotificationState {
  final List<NotificationModel> updatedNotifications;

  const NotificationMarkAllAsReadSuccess(this.updatedNotifications);

  @override
  List<Object?> get props => [updatedNotifications];
}

class NotificationDeleteSuccess extends NotificationState {
  final int deletedNotificationId;
  final List<NotificationModel> remainingNotifications;

  const NotificationDeleteSuccess(
    this.deletedNotificationId,
    this.remainingNotifications,
  );

  @override
  List<Object?> get props => [deletedNotificationId, remainingNotifications];
}

// Filter states
class NotificationFiltered extends NotificationState {
  final List<NotificationModel> filteredNotifications;
  final String filterType;
  final int currentPage;
  final int totalPages;
  final bool hasMorePages;

  const NotificationFiltered({
    required this.filteredNotifications,
    required this.filterType,
    required this.currentPage,
    required this.totalPages,
    required this.hasMorePages,
  });

  @override
  List<Object?> get props => [
    filteredNotifications,
    filterType,
    currentPage,
    totalPages,
    hasMorePages,
  ];
}

// Error states
class NotificationError extends NotificationState {
  final String message;
  final String? errorCode;

  const NotificationError(this.message, {this.errorCode});

  @override
  List<Object?> get props => [message, errorCode];
}

class NotificationActionError extends NotificationState {
  final String message;
  final String action; // 'mark_read', 'mark_all_read', 'delete', etc.
  final List<NotificationModel>
  notifications; // Current notifications to maintain state

  const NotificationActionError(this.message, this.action, this.notifications);

  @override
  List<Object?> get props => [message, action, notifications];
}

// Empty state
class NotificationEmpty extends NotificationState {
  final String message;

  const NotificationEmpty({this.message = 'No notifications found'});

  @override
  List<Object?> get props => [message];
}

// Statistics state
class NotificationStatsLoaded extends NotificationState {
  final int totalCount;
  final int unreadCount;
  final int readCount;
  final Map<String, int> typeDistribution;

  const NotificationStatsLoaded({
    required this.totalCount,
    required this.unreadCount,
    required this.readCount,
    required this.typeDistribution,
  });

  @override
  List<Object?> get props => [
    totalCount,
    unreadCount,
    readCount,
    typeDistribution,
  ];
}
