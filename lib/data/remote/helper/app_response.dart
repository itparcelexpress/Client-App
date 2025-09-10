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

    // Determine success considering APIs that return 200 with error payloads
    final dynamic successField = json['success'];
    final dynamic errorsField = json['errors'];

    bool hasErrors = false;
    if (errorsField != null) {
      if (errorsField is List) {
        hasErrors = errorsField.isNotEmpty;
      } else if (errorsField is Map) {
        hasErrors = errorsField.isNotEmpty;
      } else {
        // Non-null scalar (e.g., numeric error code like 402)
        hasErrors = true;
      }
    }

    bool successFromField = false;
    if (successField is bool) {
      successFromField = successField;
    } else if (successField is List) {
      // Some endpoints use empty array to indicate success
      successFromField = successField.isEmpty && !hasErrors;
    }

    final bool successFromStatus =
        (statusCode != null && statusCode! >= 200 && statusCode! < 300);
    final bool hasData =
        json['data'] != null && json['data'].toString().isNotEmpty;

    // Require 2xx, no errors, and either explicit success or data present
    success = successFromStatus && !hasErrors && (successFromField || hasData);

    dev.log(
      'AppResponse.fromJson - Parsed success: $success (from json: ${json['success']}, statusCode: $statusCode)',
    );

    // Validate response structure
    if (success && data == null) {
      dev.log('Warning: Response marked as success but data is null');
    }
  }
}
