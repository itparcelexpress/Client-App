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
    origin = json;

    // Debug log for response structure

    if (json.containsKey('data') && json['data'] != null) {
      data = json['data'];
      if (data is Map) {}
    } else {
      data = null;
    }

    if (json.containsKey('message') && json['message'] != null) {
      message = json['message'].toString();
    } else if (json.containsKey('msg') && json['msg'] != null) {
      message = json['msg'].toString();
    } else {
      message = '';
    }

    if (json.containsKey('success')) {
      if (json['success'] is bool) {
        success = json['success'];
      } else if (json['success'] is List) {
        // CRITICAL FIX: For this API, an empty list [] means success!
        // The actual presence of the 'success' key with any value means success
        success = true;
      } else {
        success = json['success'].toString() == 'true';
      }
    } else {
      success = statusCode != null && statusCode! >= 200 && statusCode! < 300;
    }

    // Final debug log of processed response
  }
}
