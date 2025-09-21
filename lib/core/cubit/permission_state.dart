part of 'permission_cubit.dart';

/// Abstract base class for permission states
abstract class PermissionState extends Equatable {
  const PermissionState();

  @override
  List<Object?> get props => [];
}

/// Initial state when permission checking starts
class PermissionInitial extends PermissionState {}

/// State when checking current permission status
class PermissionChecking extends PermissionState {}

/// State when this is the first time requesting permissions
class PermissionFirstTime extends PermissionState {}

/// State when requesting permissions
class PermissionRequesting extends PermissionState {}

/// State when all required permissions are granted
class PermissionGranted extends PermissionState {}

/// State when some permissions are granted but not all
class PermissionPartiallyGranted extends PermissionState {
  final int grantedCount;
  final int totalCount;

  const PermissionPartiallyGranted({
    required this.grantedCount,
    required this.totalCount,
  });

  @override
  List<Object?> get props => [grantedCount, totalCount];

  /// Get the percentage of permissions granted
  double get grantPercentage => grantedCount / totalCount;
}

/// State when permissions are denied (but not permanently)
class PermissionDenied extends PermissionState {}

/// State when permissions are permanently denied
class PermissionPermanentlyDenied extends PermissionState {}

/// State when user skipped permission request
class PermissionSkipped extends PermissionState {}

/// State when there's an error with permissions
class PermissionError extends PermissionState {
  final String message;

  const PermissionError({required this.message});

  @override
  List<Object?> get props => [message];
}
