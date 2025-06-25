import 'package:client_app/core/models/client_settings_models.dart';
import 'package:client_app/core/services/client_settings_service.dart';

class ClientSettingsRepository {
  // Get client settings
  Future<ClientSettingsResponse?> getClientSettings(int clientId) async {
    return await ClientSettingsService.getClientSettings(clientId);
  }

  // Update client settings
  Future<ClientSettingsResponse?> updateClientSettings(
    int userId,
    int clientId,
    NotificationSettings notifications,
  ) async {
    return await ClientSettingsService.updateClientSettings(
      userId,
      clientId,
      notifications,
    );
  }

  // Toggle WhatsApp notifications
  Future<ClientSettingsResponse?> toggleWhatsAppNotifications(
    int userId,
    int clientId,
    bool currentWhatsAppSetting,
    bool currentEmailSetting,
  ) async {
    return await ClientSettingsService.toggleWhatsAppNotifications(
      userId,
      clientId,
      currentWhatsAppSetting,
      currentEmailSetting,
    );
  }

  // Toggle Email notifications
  Future<ClientSettingsResponse?> toggleEmailNotifications(
    int userId,
    int clientId,
    bool currentWhatsAppSetting,
    bool currentEmailSetting,
  ) async {
    return await ClientSettingsService.toggleEmailNotifications(
      userId,
      clientId,
      currentWhatsAppSetting,
      currentEmailSetting,
    );
  }
}
