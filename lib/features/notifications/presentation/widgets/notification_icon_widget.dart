import 'package:client_app/features/notifications/cubit/notification_cubit.dart';
import 'package:client_app/features/notifications/cubit/notification_state.dart';
import 'package:client_app/features/notifications/presentation/pages/notifications_page.dart';
import 'package:client_app/injections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationIconWidget extends StatelessWidget {
  final double size;
  final Color? color;
  final bool showBadge;

  const NotificationIconWidget({
    super.key,
    this.size = 24,
    this.color,
    this.showBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NotificationCubit>()..loadNotifications(),
      child: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          int unreadCount = 0;

          // Calculate unread count from different states
          if (state is NotificationLoaded) {
            unreadCount = state.unreadCount;
          } else if (state is NotificationMarkAsReadSuccess) {
            // Count unread notifications manually
            unreadCount =
                state.updatedNotifications.where((n) => !n.isRead).length;
          } else if (state is NotificationDeleteSuccess) {
            // Count unread notifications manually
            unreadCount =
                state.remainingNotifications.where((n) => !n.isRead).length;
          }

          return GestureDetector(
            onTap: () => _navigateToNotifications(context),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  Icons.notifications_rounded,
                  size: size,
                  color: color ?? Colors.grey[600],
                ),
                // Only show badge if there are unread notifications
                if (showBadge && unreadCount > 0)
                  Positioned(
                    right: -8,
                    top: -8,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: const Color(0xFFef4444),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          unreadCount > 99 ? '99+' : unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _navigateToNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotificationsPage()),
    );
  }
}
