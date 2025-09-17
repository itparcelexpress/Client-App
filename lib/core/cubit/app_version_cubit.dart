import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/app_version_models.dart';
import '../services/app_version_service.dart';

/// States for AppVersionCubit
abstract class AppVersionState extends Equatable {
  const AppVersionState();

  @override
  List<Object?> get props => [];
}

class AppVersionInitial extends AppVersionState {
  const AppVersionInitial();
}

class AppVersionLoading extends AppVersionState {
  const AppVersionLoading();
}

class AppVersionChecking extends AppVersionState {
  const AppVersionChecking();
}

class AppVersionUpToDate extends AppVersionState {
  const AppVersionUpToDate();
}

class AppVersionUpdateRequired extends AppVersionState {
  final AppVersionResponse versionResponse;
  final bool isForced;

  const AppVersionUpdateRequired({
    required this.versionResponse,
    required this.isForced,
  });

  @override
  List<Object?> get props => [versionResponse, isForced];
}

class AppVersionDismissed extends AppVersionState {
  const AppVersionDismissed();
}

class AppVersionUpdateInProgress extends AppVersionState {
  const AppVersionUpdateInProgress();
}

class AppVersionError extends AppVersionState {
  final String message;
  final bool canContinue;

  const AppVersionError({required this.message, this.canContinue = true});

  @override
  List<Object?> get props => [message, canContinue];
}

/// Cubit for managing app version state
class AppVersionCubit extends Cubit<AppVersionState> {
  final AppVersionService _appVersionService;

  AppVersionCubit({required AppVersionService appVersionService})
    : _appVersionService = appVersionService,
      super(const AppVersionInitial());

  /// Initialize the cubit and check version
  Future<void> initialize() async {
    emit(const AppVersionLoading());

    try {
      if (!_appVersionService.isInitialized) {
        throw Exception('AppVersionService not initialized');
      }

      await checkVersion();
    } catch (e) {
      emit(
        AppVersionError(
          message: 'Failed to initialize version check: ${e.toString()}',
          canContinue: true,
        ),
      );
    }
  }

  /// Check app version against server
  Future<void> checkVersion() async {
    emit(const AppVersionChecking());

    try {
      final versionResponse = await _appVersionService.checkAppVersion();

      print('🔍 Version check result:');
      print('  - isUpdateForced: ${versionResponse.isUpdateForced}');
      print('  - isUpdateAvailable: ${versionResponse.isUpdateAvailable}');
      print('  - mustUpdate: ${versionResponse.mustUpdate}');
      print('  - forceAll: ${versionResponse.forceAll}');
      print('  - shouldUpdate: ${versionResponse.shouldUpdate}');

      if (versionResponse.isUpdateForced) {
        print('🚨 Emitting forced update state');
        emit(
          AppVersionUpdateRequired(
            versionResponse: versionResponse,
            isForced: true,
          ),
        );
      } else if (versionResponse.isUpdateAvailable) {
        print('📱 Emitting optional update state');
        emit(
          AppVersionUpdateRequired(
            versionResponse: versionResponse,
            isForced: false,
          ),
        );
      } else {
        print('✅ Emitting up to date state');
        emit(const AppVersionUpToDate());
      }
    } catch (e) {
      print('❌ Version check failed with error: ${e.toString()}');
      print('❌ Error type: ${e.runtimeType}');
      if (e is Exception) {
        print('❌ Exception details: ${e.toString()}');
      }
      // Allow app to continue if version check fails
      emit(
        AppVersionError(
          message: 'Version check failed: ${e.toString()}',
          canContinue: true,
        ),
      );
    }
  }

  /// Dismiss update dialog (only for non-forced updates)
  void dismissUpdate() {
    if (state is AppVersionUpdateRequired) {
      final currentState = state as AppVersionUpdateRequired;
      if (!currentState.isForced) {
        emit(const AppVersionDismissed());
      }
    }
  }

  /// Force update by opening store
  Future<void> forceUpdate() async {
    emit(const AppVersionUpdateInProgress());

    try {
      if (state is AppVersionUpdateRequired) {
        final currentState = state as AppVersionUpdateRequired;
        final storeUrl = currentState.versionResponse.storeUrl;

        if (storeUrl != null && storeUrl.isNotEmpty) {
          final uri = Uri.parse(storeUrl);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            throw Exception('Cannot open store URL');
          }
        } else {
          throw Exception('Store URL not available');
        }
      } else {
        throw Exception('No update information available');
      }
    } catch (e) {
      emit(
        AppVersionError(
          message: 'Failed to open store: ${e.toString()}',
          canContinue: false,
        ),
      );
    }
  }

  /// Reset cubit state
  void reset() {
    emit(const AppVersionInitial());
  }

  /// Get current version info
  CurrentAppVersionInfo? getCurrentVersionInfo() {
    try {
      return _appVersionService.getCurrentVersionInfo();
    } catch (e) {
      return null;
    }
  }

  /// Check if update is required
  bool get isUpdateRequired {
    return state is AppVersionUpdateRequired;
  }

  /// Check if update is forced
  bool get isUpdateForced {
    if (state is AppVersionUpdateRequired) {
      final currentState = state as AppVersionUpdateRequired;
      return currentState.isForced;
    }
    return false;
  }

  /// Check if app can continue (not in forced update state)
  bool get canContinue {
    return !isUpdateForced && state is! AppVersionUpdateInProgress;
  }
}
