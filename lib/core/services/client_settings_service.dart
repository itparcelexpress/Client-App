import 'package:client_app/core/models/client_settings_models.dart';
import 'package:client_app/core/utilities/app_endpoints.dart';
import 'package:client_app/data/remote/app_request.dart';
import 'package:client_app/data/remote/helper/app_response.dart';
import 'package:dio/dio.dart';

class ClientSettingsService {
  // Get client settings
  static Future<ClientSettingsResponse?> getClientSettings(int clientId) async {
    try {
      final AppResponse response = await AppRequest.get(
        '${AppEndPoints.clientSettings}/$clientId',
        true, // isAuth
      );

      if (response.success && response.origin != null) {
        return ClientSettingsResponse.fromJson(response.origin!);
      }
      return null;
    } catch (e) {
      print('Error fetching client settings: $e');
      return null;
    }
  }

  // Update client settings
  static Future<ClientSettingsResponse?> updateClientSettings(
    int userId,
    int clientId,
    NotificationSettings notifications,
  ) async {
    try {
      // Create FormData for the request - API expects form-data with bracket notation
      final formData = FormData.fromMap({
        'client_id': clientId,
        'notifications[whatsapp]': notifications.whatsapp,
        'notifications[email]': notifications.email,
      });

      final AppResponse response = await AppRequest.post(
        '${AppEndPoints.clientSettings}/$userId/update',
        true, // isAuth
        data: formData,
      );

      if (response.success && response.origin != null) {
        return ClientSettingsResponse.fromJson(response.origin!);
      }
      return null;
    } catch (e) {
      print('Error updating client settings: $e');
      return null;
    }
  }

  // Toggle WhatsApp notifications
  static Future<ClientSettingsResponse?> toggleWhatsAppNotifications(
    int userId,
    int clientId,
    bool currentWhatsAppSetting,
    bool currentEmailSetting,
  ) async {
    final updatedNotifications = NotificationSettings(
      whatsapp: !currentWhatsAppSetting,
      email: currentEmailSetting,
    );

    return await updateClientSettings(userId, clientId, updatedNotifications);
  }

  // Toggle Email notifications
  static Future<ClientSettingsResponse?> toggleEmailNotifications(
    int userId,
    int clientId,
    bool currentWhatsAppSetting,
    bool currentEmailSetting,
  ) async {
    final updatedNotifications = NotificationSettings(
      whatsapp: currentWhatsAppSetting,
      email: !currentEmailSetting,
    );

    return await updateClientSettings(userId, clientId, updatedNotifications);
  }
}
