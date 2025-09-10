import 'package:client_app/core/utilities/app_endpoints.dart';
import 'package:client_app/data/local/local_data.dart';
import 'package:client_app/data/remote/app_request.dart';
import 'package:client_app/data/remote/helper/app_response.dart';
import 'package:client_app/features/auth/data/models/login_models.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(LoginRequest request);
  Future<bool> logout();
  Future<bool> isLoggedIn();
}

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final AppResponse response = await AppRequest.post(
        AppEndPoints.clientLogin,
        false, // No auth required for login
        data: request.toJson(),
      );

      if (response.success && response.data != null) {
        // Use the original response structure to parse the login response
        final loginResponse = LoginResponse.fromJson(response.origin ?? {});

        // Save user data locally if login is successful
        if (loginResponse.success && loginResponse.data != null) {
          final user = loginResponse.data!;
          if (user.token != null) {
            await LocalData.setToken(user.token!);
            await LocalData.setUser(user);
            await LocalData.setIsLoggedIn(true);
          }
        }

        return loginResponse;
      } else {
        // Normalize errors to a list of strings
        List<String> normalizedErrors = [];
        final rawErrors = response.origin?['errors'];
        if (rawErrors != null) {
          if (rawErrors is List) {
            normalizedErrors = rawErrors.map((e) => e.toString()).toList();
          } else if (rawErrors is Map) {
            normalizedErrors =
                rawErrors.values
                    .expand((v) => v is List ? v : [v])
                    .map((e) => e.toString())
                    .toList();
          } else {
            normalizedErrors = [rawErrors.toString()];
          }
        }

        return LoginResponse(
          message: response.message ?? 'Login failed',
          success: false,
          errors:
              normalizedErrors.isNotEmpty ? normalizedErrors : ['Login failed'],
        );
      }
    } catch (e) {
      return LoginResponse(
        message: 'An error occurred during login',
        success: false,
        errors: [e.toString()],
      );
    }
  }

  @override
  Future<bool> logout() async {
    try {
      // Call logout API
      final AppResponse response = await AppRequest.post(
        AppEndPoints.logout,
        true, // Auth required for logout
      );

      // Clear local data regardless of API response
      await LocalData.logout();

      // Check if the logout was successful based on the new API response format
      // Expected response: {"message": "Logout Successfull", "success": [], "data": [], "errors": []}
      return response.success;
    } catch (e) {
      // Clear local data even if API call fails
      await LocalData.logout();
      return false;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return LocalData.isLoggedIn && LocalData.token.isNotEmpty;
  }
}
