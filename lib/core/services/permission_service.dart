import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

/// Centralized service for handling all app permissions
class PermissionService {
  static final Map<ph.Permission, String> _permissionDescriptions = {
    ph.Permission.storage:
        'Storage access is needed to save exported files (Excel, PDF) and access downloaded documents.',
    ph.Permission.photos:
        'Photo library access is needed to save and access exported files (Excel, PDF) and attach images.',
    ph.Permission.camera:
        'Camera access is needed to scan QR codes and barcodes for shipment tracking.',
    ph.Permission.location:
        'Location access helps provide accurate delivery tracking and route optimization.',
    ph.Permission.notification:
        'Notifications keep you updated about delivery status and important updates.',
    ph.Permission.phone:
        'Phone access is needed for calling delivery agents and customer support.',
    ph.Permission.contacts:
        'Contact access helps you quickly select recipients from your contacts.',
    ph.Permission.microphone:
        'Microphone access is needed for voice notes and customer support calls.',
  };

  /// Get all permissions that the app needs
  static List<ph.Permission> getRequiredPermissions() {
    final permissions = <ph.Permission>[
      // Only request storage on Android (iOS uses photo library instead)
      if (!Platform.isIOS) ph.Permission.storage,
      ph.Permission.camera,
      ph.Permission.location,
      ph.Permission.notification,
      // Phone permission doesn't exist on iOS (calls work via URL schemes)
      if (!Platform.isIOS) ph.Permission.phone,
      // On iOS, use photo library for file access
      if (Platform.isIOS) ph.Permission.photos,
    ];

    return permissions;
  }

  /// Get optional permissions that enhance app functionality
  static List<ph.Permission> getOptionalPermissions() {
    return [ph.Permission.contacts, ph.Permission.microphone];
  }

  /// Check if all required permissions are granted
  static Future<bool> areRequiredPermissionsGranted() async {
    final requiredPermissions = getRequiredPermissions();

    for (final permission in requiredPermissions) {
      final status = await permission.status;
      if (!status.isGranted) {
        return false;
      }
    }

    return true;
  }

  /// Check if any required permissions are denied permanently
  static Future<bool> hasPermanentlyDeniedPermissions() async {
    final requiredPermissions = getRequiredPermissions();

    for (final permission in requiredPermissions) {
      final status = await permission.status;
      if (status.isPermanentlyDenied) {
        return true;
      }
    }

    return false;
  }

  /// Get permission status for a specific permission
  static Future<ph.PermissionStatus> getPermissionStatus(
    ph.Permission permission,
  ) async {
    return await permission.status;
  }

  /// Request a single permission with proper handling
  static Future<PermissionResult> requestPermission(
    ph.Permission permission,
  ) async {
    try {
      final status = await permission.status;

      if (status.isGranted) {
        return PermissionResult.granted;
      }

      if (status.isPermanentlyDenied) {
        return PermissionResult.permanentlyDenied;
      }

      final result = await permission.request();

      switch (result) {
        case ph.PermissionStatus.granted:
          return PermissionResult.granted;
        case ph.PermissionStatus.denied:
          return PermissionResult.denied;
        case ph.PermissionStatus.permanentlyDenied:
          return PermissionResult.permanentlyDenied;
        case ph.PermissionStatus.restricted:
          return PermissionResult.restricted;
        case ph.PermissionStatus.limited:
          return PermissionResult.limited;
        case ph.PermissionStatus.provisional:
          return PermissionResult.granted; // Treat provisional as granted
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error requesting permission $permission: $e');
      }
      return PermissionResult.error;
    }
  }

  /// Request all required permissions with proper flow
  static Future<PermissionRequestResult> requestRequiredPermissions() async {
    final requiredPermissions = getRequiredPermissions();
    final results = <ph.Permission, PermissionResult>{};
    final grantedPermissions = <ph.Permission>[];
    final deniedPermissions = <ph.Permission>[];
    final permanentlyDeniedPermissions = <ph.Permission>[];

    for (final permission in requiredPermissions) {
      final result = await requestPermission(permission);
      results[permission] = result;

      switch (result) {
        case PermissionResult.granted:
          grantedPermissions.add(permission);
          break;
        case PermissionResult.denied:
          deniedPermissions.add(permission);
          break;
        case PermissionResult.permanentlyDenied:
          permanentlyDeniedPermissions.add(permission);
          break;
        case PermissionResult.restricted:
        case PermissionResult.limited:
        case PermissionResult.error:
          deniedPermissions.add(permission);
          break;
      }
    }

    return PermissionRequestResult(
      results: results,
      grantedPermissions: grantedPermissions,
      deniedPermissions: deniedPermissions,
      permanentlyDeniedPermissions: permanentlyDeniedPermissions,
    );
  }

