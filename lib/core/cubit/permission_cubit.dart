import 'package:client_app/core/services/permission_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'permission_state.dart';

/// Cubit for managing app permissions state
class PermissionCubit extends Cubit<PermissionState> {
  static const String _permissionsRequestedKey = 'permissions_requested';
  static const String _permissionsGrantedKey = 'permissions_granted';

  PermissionCubit() : super(PermissionInitial());

  /// Check if permissions have been requested before
  Future<bool> hasRequestedPermissionsBefore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_permissionsRequestedKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Check if all required permissions are granted
  Future<bool> areRequiredPermissionsGranted() async {
    return await PermissionService.areRequiredPermissionsGranted();
  }

  /// Mark that permissions have been requested
  Future<void> markPermissionsRequested() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_permissionsRequestedKey, true);
    } catch (e) {
      // Handle error silently
    }
  }

  /// Mark that permissions have been granted
  Future<void> markPermissionsGranted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_permissionsGrantedKey, true);
    } catch (e) {
      // Handle error silently
    }
  }

  /// Check if permissions were previously granted
  Future<bool> werePermissionsGrantedBefore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_permissionsGrantedKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Initialize permission state on app start
  Future<void> initializePermissions() async {
    emit(PermissionChecking());

    try {
      final hasRequestedBefore = await hasRequestedPermissionsBefore();
      final areGranted = await areRequiredPermissionsGranted();

      if (!hasRequestedBefore) {
        // First time user - automatically request permissions via pop-ups
        await requestPermissions();
      } else if (!areGranted) {
        // User has used app before but permissions are not granted
        if (await PermissionService.hasPermanentlyDeniedPermissions()) {
          emit(PermissionPermanentlyDenied());
        } else {
          emit(PermissionDenied());
        }
      } else {
        // All permissions are granted
        emit(PermissionGranted());
      }
    } catch (e) {
      emit(PermissionError(message: e.toString()));
    }
  }

  /// Request permissions
  Future<void> requestPermissions() async {
    emit(PermissionRequesting());

    try {
      final result = await PermissionService.requestRequiredPermissions();

      await markPermissionsRequested();

      if (result.allGranted) {
        await markPermissionsGranted();
        emit(PermissionGranted());
      } else if (result.hasPermanentlyDenied) {
        emit(PermissionPermanentlyDenied());
      } else {
        emit(
          PermissionPartiallyGranted(
            grantedCount: result.grantedPermissions.length,
            totalCount: PermissionService.getRequiredPermissions().length,
          ),
        );
      }
    } catch (e) {
      emit(PermissionError(message: e.toString()));
    }
  }

  /// Request optional permissions
  Future<void> requestOptionalPermissions() async {
    try {
      final result = await PermissionService.requestOptionalPermissions();

      if (result.allGranted) {
        emit(PermissionGranted());
      } else {
        emit(
          PermissionPartiallyGranted(
            grantedCount: result.grantedPermissions.length,
            totalCount: PermissionService.getOptionalPermissions().length,
          ),
        );
      }
    } catch (e) {
      emit(PermissionError(message: e.toString()));
    }
  }

  /// Check permission status for a specific permission
  Future<PermissionStatus> checkPermissionStatus(Permission permission) async {
    return await PermissionService.getPermissionStatus(permission);
  }

  /// Request a specific permission
  Future<PermissionResult> requestSpecificPermission(
    Permission permission,
  ) async {
    return await PermissionService.requestPermission(permission);
  }

  /// Open app settings
  Future<void> openAppSettings() async {
    await PermissionService.openAppSettings();
  }

  /// Reset permission state (for testing or if user wants to re-request)
  Future<void> resetPermissionState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_permissionsRequestedKey);
      await prefs.remove(_permissionsGrantedKey);
      emit(PermissionInitial());
    } catch (e) {
      emit(PermissionError(message: e.toString()));
    }
  }

  /// Skip permission request (user chose to continue without permissions)
  Future<void> skipPermissions() async {
    await markPermissionsRequested();
    emit(PermissionSkipped());
  }

  /// Check if a specific permission is critical for the app to function
  bool isCriticalPermission(Permission permission) {
    return PermissionService.isCriticalPermission(permission);
  }

  /// Get list of missing critical permissions
  Future<List<Permission>> getMissingCriticalPermissions() async {
    final criticalPermissions =
        PermissionService.getRequiredPermissions()
            .where(PermissionService.isCriticalPermission)
            .toList();

    final missingPermissions = <Permission>[];

    for (final permission in criticalPermissions) {
      final status = await permission.status;
      if (!status.isGranted) {
        missingPermissions.add(permission);
      }
    }

    return missingPermissions;
  }
}
