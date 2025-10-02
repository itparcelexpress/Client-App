import 'package:flutter/material.dart';
import 'package:client_app/core/widgets/messaging/toast_notification.dart';

/// Centralized messaging service for displaying notifications
class MessagingService {
  MessagingService._();
  static final MessagingService _instance = MessagingService._();
  static MessagingService get instance => _instance;

  /// Show a toast notification
  static void showToast(
    BuildContext context, {
    required String message,
    required ToastType type,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
    String? actionLabel,
    VoidCallback? onActionTap,
    bool showIcon = true,
    bool dismissible = true,
  }) {
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ToastNotification(
              message: message,
              type: type,
              duration: duration,
              onTap: onTap,
              actionLabel: actionLabel,
              onActionTap: onActionTap,
              showIcon: showIcon,
              dismissible: dismissible,
              onDismiss: () {
                overlayEntry.remove();
              },
            ),
          ),
    );

    Overlay.of(context).insert(overlayEntry);
  }

  /// Show a banner notification (appears at top)
  static void showBanner(
    BuildContext context, {
    required String message,
    required ToastType type,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onTap,
    String? actionLabel,
    VoidCallback? onActionTap,
    bool dismissible = true,
  }) {
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: BannerNotification(
              message: message,
              type: type,
              duration: duration,
              onTap: onTap,
              actionLabel: actionLabel,
              onActionTap: onActionTap,
              dismissible: dismissible,
              onDismiss: () {
                overlayEntry.remove();
              },
            ),
          ),
    );

    Overlay.of(context).insert(overlayEntry);
  }

  /// Show success message
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
    String? actionLabel,
    VoidCallback? onActionTap,
  }) {
    showToast(
      context,
      message: message,
      type: ToastType.success,
      duration: duration,
      onTap: onTap,
      actionLabel: actionLabel,
      onActionTap: onActionTap,
    );
  }

  /// Show error message
  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onTap,
    String? actionLabel,
    VoidCallback? onActionTap,
  }) {
    showToast(
      context,
      message: message,
      type: ToastType.error,
      duration: duration,
      onTap: onTap,
      actionLabel: actionLabel,
      onActionTap: onActionTap,
    );
  }

  /// Show warning message
  static void showWarning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
    String? actionLabel,
    VoidCallback? onActionTap,
  }) {
    showToast(
      context,
      message: message,
      type: ToastType.warning,
      duration: duration,
      onTap: onTap,
      actionLabel: actionLabel,
      onActionTap: onActionTap,
    );
  }

  /// Show info message
  static void showInfo(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
    String? actionLabel,
    VoidCallback? onActionTap,
  }) {
    showToast(
      context,
      message: message,
      type: ToastType.info,
      duration: duration,
      onTap: onTap,
      actionLabel: actionLabel,
      onActionTap: onActionTap,
    );
  }

  /// Show success banner
  static void showSuccessBanner(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onTap,
    String? actionLabel,
    VoidCallback? onActionTap,
  }) {
    showBanner(
      context,
      message: message,
      type: ToastType.success,
      duration: duration,
      onTap: onTap,
      actionLabel: actionLabel,
      onActionTap: onActionTap,
    );
  }

  /// Show error banner
  static void showErrorBanner(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 5),
    VoidCallback? onTap,
    String? actionLabel,
    VoidCallback? onActionTap,
  }) {
    showBanner(
      context,
      message: message,
      type: ToastType.error,
      duration: duration,
      onTap: onTap,
      actionLabel: actionLabel,
      onActionTap: onActionTap,
    );
  }

  /// Show warning banner
  static void showWarningBanner(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onTap,
    String? actionLabel,
    VoidCallback? onActionTap,
  }) {
    showBanner(
      context,
      message: message,
      type: ToastType.warning,
      duration: duration,
      onTap: onTap,
      actionLabel: actionLabel,
      onActionTap: onActionTap,
    );
  }

  /// Show info banner
  static void showInfoBanner(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onTap,
    String? actionLabel,
    VoidCallback? onActionTap,
  }) {
    showBanner(
      context,
      message: message,
      type: ToastType.info,
      duration: duration,
      onTap: onTap,
      actionLabel: actionLabel,
      onActionTap: onActionTap,
    );
  }

  /// Show a confirmation dialog
  static Future<bool?> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    ToastType type = ToastType.warning,
  }) {
    return showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(
                  _getIconForType(type),
                  color: _getColorForType(type),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            content: Text(message, style: const TextStyle(fontSize: 14)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  cancelText,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getColorForType(type),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  confirmText,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
    );
  }

  /// Show a loading dialog
  static void showLoadingDialog(
    BuildContext context, {
    String message = 'Loading...',
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(message, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
    );
  }

  /// Hide loading dialog
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// Show a custom modal bottom sheet
  static Future<T?> showCustomBottomSheet<T>(
    BuildContext context, {
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    double? height,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: height,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: child,
          ),
    );
  }

  static IconData _getIconForType(ToastType type) {
    switch (type) {
      case ToastType.success:
        return Icons.check_circle_outline;
      case ToastType.error:
        return Icons.error_outline;
      case ToastType.warning:
        return Icons.warning_outlined;
      case ToastType.info:
        return Icons.info_outline;
    }
  }

  static Color _getColorForType(ToastType type) {
    switch (type) {
      case ToastType.success:
        return const Color(0xFF10B981);
      case ToastType.error:
        return const Color(0xFFEF4444);
      case ToastType.warning:
        return const Color(0xFFF59E0B);
      case ToastType.info:
        return const Color(0xFF3B82F6);
    }
  }
}

enum OverlayPosition { top, bottom }
