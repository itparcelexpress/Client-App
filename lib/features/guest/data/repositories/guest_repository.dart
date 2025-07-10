import 'dart:developer' as dev;

import 'package:client_app/core/utilities/app_endpoints.dart';
import 'package:client_app/data/remote/app_request.dart';
import 'package:client_app/features/guest/data/models/guest_order_models.dart';

class GuestRepository {
  Future<GuestOrderResponse> createGuestOrder(GuestOrderRequest request) async {
    try {
      final response = await AppRequest.post(
        AppEndPoints.customerOrders,
        false, // Not an authenticated request
        data: request.toJson(),
      );

      dev.log('Raw API Response: ${response.data}');

      if (response.data == null) {
        dev.log('Response data is null');
        return GuestOrderResponse(
          message: 'No data received from server',
          success: false,
          data: null,
          errors: ['Empty response from server'],
        );
      }

      // Convert response data to Map<String, dynamic> if it isn't already
      final Map<String, dynamic> responseData = {
        'success': response.success,
        'message': response.message ?? '',
        'data': response.data,
        'errors': [],
      };

      dev.log('Response data converted to Map: $responseData');

      final guestOrderResponse = GuestOrderResponse.fromJson(responseData);
      dev.log(
        'Parsed GuestOrderResponse - success: ${guestOrderResponse.success}, message: ${guestOrderResponse.message}',
      );

      return guestOrderResponse;
    } catch (e, stackTrace) {
      dev.log('Error in createGuestOrder: $e\n$stackTrace');
      return GuestOrderResponse(
        message: 'Failed to create order: ${e.toString()}',
        success: false,
        data: null,
        errors: [e.toString()],
      );
    }
  }
}
