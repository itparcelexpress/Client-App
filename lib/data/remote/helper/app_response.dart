import 'dart:developer' as dev;

class AppResponse {
  dynamic data;
  String? message;
  late bool success;
  int? statusCode;
  Map<String, dynamic>? origin;

  AppResponse({
    this.data,
    this.message,
    this.success = false,
    this.statusCode,
    this.origin,
  });

  AppResponse.fromJson(
    Map<String, dynamic> json,
    this.statusCode, {
    Map<String, dynamic>? originData,
  }) {
    dev.log('AppResponse.fromJson - Raw JSON: $json');
    origin = json;

    // Handle data field
    data = json['data'];
    dev.log('AppResponse.fromJson - Parsed data: $data');

    // Handle message field
    message = json['message']?.toString() ?? json['msg']?.toString() ?? '';
    dev.log('AppResponse.fromJson - Parsed message: $message');

    // Handle success field - simplified logic
    success =
        json['success'] == true ||
        (statusCode != null && statusCode! >= 200 && statusCode! < 300);

    dev.log(
      'AppResponse.fromJson - Parsed success: $success (from json: ${json['success']}, statusCode: $statusCode)',
    );

    // Validate response structure
    if (success && data == null) {
      dev.log('Warning: Response marked as success but data is null');
    }
  }
}
