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
      print('🔴 GlobalAuthManager: Handling authentication failure (401)');
    }

    // Clear local authentication data first
    await LocalData.logout();

    // Call the logout callback if it's set
    if (_onLogoutCallback != null) {
      if (kDebugMode) {
        print(
          '🔴 GlobalAuthManager: Triggering logout callback to force navigation',
        );
      }
      _onLogoutCallback!();
    } else {
      if (kDebugMode) {
        print(
          '🔴 GlobalAuthManager: WARNING - No logout callback set, navigation may not occur',
        );
      }
    }
  }

  /// Perform a manual logout (can be called from anywhere in the app)
  Future<void> performLogout() async {
    if (kDebugMode) {
      print('🚪 GlobalAuthManager: Performing manual logout');
    }

    // Clear local authentication data
    await LocalData.logout();

    // Trigger the logout callback to update UI
    if (_onLogoutCallback != null) {
      _onLogoutCallback!();
    }
  }

  /// Check if user is currently authenticated
  bool get isAuthenticated =>
      LocalData.isLoggedIn && LocalData.token.isNotEmpty;
}
