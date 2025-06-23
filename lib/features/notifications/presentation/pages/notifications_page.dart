import 'package:client_app/core/models/notification_models.dart';
import 'package:client_app/features/notifications/cubit/notification_cubit.dart';
import 'package:client_app/features/notifications/cubit/notification_state.dart';
import 'package:client_app/injections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NotificationCubit>()..loadNotifications(),
      child: const NotificationsView(),
    );
  }
}

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<NotificationCubit>().loadMoreNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1a1a1a),
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1a1a1a),
          ),
        ),
        actions: [
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              return PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded),
                onSelected: (value) {
                  if (value == 'mark_all_read') {
                    context
                        .read<NotificationCubit>()
                        .markAllNotificationsAsRead();
                  } else if (value == 'refresh') {
                    context.read<NotificationCubit>().refreshNotifications();
                  }
                },
                itemBuilder:
                    (context) => [
                      const PopupMenuItem(
                        value: 'mark_all_read',
                        child: Row(
                          children: [
                            Icon(Icons.done_all_rounded, size: 20),
                            SizedBox(width: 12),
                            Text('Mark all as read'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'refresh',
                        child: Row(
                          children: [
                            Icon(Icons.refresh_rounded, size: 20),
                            SizedBox(width: 12),
                            Text('Refresh'),
                          ],
                        ),
                      ),
                    ],
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<NotificationCubit, NotificationState>(
        listener: (context, state) {
          if (state is NotificationMarkAsReadSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Notification marked as read'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is NotificationDeleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Notification deleted'),
                backgroundColor: Colors.orange,
              ),
            );
          } else if (state is NotificationActionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<NotificationCubit>().refreshNotifications();
            },
            child: _buildBody(context, state),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, NotificationState state) {
    if (state is NotificationLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667eea)),
        ),
      );
    } else if (state is NotificationLoaded) {
      return _buildNotificationsList(
        context,
        state.notifications,
        state.hasMorePages,
      );
    } else if (state is NotificationEmpty) {
      return _buildEmptyState();
    } else if (state is NotificationError) {
      return _buildErrorState(context, state.message);
    } else if (state is NotificationLoadingMore) {
      return _buildNotificationsList(
        context,
        state.existingNotifications,
        true,
      );
    }

    return _buildEmptyState();
  }

  Widget _buildNotificationsList(
    BuildContext context,
    List<NotificationModel> notifications,
    bool hasMore,
  ) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == notifications.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final notification = notifications[index];
        return _buildNotificationCard(context, notification);
      },
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    NotificationModel notification,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              notification.isRead
                  ? Colors.grey[200]!
                  : const Color(0xFF667eea).withOpacity(0.3),
          width: notification.isRead ? 1 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _handleNotificationTap(context, notification),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildNotificationIcon(notification.type),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  notification.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        notification.isRead
                                            ? FontWeight.w500
                                            : FontWeight.w700,
                                    color: const Color(0xFF1a1a1a),
                                  ),
                                ),
                              ),
                              if (!notification.isRead)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF667eea),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDate(notification.createdAt),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert_rounded,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                      onSelected:
                          (value) => _handleNotificationAction(
                            context,
                            value,
                            notification,
                          ),
                      itemBuilder:
                          (context) => [
                            if (!notification.isRead)
                              const PopupMenuItem(
                                value: 'mark_read',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.done_rounded,
                                      size: 16,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(width: 8),
                                    Text('Mark as read'),
                                  ],
                                ),
                              ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete_outline_rounded,
                                    size: 16,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 8),
                                  Text('Delete'),
                                ],
                              ),
                            ),
                          ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  notification.content,
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        notification.isRead
                            ? Colors.grey[600]
                            : const Color(0xFF1a1a1a),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getTypeColor(notification.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    notification.typeDisplayName,
                    style: TextStyle(
                      fontSize: 12,
                      color: _getTypeColor(notification.type),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(String type) {
    final typeData = _getNotificationTypeData(type);
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: typeData['color'].withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(typeData['icon'], size: 20, color: typeData['color']),
    );
  }

  Map<String, dynamic> _getNotificationTypeData(String type) {
    switch (type) {
      case 'pickup_notification':
        return {
          'icon': Icons.local_shipping_rounded,
          'color': const Color(0xFF10b981),
        };
      case 'promotional':
        return {
          'icon': Icons.local_offer_rounded,
          'color': const Color(0xFFf59e0b),
        };
      case 'security_alert':
        return {
          'icon': Icons.security_rounded,
          'color': const Color(0xFFef4444),
        };
      case 'delivery_delay':
        return {
          'icon': Icons.schedule_rounded,
          'color': const Color(0xFFf97316),
        };
      case 'payment_confirmation':
        return {
          'icon': Icons.payment_rounded,
          'color': const Color(0xFF10b981),
        };
      case 'statement_notification':
        return {
          'icon': Icons.receipt_long_rounded,
          'color': const Color(0xFF8b5cf6),
        };
      case 'account_update':
        return {'icon': Icons.person_rounded, 'color': const Color(0xFF667eea)};
      case 'system_announcement':
        return {
          'icon': Icons.campaign_rounded,
          'color': const Color(0xFF06b6d4),
        };
      default:
        return {
          'icon': Icons.notifications_rounded,
          'color': const Color(0xFF667eea),
        };
    }
  }

  Color _getTypeColor(String type) {
    return _getNotificationTypeData(type)['color'];
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: 80,
            color: Color(0xFF667eea),
          ),
          SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1a1a1a),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'When you have new notifications,\nthey\'ll appear here',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded, size: 80, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1a1a1a),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<NotificationCubit>().refreshNotifications();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667eea),
              foregroundColor: Colors.white,
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  void _handleNotificationTap(
    BuildContext context,
    NotificationModel notification,
  ) {
    if (!notification.isRead) {
      context.read<NotificationCubit>().markNotificationAsRead(notification.id);
    }
  }

  void _handleNotificationAction(
    BuildContext context,
    String action,
    NotificationModel notification,
  ) {
    final cubit = context.read<NotificationCubit>();

    switch (action) {
      case 'mark_read':
        cubit.markNotificationAsRead(notification.id);
        break;
      case 'delete':
        _showDeleteConfirmation(context, notification);
        break;
    }
  }

  void _showDeleteConfirmation(
    BuildContext context,
    NotificationModel notification,
  ) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: const Text('Delete Notification'),
            content: const Text(
              'Are you sure you want to delete this notification?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  context.read<NotificationCubit>().deleteNotification(
                    notification.id,
                  );
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
