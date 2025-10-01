import 'package:client_app/core/models/user_model.dart';
import 'package:client_app/features/auth/data/models/login_models.dart';
import 'package:client_app/features/auth/data/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  Future<void> login({
    required String email,
    required String password,
    String? pleaseEnterBothMessage,
    String? emailAndPasswordRequiredMessage,
    String? loginFailedMessage,
    String? networkErrorMessage,
    String? internetCheckMessage,
    String? timeoutMessage,
    String? timeoutDetailMessage,
    String? unexpectedErrorMessage,
    String? tryAgainLaterMessage,
  }) async {
    // Validate input before proceeding
    if (email.trim().isEmpty || password.isEmpty) {
      emit(
        AuthFailure(
          message:
              pleaseEnterBothMessage ?? 'Please enter both email and password',
          errors: [
            emailAndPasswordRequiredMessage ??
                'Email and password are required',
          ],
        ),
      );
      return;
    }

    emit(AuthLoading());

    try {
      final loginRequest = LoginRequest(
        email: email.trim(),
        password: password,
      );

      final response = await _authRepository.login(loginRequest);

      if (response.success && response.data != null) {
        emit(AuthSuccess(user: response.data!));
      } else {
        // Provide more specific error messages
        final errorMessage =
            response.message ?? (loginFailedMessage ?? 'Login failed');
        final errors =
            response.errors ?? [loginFailedMessage ?? 'Login failed'];

        emit(AuthFailure(message: errorMessage, errors: errors));
      }
    } catch (e) {
      // Handle different types of exceptions
      String errorMessage;
      List<String> errors;

      if (e.toString().contains('SocketException') ||
          e.toString().contains('NetworkException')) {
        errorMessage = networkErrorMessage ?? 'Network connection error';
        errors = [
          internetCheckMessage ??
              'Please check your internet connection and try again',
        ];
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = timeoutMessage ?? 'Request timeout';
        errors = [
          timeoutDetailMessage ?? 'The request took too long. Please try again',
        ];
      } else {
        errorMessage = unexpectedErrorMessage ?? 'An unexpected error occurred';
        errors = [tryAgainLaterMessage ?? 'Please try again later'];
      }

      emit(AuthFailure(message: errorMessage, errors: errors));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());

    try {
      // Call logout endpoint and clear local data
      await _authRepository.logout();

      // Emit logout success state to trigger navigation
      emit(const AuthLogoutSuccess());

      // Wait a brief moment for UI to process the state change
      await Future.delayed(const Duration(milliseconds: 100));

      // Then emit AuthInitial to reset the state completely
      emit(AuthInitial());
    } catch (e) {
      // Even if logout fails, local data is cleared in repository
      // So we still proceed with logout flow
      emit(const AuthLogoutSuccess());
      await Future.delayed(const Duration(milliseconds: 100));
      emit(AuthInitial());
    }
  }

  // Add a method to clear state without API call (for app termination, etc.)
  void clearAuthState() {
    emit(AuthInitial());
  }

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());

    try {
      final isLoggedIn = await _authRepository.isLoggedIn();
      if (isLoggedIn) {
        // You might want to get user data from local storage
        // For now, we'll emit a basic success state
        emit(AuthCheckSuccess(isAuthenticated: true));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthInitial());
    }
  }

  void resetState() {
    emit(AuthInitial());
  }
}
