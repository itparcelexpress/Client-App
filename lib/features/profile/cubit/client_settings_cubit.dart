import 'package:bloc/bloc.dart';
import 'package:client_app/core/models/client_settings_models.dart';
import 'package:client_app/features/profile/cubit/client_settings_state.dart';
import 'package:client_app/features/profile/data/repositories/client_settings_repository.dart';

class ClientSettingsCubit extends Cubit<ClientSettingsState> {
  final ClientSettingsRepository _repository;

  ClientSettingsCubit(this._repository) : super(ClientSettingsInitial());

  // Current settings data holder
  ClientSettingsData? _currentSettings;

  // Getter for current settings
  ClientSettingsData? get currentSettings => _currentSettings;

  // Load client settings
  Future<void> loadClientSettings(int userId) async {
    emit(ClientSettingsLoading());

    try {
      final response = await _repository.getClientSettings(userId);

      if (response != null && response.success) {
        _currentSettings = response.data;
        emit(ClientSettingsLoaded(settings: response.data));
      } else {
        emit(const ClientSettingsError('failedToLoadClientSettings'));
      }
    } catch (e) {
      emit(const ClientSettingsError('errorLoadingClientSettings'));
    }
  }

  // Update notification settings
  Future<void> updateNotificationSettings(
    int userId,
    int clientId,
    NotificationSettings notifications,
  ) async {
    if (_currentSettings == null) {
      emit(const ClientSettingsError('noCurrentSettingsAvailable'));
      return;
    }

    emit(ClientSettingsUpdating());

    try {
      final response = await _repository.updateClientSettings(
        userId,
        clientId,
        notifications,
      );

      if (response != null && response.success) {
        _currentSettings = response.data;
        emit(
          ClientSettingsUpdateSuccess(
            updatedSettings: response.data,
            message: response.message,
          ),
        );

        // Return to loaded state with updated data
        emit(ClientSettingsLoaded(settings: response.data));
      } else {
        emit(
          ClientSettingsUpdateError(
            'failedToUpdateNotificationSettings',
            currentSettings: _currentSettings,
          ),
        );
      }
    } catch (e) {
      emit(
        ClientSettingsUpdateError(
          'errorUpdatingNotificationSettings',
          currentSettings: _currentSettings,
        ),
      );
    }
  }

  // Toggle WhatsApp notifications
  Future<void> toggleWhatsAppNotifications(int userId, int clientId) async {
    if (_currentSettings?.notifications == null) {
      emit(const ClientSettingsError('noNotificationSettingsAvailable'));
      return;
    }

    final currentNotifications = _currentSettings!.notifications!;

    try {
      final response = await _repository.toggleWhatsAppNotifications(
        userId,
        clientId,
        currentNotifications.whatsapp,
        currentNotifications.email,
      );

      if (response != null && response.success) {
        _currentSettings = response.data;
        emit(
          ClientSettingsUpdateSuccess(
            updatedSettings: response.data,
            message:
                'WhatsApp notifications ${response.data.notifications?.whatsapp == true ? 'enabled' : 'disabled'}',
          ),
        );

        // Return to loaded state with updated data
        emit(ClientSettingsLoaded(settings: response.data));
      } else {
        emit(
          ClientSettingsUpdateError(
            'Failed to toggle WhatsApp notifications',
            currentSettings: _currentSettings,
          ),
        );
      }
    } catch (e) {
      emit(
        ClientSettingsUpdateError(
          'Error toggling WhatsApp notifications: $e',
          currentSettings: _currentSettings,
        ),
      );
    }
  }

  // Toggle Email notifications
  Future<void> toggleEmailNotifications(int userId, int clientId) async {
    if (_currentSettings?.notifications == null) {
      emit(const ClientSettingsError('noNotificationSettingsAvailable'));
      return;
    }

    final currentNotifications = _currentSettings!.notifications!;

    try {
      final response = await _repository.toggleEmailNotifications(
        userId,
        clientId,
        currentNotifications.whatsapp,
        currentNotifications.email,
      );

      if (response != null && response.success) {
        _currentSettings = response.data;
        emit(
          ClientSettingsUpdateSuccess(
            updatedSettings: response.data,
            message:
                'Email notifications ${response.data.notifications?.email == true ? 'enabled' : 'disabled'}',
          ),
        );

        // Return to loaded state with updated data
        emit(ClientSettingsLoaded(settings: response.data));
      } else {
        emit(
          ClientSettingsUpdateError(
            'Failed to toggle email notifications',
            currentSettings: _currentSettings,
          ),
        );
      }
    } catch (e) {
      emit(
        ClientSettingsUpdateError(
          'Error toggling email notifications: $e',
          currentSettings: _currentSettings,
        ),
      );
    }
  }

  // Refresh client settings
  Future<void> refreshClientSettings(int userId) async {
    await loadClientSettings(userId);
  }

  // Reset to initial state
  void reset() {
    _currentSettings = null;
    emit(ClientSettingsInitial());
  }
}
