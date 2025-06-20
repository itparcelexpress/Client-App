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
}) async {
  try {
    // Make the request - any auth errors will be handled by Dio interceptors
    Response response = await getIt<Dio>().request(
      path,
      options: Options(headers: headers, method: reqType),
      data: data,
      queryParameters: queryParameters,
    );

    // Parse the response normally - the interceptors will handle auth errors
    try {
      // Improved logging with response data type info

      // Check if the response data is a Map before parsing
      if (response.data is Map<String, dynamic>) {
        return AppResponse.fromJson(response.data, response.statusCode);
      } else if (response.data is Map) {
        // Convert to Map<String, dynamic> if it's a generic Map
        return AppResponse.fromJson(
          Map<String, dynamic>.from(response.data),
          response.statusCode,
        );
      } else {
        // Handle non-map response types
        return AppResponse(
          data: response.data,
          message: 'Success',
          success: true,
          statusCode: response.statusCode,
          origin: {'raw_response': response.data},
        );
      }
    } catch (e) {
      // Return a fallback response with some debugging info
      return AppResponse(
        data: null,
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
