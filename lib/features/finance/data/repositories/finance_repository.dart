import 'package:client_app/core/utilities/app_endpoints.dart';
import 'package:client_app/core/utilities/error_message_sanitizer.dart';
import 'package:client_app/core/utilities/global_error_mapper.dart';
import 'package:client_app/data/remote/app_request.dart';
import 'package:client_app/data/remote/helper/app_response.dart';
import 'package:client_app/features/finance/data/models/finance_filter_model.dart';
import 'package:client_app/features/finance/data/models/finance_models.dart';
import 'package:client_app/features/finance/data/models/settlement_request_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Abstract repository interface for finance operations
abstract class FinanceRepository {
  /// Get client account finance data
  Future<FinanceResponse> getClientAccount({
    int page = 1,
    int perPage = 10,
    FinanceFilter? filter,
  });

  /// Submit a settlement request
  Future<SettlementRequestResponse> submitSettlementRequest({
    required double amount,
    required String notes,
    required BuildContext context,
  });
}

/// Implementation of finance repository
class FinanceRepositoryImpl implements FinanceRepository {
  @override
  Future<FinanceResponse> getClientAccount({
    int page = 1,
    int perPage = 10,
    FinanceFilter? filter,
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, dynamic>{'page': page, 'per_page': perPage};

      // Add filter parameters if filter is provided
      if (filter != null) {
        queryParams.addAll(filter.queryParameters);
      }

      final AppResponse response = await AppRequest.get(
        AppEndPoints.clientAccount,
        true, // requires authentication
        queryParameters: queryParams,
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

        throw Exception(ErrorMessageSanitizer.sanitize(errorMessage));
      }
    } catch (e) {
      if (kDebugMode) {
        print('🔴 Finance Repository Error: $e');
      }
      throw Exception(
        ErrorMessageSanitizer.sanitize(
          'Error fetching finance data: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<SettlementRequestResponse> submitSettlementRequest({
    required double amount,
    required String notes,
    required BuildContext context,
  }) async {
    try {
      final AppResponse response = await AppRequest.post(
        AppEndPoints.settlementRequests,
        true, // requires authentication
        data: {'amount': amount.toString(), 'notes': notes},
      );

      if (kDebugMode) {
        print('💰 Settlement Request Response: ${response.origin}');
      }

      if (response.success && response.origin != null) {
        final settlementResponse = SettlementRequestResponse.fromJson(
          response.origin!,
        );

        if (kDebugMode) {
          print('💰 Settlement Request Success: ${settlementResponse.message}');
        }

        return settlementResponse;
      } else {
        // Use the global error mapper to get localized error message
        final localizedErrorMessage =
            GlobalErrorMapper.mapErrorToLocalizedMessage(
              message: response.message,
              errors: response.origin?['errors'] as List<String>?,
              data: response.origin?['data'] as Map<String, dynamic>?,
              statusCode: response.statusCode,
              context: context,
            );

        throw Exception(localizedErrorMessage);
      }
    } catch (e) {
      if (kDebugMode) {
        print('🔴 Settlement Request Repository Error: $e');
      }

      // Use the global error mapper for any other errors
      final localizedErrorMessage = GlobalErrorMapper.sanitizeAndMapError(
        error: e,
        context: context,
        message: e.toString(),
      );

      throw Exception(localizedErrorMessage);
    }
  }
}
