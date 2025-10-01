part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserModel user;

  const AuthSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthFailure extends AuthState {
  final String message;
  final List<String> errors;

  const AuthFailure({required this.message, required this.errors});

  @override
  List<Object?> get props => [message, errors];
}

class AuthCheckSuccess extends AuthState {
  final bool isAuthenticated;

  const AuthCheckSuccess({required this.isAuthenticated});

  @override
  List<Object?> get props => [isAuthenticated];
}

class AuthLogoutSuccess extends AuthState {
  const AuthLogoutSuccess();

  @override
  List<Object?> get props => [];
}
