import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

/// Centralized service for handling all app permissions
class PermissionService {
  static final Map<Permission, String> _permissionDescriptions = {
    Permission.storage:
        'Storage access is needed to save exported files (Excel, PDF) and access downloaded documents.',
    Permission.camera:
        'Camera access is needed to scan QR codes and barcodes for shipment tracking.',
    Permission.location:
        'Location access helps provide accurate delivery tracking and route optimization.',
    Permission.notification:
        'Notifications keep you updated about delivery status and important updates.',
    Permission.phone:
        'Phone access is needed for calling delivery agents and customer support.',
    Permission.contacts:
        'Contact access helps you quickly select recipients from your contacts.',
    Permission.microphone:
        'Microphone access is needed for voice notes and customer support calls.',
  };

  /// Get all permissions that the app needs
  static List<Permission> getRequiredPermissions() {
    final permissions = <Permission>[
      Permission.storage,
      Permission.camera,
      Permission.location,
      Permission.notification,
      Permission.phone,
    ];

    return permissions;
  }

  /// Get optional permissions that enhance app functionality
  static List<Permission> getOptionalPermissions() {
    return [Permission.contacts, Permission.microphone];
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
  static Future<PermissionStatus> getPermissionStatus(
    Permission permission,
  ) async {
    return await permission.status;
  }

  /// Request a single permission with proper handling
  static Future<PermissionResult> requestPermission(
    Permission permission,
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
        case PermissionStatus.granted:
          return PermissionResult.granted;
        case PermissionStatus.denied:
          return PermissionResult.denied;
        case PermissionStatus.permanentlyDenied:
          return PermissionResult.permanentlyDenied;
        case PermissionStatus.restricted:
          return PermissionResult.restricted;
        case PermissionStatus.limited:
          return PermissionResult.limited;
        case PermissionStatus.provisional:
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
    final results = <Permission, PermissionResult>{};
    final grantedPermissions = <Permission>[];
    final deniedPermissions = <Permission>[];
    final permanentlyDeniedPermissions = <Permission>[];

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
    final results = <Permission, PermissionResult>{};
    final grantedPermissions = <Permission>[];
    final deniedPermissions = <Permission>[];

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
  static String getPermissionDescription(Permission permission) {
    return _permissionDescriptions[permission] ??
        'This permission is required for the app to function properly.';
  }

  /// Get user-friendly name for a permission
  static String getPermissionName(Permission permission) {
    switch (permission) {
      case Permission.storage:
        return 'Storage';
      case Permission.camera:
        return 'Camera';
      case Permission.location:
        return 'Location';
      case Permission.notification:
        return 'Notifications';
      case Permission.phone:
        return 'Phone';
      case Permission.contacts:
        return 'Contacts';
      case Permission.microphone:
        return 'Microphone';
      default:
        return permission.toString().split('.').last;
    }
  }

  /// Open app settings for permission management
  static Future<void> openAppSettings() async {
    try {
      await openAppSettings();
    } catch (e) {
      if (kDebugMode) {
        print('Error opening app settings: $e');
      }
    }
  }

  /// Check if a specific permission is critical for app functionality
  static bool isCriticalPermission(Permission permission) {
    final criticalPermissions = {Permission.storage, Permission.camera};
    return criticalPermissions.contains(permission);
  }

  /// Get permissions that need to be requested on first app launch
  static List<Permission> getFirstLaunchPermissions() {
    return [Permission.storage, Permission.camera, Permission.notification];
  }

  /// Get permissions that can be requested later (when feature is used)
  static List<Permission> getOnDemandPermissions() {
    return [
      Permission.location,
      Permission.phone,
      Permission.contacts,
      Permission.microphone,
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
  final Map<Permission, PermissionResult> results;
  final List<Permission> grantedPermissions;
  final List<Permission> deniedPermissions;
  final List<Permission> permanentlyDeniedPermissions;

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
