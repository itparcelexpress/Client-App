import 'package:client_app/core/models/user_model.dart';
import 'package:client_app/features/auth/data/models/login_models.dart';
import 'package:client_app/features/auth/data/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());

    try {
      final loginRequest = LoginRequest(email: email, password: password);

      final response = await _authRepository.login(loginRequest);

      if (response.success && response.data != null) {
        emit(AuthSuccess(user: response.data!));
      } else {
        emit(
          AuthFailure(
            message: response.message ?? 'Login failed',
            errors: response.errors ?? ['Login failed'],
          ),
        );
      }
    } catch (e) {
      emit(
        AuthFailure(
          message: 'An unexpected error occurred',
          errors: [e.toString()],
        ),
      );
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());

    try {
      await _authRepository.logout();
      emit(AuthInitial());
    } catch (e) {
      // Even if logout fails, clear the state
      emit(AuthInitial());
    }
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
