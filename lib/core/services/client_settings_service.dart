import 'package:client_app/core/models/client_settings_models.dart';
import 'package:client_app/core/utilities/app_endpoints.dart';
import 'package:client_app/data/remote/app_request.dart';
import 'package:client_app/data/remote/helper/app_response.dart';
import 'package:dio/dio.dart';

class ClientSettingsService {
  // Get client settings
  static Future<ClientSettingsResponse?> getClientSettings(int userId) async {
    try {
      print('🟢 Fetching client settings for user ID: $userId');
      final endpoint = '${AppEndPoints.clientSettings}/$userId';
      print('🟢 GET Endpoint: $endpoint');

      final AppResponse response = await AppRequest.get(
        endpoint,
        true, // isAuth
      );

      print('🟢 Response success: ${response.success}');
      print('🟢 Response data: ${response.origin}');

      if (response.success && response.origin != null) {
        return ClientSettingsResponse.fromJson(response.origin!);
      } else {
        print('🔴 API Error: ${response.message}');
        return null;
      }
    } catch (e) {
      print('🔴 Error fetching client settings: $e');
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
      print(
        '🟢 Updating client settings for user ID: $userId, client ID: $clientId',
      );
      print(
        '🟢 WhatsApp: ${notifications.whatsapp}, Email: ${notifications.email}',
      );

      // Create FormData for the request - API expects form-data with bracket notation
      final formData = FormData.fromMap({
        'client_id': clientId,
        'notifications[whatsapp]': notifications.whatsapp,
        'notifications[email]': notifications.email,
      });

      final endpoint = '${AppEndPoints.clientSettings}/$userId/update';
      print('🟢 POST Endpoint: $endpoint');
      print('🟢 FormData: ${formData.fields}');

      final AppResponse response = await AppRequest.post(
        endpoint,
        true, // isAuth
        data: formData,
      );

      print('🟢 Update Response success: ${response.success}');
      print('🟢 Update Response data: ${response.origin}');

      if (response.success && response.origin != null) {
        return ClientSettingsResponse.fromJson(response.origin!);
      } else {
        print('🔴 Update API Error: ${response.message}');
        return null;
      }
    } catch (e) {
      print('🔴 Error updating client settings: $e');
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
