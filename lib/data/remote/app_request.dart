import 'package:client_app/data/local/local_data.dart';
import 'package:client_app/data/remote/helper/app_response.dart';
import 'package:client_app/data/remote/helper/remote_data.dart' as remote_data;

class AppRequest {
  static Map<String, dynamic> get headers => {
    'Accept': 'application/json',
    'User-Agent':
        'Mozilla/5.0 (Linux; Android 12; Pixel 6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.115 Mobile Safari/537.36',
  };
  // Request
  static Future<AppResponse> get(
    String path,
    bool isAuth, {
    bool mustAuth = false,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? initHeader,
  }) async {
    AppResponse res = await remote_data.requestDio(
      path,
      reqType: ReqType.get,
      data: data,
      headers:
          (initHeader ?? {})
            ..addAll(headers)
            ..addAll(
              (isAuth && (LocalData.token.isNotEmpty || mustAuth))
                  ? {'Authorization': 'Bearer ${LocalData.token}'}
                  : {},
            ),
      queryParameters: queryParameters,
    );
    return res;
  }

  static Future<AppResponse> post(
    String path,
    bool isAuth, {
    bool mustAuth = false,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? initHeader,
  }) async {
    AppResponse res = await remote_data.requestDio(
      path,
      reqType: ReqType.post,
      data: data,
      headers:
          (initHeader ?? {})
            ..addAll(headers)
            ..addAll(
              (isAuth && (LocalData.token.isNotEmpty || mustAuth))
                  ? {'Authorization': 'Bearer ${LocalData.token}'}
                  : {},
            ),
      queryParameters: queryParameters,
    );
    return res;
  }

  static Future<AppResponse> patch(
    String path,
    bool isAuth, {
    bool mustAuth = false,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? initHeader,
  }) async {
    AppResponse res = await remote_data.requestDio(
      path,
      reqType: ReqType.patch,
      data: data,
      headers:
          (initHeader ?? {})
            ..addAll(headers)
            ..addAll(
              (isAuth && (LocalData.token.isNotEmpty || mustAuth))
                  ? {'Authorization': 'Bearer ${LocalData.token}'}
                  : {},
            ),
      queryParameters: queryParameters,
    );
    return res;
  }
}

class ReqType {
  static const String get = 'GET';
  static const String post = 'POST';
  static const String patch = 'PATCH';
}
