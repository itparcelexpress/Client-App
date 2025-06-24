import 'package:client_app/core/models/client_settings_models.dart';
import 'package:client_app/core/services/client_settings_service.dart';

class ClientSettingsRepository {
  // Get client settings
  Future<ClientSettingsResponse?> getClientSettings(int clientId) async {
    return await ClientSettingsService.getClientSettings(clientId);
  }

  // Update client settings
  Future<ClientSettingsResponse?> updateClientSettings(
    int clientId,
    NotificationSettings notifications,
  ) async {
    return await ClientSettingsService.updateClientSettings(
      clientId,
      notifications,
    );
  }

  // Toggle WhatsApp notifications
  Future<ClientSettingsResponse?> toggleWhatsAppNotifications(
    int clientId,
    bool currentWhatsAppSetting,
    bool currentEmailSetting,
  ) async {
    return await ClientSettingsService.toggleWhatsAppNotifications(
      clientId,
      currentWhatsAppSetting,
      currentEmailSetting,
    );
  }

  // Toggle Email notifications
  Future<ClientSettingsResponse?> toggleEmailNotifications(
    int clientId,
    bool currentWhatsAppSetting,
    bool currentEmailSetting,
  ) async {
    return await ClientSettingsService.toggleEmailNotifications(
      clientId,
      currentWhatsAppSetting,
      currentEmailSetting,
    );
  }
}
