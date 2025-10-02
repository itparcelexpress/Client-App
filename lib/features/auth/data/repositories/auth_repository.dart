import 'package:client_app/core/utilities/app_endpoints.dart';
import 'package:client_app/data/local/local_data.dart';
import 'package:client_app/data/remote/app_request.dart';
import 'package:client_app/data/remote/helper/app_response.dart';
import 'package:client_app/features/auth/data/models/login_models.dart';
import 'package:flutter/foundation.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(LoginRequest request);
  Future<bool> logout();
  Future<bool> isLoggedIn();
  Future<AppResponse> deleteAccount();
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

      if (kDebugMode) {
        print(
          '🔐 AuthRepository.login - AppResponse.success: ${response.success}',
        );
        print('🔐 AuthRepository.login - AppResponse.data: ${response.data}');
        print(
          '🔐 AuthRepository.login - AppResponse.origin: ${response.origin}',
        );
      }

      if (response.success && response.data != null) {
        // Use the original response structure to parse the login response
        final loginResponse = LoginResponse.fromJson(response.origin ?? {});

        if (kDebugMode) {
          print(
            '🔐 AuthRepository.login - LoginResponse.success: ${loginResponse.success}',
          );
          print(
            '🔐 AuthRepository.login - LoginResponse.data: ${loginResponse.data}',
          );
          print(
            '🔐 AuthRepository.login - LoginResponse.errors: ${loginResponse.errors}',
          );
        }

        // Save user data locally if login is successful
        if (loginResponse.success && loginResponse.data != null) {
          final user = loginResponse.data!;
          if (user.token != null) {
            await LocalData.setToken(user.token!);
            await LocalData.setUser(user);
            await LocalData.setIsLoggedIn(true);

            if (kDebugMode) {
              print('🔐 AuthRepository.login - User saved successfully');
            }
          }
        } else {
          if (kDebugMode) {
            print('🔐 AuthRepository.login - LoginResponse validation failed');
            print(
              '🔐 AuthRepository.login - loginResponse.success: ${loginResponse.success}',
            );
            print(
              '🔐 AuthRepository.login - loginResponse.data != null: ${loginResponse.data != null}',
            );
          }
        }

        return loginResponse;
      } else {
        if (kDebugMode) {
          print('🔐 AuthRepository.login - AppResponse validation failed');
          print(
            '🔐 AuthRepository.login - response.success: ${response.success}',
          );
          print(
            '🔐 AuthRepository.login - response.data != null: ${response.data != null}',
          );
        }

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
      if (kDebugMode) {
        print('🔐 AuthRepository.login - Exception caught: $e');
      }

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
      // Call logout API if user has a token
      if (LocalData.token.isNotEmpty) {
        final AppResponse response = await AppRequest.post(
          AppEndPoints.logout,
          true, // Auth required for logout
        );

        // Log the response for debugging (only in debug mode)
        if (kDebugMode) {
          print('Logout API response: ${response.origin}');
        }
      }

      // Always clear local data regardless of API response
      await LocalData.logout();

      return true; // Always return true since local data is cleared
    } catch (e) {
      // Clear local data even if API call fails
      await LocalData.logout();

      // Log error in debug mode
      if (kDebugMode) {
        print('Logout error: $e');
      }

      return true; // Return true since local data is cleared
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return LocalData.isLoggedIn && LocalData.token.isNotEmpty;
  }

  @override
  Future<AppResponse> deleteAccount() async {
    final AppResponse response = await AppRequest.delete(
      AppEndPoints.deleteClientAccount,
      true,
    );
    return response;
  }
}
