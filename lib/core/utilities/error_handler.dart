import 'package:client_app/core/utilities/global_error_mapper.dart';
import 'package:client_app/core/utilities/taost_service.dart';
import 'package:flutter/material.dart';

/// Utility class for handling errors throughout the app
class ErrorHandler {
  ErrorHandler._();

  /// Shows a localized error message using ToastService
  static void showError(BuildContext context, dynamic error) {
    final localizedMessage = GlobalErrorMapper.sanitizeAndMapError(
      error: error,
      context: context,
    );

    ToastService.showError(context, localizedMessage);
  }

  /// Shows a localized error message with custom message
  static void showErrorWithMessage(
    BuildContext context,
    String message,
    List<String>? errors,
    Map<String, dynamic>? data,
    int? statusCode,
  ) {
    final localizedMessage = GlobalErrorMapper.mapErrorToLocalizedMessage(
      message: message,
      errors: errors,
      data: data,
      statusCode: statusCode,
      context: context,
    );

    ToastService.showError(context, localizedMessage);
  }

  /// Shows a localized error message for DioException
  static void showDioError(BuildContext context, dynamic dioException) {
    final localizedMessage =
        GlobalErrorMapper.mapDioExceptionToLocalizedMessage(
          exception: dioException,
          context: context,
        );

    ToastService.showError(context, localizedMessage);
  }

  /// Returns a localized error message without showing it
  static String getLocalizedErrorMessage(
    BuildContext context,
    dynamic error, {
    String? message,
    List<String>? errors,
    Map<String, dynamic>? data,
    int? statusCode,
  }) {
    return GlobalErrorMapper.sanitizeAndMapError(
      error: error,
      context: context,
      message: message,
      errors: errors,
      data: data,
      statusCode: statusCode,
    );
  }
}
