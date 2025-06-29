import 'dart:convert';

import 'package:client_app/core/utilities/app_endpoints.dart';
import 'package:client_app/data/local/local_data.dart';
import 'package:client_app/data/remote/app_request.dart';
import 'package:client_app/data/remote/helper/app_response.dart';
import 'package:client_app/features/pricing/data/models/pricing_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PricingRepository {
  /// Fetch client pricing data
  Future<PricingResponse> getClientPricing(int userId) async {
    try {
      final AppResponse response = await AppRequest.get(
        AppEndPoints.clientPricing(userId),
        true, // requires authentication
      );

      if (kDebugMode) {
        print('🟢 Pricing Response: ${response.origin}');
      }

      if (response.success && response.origin != null) {
        final pricingResponse = PricingResponse.fromJson(response.origin!);

        // Enhance pricing data with state names
        final enhancedPricingData = await _enhancePricingWithStateNames(
          pricingResponse.data,
        );

        return pricingResponse.copyWith(data: enhancedPricingData);
      } else {
        // Extract error message from API response
        String errorMessage =
            response.message ?? 'Failed to fetch pricing data';

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
        print('🔴 Pricing Repository Error: $e');
      }
      throw Exception('Error fetching pricing data: ${e.toString()}');
    }
  }

  /// Enhance pricing data with state names from asset file
  Future<List<PricingData>> _enhancePricingWithStateNames(
    List<PricingData> pricingData,
  ) async {
    try {
      // Load states from assets
      final statesJson = await rootBundle.loadString(
        'assets/jsons/states.json',
      );
      final statesData = jsonDecode(statesJson);

      // Create a map for quick lookup
      final stateMap = <int, String>{};
      if (statesData['data'] != null) {
        for (final state in statesData['data']) {
          stateMap[state['id']] = state['en_name'] ?? 'Unknown State';
        }
      }

      // Enhance pricing data with state names
      return pricingData.map((pricing) {
        return pricing.copyWith(
          stateName: stateMap[pricing.stateId] ?? 'Unknown State',
          countryName: 'Oman', // Default country for now
        );
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('🟡 Warning: Could not enhance pricing with state names: $e');
      }
      // Return original data if enhancement fails
      return pricingData;
    }
  }

  /// Get current user ID from local data
  int? getCurrentUserId() {
    final user = LocalData.user;
    return user?.id;
  }

  /// Fetch pricing for current logged-in user
  Future<PricingResponse> getCurrentClientPricing() async {
    final userId = getCurrentUserId();
    if (userId == null) {
      throw Exception('No user ID found. Please log in again.');
    }
    return getClientPricing(userId);
  }
}

// Extension to add copyWith method to PricingResponse
extension PricingResponseExtension on PricingResponse {
  PricingResponse copyWith({
    String? message,
    bool? success,
    List<PricingData>? data,
    List<dynamic>? errors,
  }) {
    return PricingResponse(
      message: message ?? this.message,
      success: success ?? this.success,
      data: data ?? this.data,
      errors: errors ?? this.errors,
    );
  }
}
