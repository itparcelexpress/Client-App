import 'dart:io';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../models/app_version_models.dart';

/// Singleton service for managing app version checks
class AppVersionService {
  static final AppVersionService _instance = AppVersionService._internal();
  factory AppVersionService() => _instance;
  AppVersionService._internal();

  late Dio _dio;
  CurrentAppVersionInfo? _currentVersionInfo;
  bool _isInitialized = false;

  /// Initialize the service with Dio instance
  Future<void> initialize(Dio dio) async {
    if (_isInitialized) return;

    _dio = dio;
    await _loadCurrentVersionInfo();
    _isInitialized = true;
  }

  /// Load current app version information
  Future<void> _loadCurrentVersionInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      _currentVersionInfo = CurrentAppVersionInfo(
        version: packageInfo.version,
        buildNumber: packageInfo.buildNumber,
        packageName: packageInfo.packageName,
        appName: packageInfo.appName,
      );
    } catch (e) {
      // Fallback values if package_info_plus fails
      _currentVersionInfo = const CurrentAppVersionInfo(
        version: '1.0.0',
        buildNumber: '1',
        packageName: 'com.client.app',
        appName: 'Client App',
      );
    }
  }

  /// Get current app version information
  CurrentAppVersionInfo getCurrentVersionInfo() {
    if (!_isInitialized) {
      throw Exception(
        'AppVersionService not initialized. Call initialize() first.',
      );
    }
    return _currentVersionInfo!;
  }

  /// Check app version against server
  Future<AppVersionResponse> checkAppVersion() async {
    if (!_isInitialized) {
      throw Exception(
        'AppVersionService not initialized. Call initialize() first.',
      );
    }

    try {
      final currentInfo = _currentVersionInfo!;
      final platform = Platform.isAndroid ? 'android' : 'ios';

      final request = AppVersionRequest(
        platform: platform,
        app: 'client',
        current: currentInfo.version,
        build: currentInfo.buildNumberAsInt,
      );

      final response = await _dio.get(
        '/app-version',
        queryParameters: request.toJson(),
        options: Options(
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        print('🔍 Parsing server response: ${response.data}');
        try {
          final result = AppVersionResponse.fromJson(response.data);
          print('✅ Successfully parsed AppVersionResponse');
          return result;
        } catch (parseError) {
          print(
            '❌ Failed to parse AppVersionResponse: ${parseError.toString()}',
          );
          print('❌ Response data: ${response.data}');
          throw Exception(
            'Failed to parse server response: ${parseError.toString()}',
          );
        }
      } else {
        throw Exception('Invalid response from server');
      }
    } on DioException catch (e) {
      // Handle different types of Dio errors
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw Exception(
          'Connection timeout. Please check your internet connection.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('No internet connection. Please check your network.');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Version check endpoint not found.');
      } else if (e.response?.statusCode != null &&
          e.response!.statusCode! >= 500) {
        throw Exception('Server error. Please try again later.');
      } else {
        throw Exception('Failed to check app version: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;

  /// Get platform name
  String get platformName => Platform.isAndroid ? 'android' : 'ios';

  /// Get store URL based on platform
  String getStoreUrl(String packageName) {
    if (Platform.isAndroid) {
      return 'https://play.google.com/store/apps/details?id=$packageName';
    } else if (Platform.isIOS) {
      return 'https://apps.apple.com/app/id$packageName';
    }
    return '';
  }

  /// Reset service (for testing purposes)
  void reset() {
    _isInitialized = false;
    _currentVersionInfo = null;
  }
}
