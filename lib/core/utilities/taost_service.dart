// toast_service.dart

import 'package:client_app/core/services/messaging_service.dart';
import 'package:client_app/core/widgets/messaging/toast_notification.dart';
import 'package:client_app/data/local/local_data.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

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
    BuildContext? context,
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

    // Convert old ToastType to new ToastType
    final newType = _convertToastType(type);

    // Use new messaging service if context is available
    if (context != null) {
      MessagingService.showToast(context, message: message, type: newType);
    } else {
      // Fallback to old system if no context
      _showLegacyToast(message, type);
    }
  }

  /// Convert old ToastType to new ToastType
  static ToastType _convertToastType(ToastType oldType) {
    switch (oldType) {
      case ToastType.success:
        return ToastType.success;
      case ToastType.error:
        return ToastType.error;
      case ToastType.warning:
        return ToastType.warning;
      case ToastType.info:
        return ToastType.info;
    }
  }

  /// Legacy toast fallback
  static void _showLegacyToast(String message, ToastType type) {
    // This is a fallback for cases where context is not available
    // In practice, this should rarely be used
    print('Toast: $message (Type: $type)');
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
      showCustomToast(message: messageKey, type: type, context: context);
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

    showCustomToast(message: message, type: type, context: context);
  }

  /// Helper method to get localized message using reflection
  static String _getLocalizedMessage(
    AppLocalizations localizations,
    String messageKey,
  ) {
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
      case 'loginErrorIncorrectPassword':
        return localizations.loginErrorIncorrectPassword;
      case 'loginErrorNoAccount':
        return localizations.loginErrorNoAccount;
      case 'loginErrorAccountDisabled':
        return localizations.loginErrorAccountDisabled;
      case 'loginErrorTooManyAttempts':
        return localizations.loginErrorTooManyAttempts;
      case 'loginErrorValidation':
        return localizations.loginErrorValidation;
      case 'loginErrorUnknown':
        return localizations.loginErrorUnknown;
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
    showLocalizedToast(
      context: context,
      messageKey: messageKey,
      type: ToastType.success,
    );
  }

  static void showError(BuildContext context, String messageKey) {
    showLocalizedToast(
      context: context,
      messageKey: messageKey,
      type: ToastType.error,
    );
  }

  static void showInfo(BuildContext context, String messageKey) {
    showLocalizedToast(
      context: context,
      messageKey: messageKey,
      type: ToastType.info,
    );
  }

  static void showWarning(BuildContext context, String messageKey) {
    showLocalizedToast(
      context: context,
      messageKey: messageKey,
      type: ToastType.warning,
    );
  }

  /// New convenience methods using the modern messaging system
  static void showSuccessToast(BuildContext context, String message) {
    MessagingService.showSuccess(context, message);
  }

  static void showErrorToast(BuildContext context, String message) {
    MessagingService.showError(context, message);
  }

  static void showInfoToast(BuildContext context, String message) {
    MessagingService.showInfo(context, message);
  }

  static void showWarningToast(BuildContext context, String message) {
    MessagingService.showWarning(context, message);
  }

  /// Banner methods for important messages
  static void showSuccessBanner(BuildContext context, String message) {
    MessagingService.showSuccessBanner(context, message);
  }

  static void showErrorBanner(BuildContext context, String message) {
    MessagingService.showErrorBanner(context, message);
  }

  static void showInfoBanner(BuildContext context, String message) {
    MessagingService.showInfoBanner(context, message);
  }

  static void showWarningBanner(BuildContext context, String message) {
    MessagingService.showWarningBanner(context, message);
  }
}