  /// Request optional permissions
  static Future<PermissionRequestResult> requestOptionalPermissions() async {
    final optionalPermissions = getOptionalPermissions();
    final results = <ph.Permission, PermissionResult>{};
    final grantedPermissions = <ph.Permission>[];
    final deniedPermissions = <ph.Permission>[];

    for (final permission in optionalPermissions) {
      final result = await requestPermission(permission);
      results[permission] = result;

      if (result == PermissionResult.granted) {
        grantedPermissions.add(permission);
      } else {
        deniedPermissions.add(permission);
      }
    }

    return PermissionRequestResult(
      results: results,
      grantedPermissions: grantedPermissions,
      deniedPermissions: deniedPermissions,
      permanentlyDeniedPermissions: [],
    );
  }

  /// Get user-friendly description for a permission
  static String getPermissionDescription(ph.Permission permission) {
    return _permissionDescriptions[permission] ??
        'This permission is required for the app to function properly.';
  }

  /// Get user-friendly name for a permission
  static String getPermissionName(ph.Permission permission) {
    switch (permission) {
      case ph.Permission.storage:
        return 'Storage';
      case ph.Permission.camera:
        return 'Camera';
      case ph.Permission.location:
        return 'Location';
      case ph.Permission.notification:
        return 'Notifications';
      case ph.Permission.phone:
        return 'Phone';
      case ph.Permission.contacts:
        return 'Contacts';
      case ph.Permission.microphone:
        return 'Microphone';
      default:
        return permission.toString().split('.').last;
    }
  }

  /// Open app settings for permission management
  static Future<void> openAppSettings() async {
    try {
      await ph.openAppSettings();
    } catch (e) {
      if (kDebugMode) {
        print('Error opening app settings: $e');
      }
    }
  }

  /// Check if a specific permission is critical for app functionality
  static bool isCriticalPermission(ph.Permission permission) {
    final criticalPermissions = {ph.Permission.storage, ph.Permission.camera};
    return criticalPermissions.contains(permission);
  }

  /// Get permissions that need to be requested on first app launch
  static List<ph.Permission> getFirstLaunchPermissions() {
    return [
      ph.Permission.storage,
      ph.Permission.camera,
      ph.Permission.notification,
    ];
  }

  /// Get permissions that can be requested later (when feature is used)
  static List<ph.Permission> getOnDemandPermissions() {
    return [
      ph.Permission.location,
      ph.Permission.phone,
      ph.Permission.contacts,
      ph.Permission.microphone,
    ];
  }
}

/// Result of a permission request
enum PermissionResult {
  granted,
  denied,
  permanentlyDenied,
  restricted,
  limited,
  error,
}

/// Result of requesting multiple permissions
class PermissionRequestResult {
  final Map<ph.Permission, PermissionResult> results;
  final List<ph.Permission> grantedPermissions;
  final List<ph.Permission> deniedPermissions;
  final List<ph.Permission> permanentlyDeniedPermissions;

  const PermissionRequestResult({
    required this.results,
    required this.grantedPermissions,
    required this.deniedPermissions,
    required this.permanentlyDeniedPermissions,
  });

  /// Check if all permissions were granted
  bool get allGranted =>
      deniedPermissions.isEmpty && permanentlyDeniedPermissions.isEmpty;

  /// Check if any permissions were permanently denied
  bool get hasPermanentlyDenied => permanentlyDeniedPermissions.isNotEmpty;

  /// Check if any permissions were denied (but not permanently)
  bool get hasDenied => deniedPermissions.isNotEmpty;

  /// Get the percentage of permissions granted
  double get grantPercentage {
    final total = results.length;
    if (total == 0) return 1.0;
    return grantedPermissions.length / total;
  }
}
