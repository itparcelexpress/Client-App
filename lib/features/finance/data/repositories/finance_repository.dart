import 'package:client_app/core/utilities/app_endpoints.dart';
import 'package:client_app/data/remote/app_request.dart';
import 'package:client_app/data/remote/helper/app_response.dart';
import 'package:client_app/features/finance/data/models/finance_models.dart';
import 'package:flutter/foundation.dart';

/// Abstract repository interface for finance operations
abstract class FinanceRepository {
  /// Get client account finance data
  Future<FinanceResponse> getClientAccount({int page = 1, int perPage = 10});
}

/// Implementation of finance repository
class FinanceRepositoryImpl implements FinanceRepository {
  @override
  Future<FinanceResponse> getClientAccount({
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final AppResponse response = await AppRequest.get(
        AppEndPoints.clientAccount,
        true, // requires authentication
        queryParameters: {'page': page, 'per_page': perPage},
      );

      if (kDebugMode) {
        print('💰 Finance Response: ${response.origin}');
      }

      if (response.success && response.origin != null) {
        final financeResponse = FinanceResponse.fromJson(response.origin!);

        if (kDebugMode) {
          print(
            '💰 Parsed Finance Data: ${financeResponse.data.transactions.length} transactions',
          );
        }

        return financeResponse;
      } else {
        // Extract error message from API response
        String errorMessage =
            response.message ?? 'Failed to fetch finance data';

        // Check if there are specific errors in the response
        if (response.origin != null) {
          final origin = response.origin!;
          if (origin['errors'] != null && origin['errors'] is List) {
            final errors = origin['errors'] as List;
            if (errors.isNotEmpty) {
              errorMessage = errors.join(', ');
            }
          }
        }

        throw Exception(errorMessage);
      }
    } catch (e) {
      if (kDebugMode) {
        print('🔴 Finance Repository Error: $e');
      }
      throw Exception('Error fetching finance data: ${e.toString()}');
    }
  }
}
