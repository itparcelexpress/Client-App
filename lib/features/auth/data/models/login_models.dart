import 'package:client_app/core/models/user_model.dart';
import 'package:flutter/foundation.dart';

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

    if (kDebugMode) {
      print('🔍 LoginResponse.fromJson - Received json: $json');
      print(
        '🔍 LoginResponse.fromJson - success field: ${json['success']} (type: ${json['success'].runtimeType})',
      );
      print(
        '🔍 LoginResponse.fromJson - errors field: ${json['errors']} (type: ${json['errors'].runtimeType})',
      );
      print(
        '🔍 LoginResponse.fromJson - data field present: ${json['data'] != null}',
      );
    }

    // Check errors first - if errors array is not empty, it's a failure
    bool hasErrors = false;
    if (json['errors'] != null) {
      if (json['errors'] is List) {
        hasErrors = (json['errors'] as List).isNotEmpty;
      } else if (json['errors'] is Map) {
        hasErrors = (json['errors'] as Map).isNotEmpty;
      }
    }

    if (kDebugMode) {
      print('🔍 LoginResponse.fromJson - hasErrors: $hasErrors');
    }

    if (json['success'] is List) {
      // If success is a list, empty array + no errors + data present = success
      final successList = json['success'] as List;
      isSuccess = successList.isEmpty && !hasErrors && json['data'] != null;

      if (kDebugMode) {
        print(
          '🔍 LoginResponse.fromJson - success is List, isEmpty: ${successList.isEmpty}',
        );
        print('🔍 LoginResponse.fromJson - calculated isSuccess: $isSuccess');
      }
    } else if (json['success'] is bool) {
      isSuccess = json['success'] && !hasErrors;

      if (kDebugMode) {
        print(
          '🔍 LoginResponse.fromJson - success is bool: ${json['success']}',
        );
        print('🔍 LoginResponse.fromJson - calculated isSuccess: $isSuccess');
      }
    }

    return LoginResponse(
      message: json['message'],
      success: isSuccess,
      data: json['data'] != null ? UserModel.fromJson(json['data']) : null,
      errors:
          json['errors'] != null && json['errors'] is List
              ? List<String>.from(
                (json['errors'] as List).map((e) => e.toString()),
              )
              : null,
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
