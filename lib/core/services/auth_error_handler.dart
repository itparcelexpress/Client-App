import 'package:client_app/core/services/global_auth_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Global authentication error handler service
/// Handles 401 Unauthorized responses by automatically logging out the user
class AuthErrorHandler {
  static AuthErrorHandler? _instance;
  static AuthErrorHandler get instance => _instance ??= AuthErrorHandler._();

  AuthErrorHandler._();

  /// Handle authentication errors globally
  /// This method should be called from Dio interceptors
  Future<void> handleAuthError(DioException error) async {
    // Only handle 401 Unauthorized errors
    if (error.response?.statusCode == 401) {
      if (kDebugMode) {
        print('🔴 401 Unauthorized detected - forcing logout');
        print('🔴 URL: ${error.requestOptions.uri}');
      }

      // Use GlobalAuthManager to handle the logout
      await GlobalAuthManager.instance.handleAuthFailure();
    }
  }

  /// Check if an error is an authentication error
  bool isAuthError(DioException error) {
    return error.response?.statusCode == 401;
  }

  /// Get user-friendly error message for authentication errors
  String getAuthErrorMessage(DioException error) {
    if (error.response?.statusCode == 401) {
      return 'Your session has expired. Please log in again.';
    }
    return 'Authentication error occurred. Please try again.';
  }
}
