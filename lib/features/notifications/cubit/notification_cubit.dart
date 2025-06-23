import 'package:bloc/bloc.dart';
import 'package:client_app/core/models/notification_models.dart';
import 'package:client_app/features/notifications/cubit/notification_state.dart';
import 'package:client_app/features/notifications/data/repositories/notification_repository.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository _repository;

  NotificationCubit(this._repository) : super(NotificationInitial());

  // Current data holders
  List<NotificationModel> _allNotifications = [];
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalNotifications = 0;
  int _unreadCount = 0;
  String? _currentFilter;

  // Getters for current state
  List<NotificationModel> get allNotifications => _allNotifications;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalNotifications => _totalNotifications;
  int get unreadCount => _unreadCount;
  bool get hasMorePages => _currentPage < _totalPages;

  // Load initial notifications
  Future<void> loadNotifications({
    bool refresh = false,
    int perPage = 10,
  }) async {
    if (refresh || state is NotificationInitial) {
      emit(NotificationLoading());
      _currentPage = 1;
      _allNotifications.clear();
    }

    try {
      final response = await _repository.getNotifications(
        page: _currentPage,
        perPage: perPage,
      );

      if (response != null && response.success) {
        final paginationData = response.data;

        if (refresh || _currentPage == 1) {
          _allNotifications = paginationData.notifications;
        } else {
          _allNotifications.addAll(paginationData.notifications);
        }

        _currentPage = paginationData.currentPage;
        _totalPages = paginationData.lastPage;
        _totalNotifications = paginationData.total;

        // Calculate unread count from loaded notifications
        _unreadCount = _allNotifications.where((n) => !n.isRead).length;

        if (_allNotifications.isEmpty) {
          emit(const NotificationEmpty());
        } else {
          emit(
            NotificationLoaded(
              notifications: List.from(_allNotifications),
              currentPage: _currentPage,
              totalPages: _totalPages,
              totalNotifications: _totalNotifications,
              hasMorePages: hasMorePages,
              unreadCount: _unreadCount,
            ),
          );
        }
      } else {
        emit(const NotificationError('Failed to load notifications'));
      }
    } catch (e) {
      emit(NotificationError('Error loading notifications: $e'));
    }
  }

  // Load more notifications (pagination)
  Future<void> loadMoreNotifications({int perPage = 10}) async {
    if (!hasMorePages || state is NotificationLoadingMore) return;

    emit(NotificationLoadingMore(List.from(_allNotifications)));

    try {
      final nextPage = _currentPage + 1;
      final response = await _repository.getNotifications(
        page: nextPage,
        perPage: perPage,
      );

      if (response != null && response.success) {
        final paginationData = response.data;
        _allNotifications.addAll(paginationData.notifications);
        _currentPage = nextPage;

        emit(
          NotificationLoaded(
            notifications: List.from(_allNotifications),
            currentPage: _currentPage,
            totalPages: _totalPages,
            totalNotifications: _totalNotifications,
            hasMorePages: hasMorePages,
            unreadCount: _unreadCount,
          ),
        );
      } else {
        emit(
          NotificationActionError(
            'Failed to load more notifications',
            'load_more',
            List.from(_allNotifications),
          ),
        );
      }
    } catch (e) {
      emit(
        NotificationActionError(
          'Error loading more notifications: $e',
          'load_more',
          List.from(_allNotifications),
        ),
      );
    }
  }

  // Mark a specific notification as read
  Future<void> markNotificationAsRead(int notificationId) async {
    try {
      final response = await _repository.markNotificationAsRead(notificationId);

      if (response != null && response.success) {
        // Update local notification
        final updatedNotifications =
            _allNotifications.map((notification) {
              if (notification.id == notificationId && !notification.isRead) {
                _unreadCount = (_unreadCount > 0) ? _unreadCount - 1 : 0;
                return notification.copyWith(readAt: DateTime.now());
              }
              return notification;
            }).toList();

        _allNotifications = updatedNotifications;

        emit(
          NotificationMarkAsReadSuccess(
            notificationId,
            List.from(_allNotifications),
          ),
        );

        // Return to loaded state with updated data
        emit(
          NotificationLoaded(
            notifications: List.from(_allNotifications),
            currentPage: _currentPage,
            totalPages: _totalPages,
            totalNotifications: _totalNotifications,
            hasMorePages: hasMorePages,
            unreadCount: _unreadCount,
          ),
        );
      } else {
        emit(
          NotificationActionError(
            'Failed to mark notification as read',
            'mark_read',
            List.from(_allNotifications),
          ),
        );
      }
    } catch (e) {
      emit(
        NotificationActionError(
          'Error marking notification as read: $e',
          'mark_read',
          List.from(_allNotifications),
        ),
      );
    }
  }

  // Mark all notifications as read
  Future<void> markAllNotificationsAsRead() async {
    try {
      final response = await _repository.markAllNotificationsAsRead();

      if (response != null && response.success) {
        // Update all unread notifications to read
        final updatedNotifications =
            _allNotifications.map((notification) {
              if (!notification.isRead) {
                return notification.copyWith(readAt: DateTime.now());
              }
              return notification;
            }).toList();

        _allNotifications = updatedNotifications;
        _unreadCount = 0;

        emit(NotificationMarkAllAsReadSuccess(List.from(_allNotifications)));

        // Return to loaded state with updated data
        emit(
          NotificationLoaded(
            notifications: List.from(_allNotifications),
            currentPage: _currentPage,
            totalPages: _totalPages,
            totalNotifications: _totalNotifications,
            hasMorePages: hasMorePages,
            unreadCount: _unreadCount,
          ),
        );
      } else {
        emit(
          NotificationActionError(
            'Failed to mark all notifications as read',
            'mark_all_read',
            List.from(_allNotifications),
          ),
        );
      }
    } catch (e) {
      emit(
        NotificationActionError(
          'Error marking all notifications as read: $e',
          'mark_all_read',
          List.from(_allNotifications),
        ),
      );
    }
  }

  // Delete a notification
  Future<void> deleteNotification(int notificationId) async {
    try {
      final response = await _repository.deleteNotification(notificationId);

      if (response != null && response.success) {
        // Remove notification from local list
        final notificationToDelete = _allNotifications.firstWhere(
          (n) => n.id == notificationId,
          orElse: () => throw Exception('Notification not found'),
        );

        if (!notificationToDelete.isRead) {
          _unreadCount = (_unreadCount > 0) ? _unreadCount - 1 : 0;
        }

        _allNotifications.removeWhere((n) => n.id == notificationId);
        _totalNotifications--;

        emit(
          NotificationDeleteSuccess(
            notificationId,
            List.from(_allNotifications),
          ),
        );

        // Return to appropriate state
        if (_allNotifications.isEmpty) {
          emit(const NotificationEmpty());
        } else {
          emit(
            NotificationLoaded(
              notifications: List.from(_allNotifications),
              currentPage: _currentPage,
              totalPages: _totalPages,
              totalNotifications: _totalNotifications,
              hasMorePages: hasMorePages,
              unreadCount: _unreadCount,
            ),
          );
        }
      } else {
        emit(
          NotificationActionError(
            'Failed to delete notification',
            'delete',
            List.from(_allNotifications),
          ),
        );
      }
    } catch (e) {
      emit(
        NotificationActionError(
          'Error deleting notification: $e',
          'delete',
          List.from(_allNotifications),
        ),
      );
    }
  }

  // Filter notifications by type
  Future<void> filterNotificationsByType(
    String type, {
    int perPage = 10,
  }) async {
    emit(NotificationLoading());
    _currentFilter = type;

    try {
      final response = await _repository.getNotificationsByType(
        type: type,
        page: 1,
        perPage: perPage,
      );

      if (response != null && response.success) {
        final paginationData = response.data;

        emit(
          NotificationFiltered(
            filteredNotifications: paginationData.notifications,
            filterType: type,
            currentPage: paginationData.currentPage,
            totalPages: paginationData.lastPage,
            hasMorePages: paginationData.currentPage < paginationData.lastPage,
          ),
        );
      } else {
        emit(const NotificationError('Failed to filter notifications'));
      }
    } catch (e) {
      emit(NotificationError('Error filtering notifications: $e'));
    }
  }

  // Show only unread notifications
  Future<void> showUnreadNotifications({int perPage = 10}) async {
    emit(NotificationLoading());
    _currentFilter = 'unread';

    try {
      final response = await _repository.getUnreadNotifications(
        page: 1,
        perPage: perPage,
      );

      if (response != null && response.success) {
        final paginationData = response.data;

        emit(
          NotificationFiltered(
            filteredNotifications: paginationData.notifications,
            filterType: 'unread',
            currentPage: paginationData.currentPage,
            totalPages: paginationData.lastPage,
            hasMorePages: paginationData.currentPage < paginationData.lastPage,
          ),
        );
      } else {
        emit(const NotificationError('Failed to load unread notifications'));
      }
    } catch (e) {
      emit(NotificationError('Error loading unread notifications: $e'));
    }
  }

  // Clear filter and show all notifications
  Future<void> clearFilter() async {
    _currentFilter = null;
    await loadNotifications(refresh: true);
  }

  // Get notification statistics
  Future<void> loadNotificationStats() async {
    try {
      final stats = await _repository.getNotificationStats();

      emit(
        NotificationStatsLoaded(
          totalCount: stats['total_count'] ?? 0,
          unreadCount: stats['unread_count'] ?? 0,
          readCount: stats['read_count'] ?? 0,
          typeDistribution: Map<String, int>.from(
            stats['type_distribution'] ?? {},
          ),
        ),
      );
    } catch (e) {
      emit(NotificationError('Error loading notification statistics: $e'));
    }
  }

  // Refresh notifications (pull to refresh)
  Future<void> refreshNotifications() async {
    await loadNotifications(refresh: true);
  }

  // Get unread count only
  Future<void> updateUnreadCount() async {
    try {
      // Calculate unread count from current notifications
      _unreadCount = _allNotifications.where((n) => !n.isRead).length;

      // Update current state if it's loaded
      if (state is NotificationLoaded) {
        final currentState = state as NotificationLoaded;
        emit(currentState.copyWith(unreadCount: _unreadCount));
      }
    } catch (e) {
      print('Error updating unread count: $e');
    }
  }
}
