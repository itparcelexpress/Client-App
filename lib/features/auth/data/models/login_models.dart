import 'package:client_app/core/models/user_model.dart';

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}

class LoginResponse {
  final String? message;
  final bool success;
  final UserModel? data;
  final List<String>? errors;

  LoginResponse({this.message, required this.success, this.data, this.errors});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    // Handle the new API response format where success is an empty array
    bool isSuccess = false;
    if (json['success'] is List) {
      // If success is a list (empty array means success)
      isSuccess = json['success'] is List && json['data'] != null;
    } else if (json['success'] is bool) {
      isSuccess = json['success'];
    }

    return LoginResponse(
      message: json['message'],
      success: isSuccess,
      data: json['data'] != null ? UserModel.fromJson(json['data']) : null,
      errors: json['errors'] != null ? List<String>.from(json['errors']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'success': success,
      'data': data?.toJson(),
      'errors': errors,
    };
  }
}
