// toast_service.dart

import 'package:client_app/data/local/local_data.dart';
import 'package:client_app/l10n/app_localizations.dart';
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

  /// Displays a localized toast with an icon based on the [type].
  ///
  /// [context] is used to get the current locale and localizations.
  /// [messageKey] is the key for the localized message.
  /// [type] determines the icon and background color.
  static void showLocalizedToast({
    required BuildContext context,
    required String messageKey,
    ToastType type = ToastType.info,
  }) {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) {
      // Fallback to non-localized toast if localizations are not available
      showCustomToast(message: messageKey, type: type);
      return;
    }

    String message;
    try {
      // Use reflection to get the localized message
      message = _getLocalizedMessage(localizations, messageKey);
    } catch (e) {
      // Fallback to the key itself if the message is not found
      message = messageKey;
    }

    showCustomToast(message: message, type: type);
  }

  /// Helper method to get localized message using reflection
  static String _getLocalizedMessage(AppLocalizations localizations, String messageKey) {
    // Convert messageKey to getter method name
    final getterName = messageKey;
    
    // Use switch statement to handle all possible message keys
    switch (getterName) {
      case 'orderCreatedSuccessfully':
        return localizations.orderCreatedSuccessfully;
      case 'orderCreationFailed':
        return localizations.orderCreationFailed;
      case 'addressSavedSuccessfully':
        return localizations.addressSavedSuccessfully;
      case 'addressSaveFailed':
        return localizations.addressSaveFailed;
      case 'addressDeletedSuccessfully':
        return localizations.addressDeletedSuccessfully;
      case 'addressDeleteFailed':
        return localizations.addressDeleteFailed;
      case 'addressUpdatedSuccessfully':
        return localizations.addressUpdatedSuccessfully;
      case 'addressUpdateFailed':
        return localizations.addressUpdateFailed;
      case 'settingsSavedSuccessfully':
        return localizations.settingsSavedSuccessfully;
      case 'settingsSaveFailed':
        return localizations.settingsSaveFailed;
      case 'logoutSuccessfully':
        return localizations.logoutSuccessfully;
      case 'logoutFailed':
        return localizations.logoutFailed;
      case 'loginSuccessfully':
        return localizations.loginSuccessfully;
      case 'loginFailed':
        return localizations.loginFailed;
      case 'networkError':
        return localizations.networkError;
      case 'serverError':
        return localizations.serverError;
      case 'validationError':
        return localizations.validationError;
      case 'operationSuccess':
        return localizations.operationSuccess;
      case 'operationFailed':
        return localizations.operationFailed;
      case 'dataLoadedSuccessfully':
        return localizations.dataLoadedSuccessfully;
      case 'dataLoadFailed':
        return localizations.dataLoadFailed;
      case 'fileDownloadedSuccessfully':
        return localizations.fileDownloadedSuccessfully;
      case 'fileDownloadFailed':
        return localizations.fileDownloadFailed;
      case 'copyToClipboardSuccess':
        return localizations.copyToClipboardSuccess;
      case 'copyToClipboardFailed':
        return localizations.copyToClipboardFailed;
      case 'languageChangedToArabic':
        return localizations.languageChangedToArabic;
      case 'languageChangedToEnglish':
        return localizations.languageChangedToEnglish;
      default:
        return messageKey; // Return the key itself as fallback
    }
  }

  /// Convenience methods for common toast types
  static void showSuccess(BuildContext context, String messageKey) {
    showLocalizedToast(context: context, messageKey: messageKey, type: ToastType.success);
  }

  static void showError(BuildContext context, String messageKey) {
    showLocalizedToast(context: context, messageKey: messageKey, type: ToastType.error);
  }

  static void showInfo(BuildContext context, String messageKey) {
    showLocalizedToast(context: context, messageKey: messageKey, type: ToastType.info);
  }

  static void showWarning(BuildContext context, String messageKey) {
    showLocalizedToast(context: context, messageKey: messageKey, type: ToastType.warning);
  }
}
