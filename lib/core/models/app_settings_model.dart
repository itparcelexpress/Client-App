class AppSettingsModel {
  final bool success;
  final String message;
  final AppSettingsData data;
  final List<dynamic> errors;

  AppSettingsModel({
    required this.success,
    required this.message,
    required this.data,
    required this.errors,
  });

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    try {
      return AppSettingsModel(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: AppSettingsData.fromJson(json['data'] ?? {}),
        errors: json['errors'] ?? [],
      );
    } catch (e) {
      return AppSettingsModel(
        success: false,
        message: 'Error parsing response: $e',
        data: AppSettingsData(value: ''),
        errors: [],
      );
    }
  }
}

class AppSettingsData {
  final String value;

  AppSettingsData({
    required this.value,
  });

  factory AppSettingsData.fromJson(Map<String, dynamic> json) {
    try {
      return AppSettingsData(
        value: json['value'] ?? '',
      );
    } catch (e) {
      return AppSettingsData(value: '');
    }
  }

  String getFullImageUrl() {
    if (value.isEmpty) return '';

    // Check if the URL is already absolute
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }

    // Construct the full URL using the correct base URL
    final fullUrl = 'http://16.16.75.11/storage/images/$value';
    return fullUrl;
  }
}
