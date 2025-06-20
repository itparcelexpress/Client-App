// toast_service.dart

import 'package:client_app/data/local/local_data.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastType { success, error, info, warning }

class ToastService {
  // Flag to suppress auth error messages during logout/redirect
  static bool _suppressAuthErrors = false;

  // Method to suppress auth errors (called during logout process)
  static void suppressAuthErrors() {
    _suppressAuthErrors = true;
    // Reset after a short delay to not affect other operations
    Future.delayed(const Duration(seconds: 3), () {
      _suppressAuthErrors = false;
    });
  }

  /// Displays a custom toast with an icon based on the [type].
  ///
  /// [message] is the text to display.
  /// [type] determines the icon and background color.
  static void showCustomToast({
    required String message,
    ToastType type = ToastType.info,
  }) {
    // Skip auth-related error messages when user is being logged out
    if (_suppressAuthErrors && type == ToastType.error) {
      // Check if this is an auth error message
      if (message.contains('Unauthenticated') ||
          message.contains('Unauthorized') ||
          message.contains('Token') ||
          message.contains('Authentication') ||
          message.contains('auth')) {
        return; // Skip showing this toast
      }
    }

    // Skip auth errors if token is empty (user already logged out)
    if (type == ToastType.error && LocalData.token.isEmpty) {
      if (message.contains('Unauthenticated') ||
          message.contains('Unauthorized') ||
          message.contains('Token') ||
          message.contains('Authentication') ||
          message.contains('auth')) {
        return; // Skip showing this toast
      }
    }

    Color backgroundColor;
    String icon;

    // Assign icon and background color based on the toast type
    switch (type) {
      case ToastType.success:
        backgroundColor = Colors.green;
        icon = "✅"; // Checkmark emoji
        break;
      case ToastType.error:
        backgroundColor = Colors.red;
        icon = "❌"; // Cross mark emoji
        break;
      case ToastType.warning:
        backgroundColor = Colors.orange;
        icon = "⚠️"; // Warning emoji
        break;
      case ToastType.info:
        backgroundColor = Colors.blue;
        icon = "ℹ️"; // Information emoji
    }

    // Display the toast
    Fluttertoast.showToast(
      msg: "$icon $message", // Combine icon and message
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 16.0,
      // Optionally, you can add padding and other customization
    );
  }
}
