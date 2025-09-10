import 'package:client_app/core/utilities/app_endpoints.dart';
import 'package:client_app/core/utilities/error_message_sanitizer.dart';
import 'package:client_app/data/remote/app_request.dart';
import 'package:client_app/data/remote/helper/app_response.dart';
import 'package:client_app/features/invoices/data/models/invoice_models.dart';

class WalletRepository {
  const WalletRepository();

  Future<WalletResponse> getWallet({int page = 1, int perPage = 20}) async {
    try {
      final AppResponse response = await AppRequest.get(
        AppEndPoints.clientWallet,
        true,
        queryParameters: {'page': page, 'per_page': perPage},
      );

      if (response.success && response.origin != null) {
        return WalletResponse.fromJson(response.origin!);
      } else {
        String errorMessage = ErrorMessageSanitizer.sanitizeApiError(
          response.origin,
        );
        throw Exception(errorMessage);
      }
    } catch (e) {
      String errorMessage = ErrorMessageSanitizer.sanitize(e.toString());
      throw Exception(errorMessage);
    }
  }
}
