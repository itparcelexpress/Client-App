import 'package:client_app/data/local/local_data.dart';
import 'package:flutter/foundation.dart';

/// Global authentication manager that handles authentication state changes
/// This is used to coordinate logout across the entire app
class GlobalAuthManager {
  static GlobalAuthManager? _instance;
  static GlobalAuthManager get instance => _instance ??= GlobalAuthManager._();

  GlobalAuthManager._();

  // Callback function that will be set by the AuthWrapper
  VoidCallback? _onLogoutCallback;

  /// Set the logout callback that will be called when authentication fails
  void setLogoutCallback(VoidCallback callback) {
    _onLogoutCallback = callback;
  }

  /// Clear the logout callback
  void clearLogoutCallback() {
    _onLogoutCallback = null;
  }

  /// Handle authentication failure (401 errors)
  Future<void> handleAuthFailure() async {
    if (kDebugMode) {
      print('🔴 GlobalAuthManager: Handling authentication failure');
    }

    // Clear local authentication data
    await LocalData.logout();

    // Call the logout callback if it's set
    if (_onLogoutCallback != null) {
      if (kDebugMode) {
        print('🔴 GlobalAuthManager: Calling logout callback');
      }
      _onLogoutCallback!();
    } else {
      if (kDebugMode) {
        print('🔴 GlobalAuthManager: No logout callback set');
      }
    }
  }

  /// Check if user is currently authenticated
  bool get isAuthenticated =>
      LocalData.isLoggedIn && LocalData.token.isNotEmpty;
}
