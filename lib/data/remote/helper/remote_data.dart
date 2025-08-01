import 'dart:convert';

import 'package:client_app/data/remote/app_request.dart';
import 'package:client_app/data/remote/helper/app_response.dart';
import 'package:client_app/injections.dart';
import 'package:dio/dio.dart';

Future<AppResponse> requestDio(
  String path, {
  String reqType = ReqType.get,
  Object? data,
  Map<String, dynamic>? headers,
  Map<String, dynamic>? queryParameters,
  ResponseType? responseType,
}) async {
  try {
    // Make the request - any auth errors will be handled by Dio interceptors
    Response response = await getIt<Dio>().request(
      path,
      options: Options(
        headers: headers,
        method: reqType,
        responseType: responseType,
      ),
      data: data,
      queryParameters: queryParameters,
    );

    // Parse the response based on response type
    try {
      // Handle binary responses (like PDFs)
      if (responseType == ResponseType.bytes) {
        return AppResponse(
          data: response.data,
          message: 'Binary data downloaded successfully',
          success: true,
          statusCode: response.statusCode,
          origin: {'content_type': response.headers.value('content-type')},
        );
      }

      // Ensure we have a Map<String, dynamic>
      Map<String, dynamic> responseData;
      if (response.data is Map<String, dynamic>) {
        responseData = response.data;
      } else if (response.data is Map) {
        responseData = Map<String, dynamic>.from(response.data);
      } else if (response.data is String) {
        // Try to parse string as JSON if needed
        try {
          responseData = jsonDecode(response.data);
        } catch (_) {
          responseData = {
            'data': response.data,
            'message': 'Success',
            'success': true,
          };
        }
      } else {
        responseData = {
          'data': response.data,
          'message': 'Success',
          'success': true,
        };
      }

      return AppResponse.fromJson(
        responseData,
        response.statusCode,
        originData: response.data is Map ? response.data : null,
      );
    } catch (e) {
      // Return a fallback response with some debugging info
      return AppResponse(
        data: response.data,
        message: 'Failed to parse response: ${e.toString()}',
        success: false,
        statusCode: response.statusCode ?? 500,
        origin: {
          'error': 'Parse error',
          'raw_response': response.data.toString(),
        },
      );
    }
  } on DioException catch (e) {
    // If we get here, the interceptors didn't handle it,
    // which means it's not an auth error
    return AppResponse(
      data: null,
      message: e.message ?? 'Network error',
      success: false,
      statusCode: e.response?.statusCode,
      origin:
          e.response?.data is Map<String, dynamic>
              ? e.response?.data
              : {'error': e.toString()},
    );
  } catch (e) {
    return AppResponse(
      data: null,
      message: 'An unexpected error occurred: ${e.toString()}',
      success: false,
      statusCode: 500,
      origin: {'error': e.toString()},
    );
  }
}
