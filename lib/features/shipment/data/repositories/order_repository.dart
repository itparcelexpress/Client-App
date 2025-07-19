import 'package:client_app/core/utilities/app_endpoints.dart';
import 'package:client_app/core/utilities/error_message_sanitizer.dart';
import 'package:client_app/data/remote/app_request.dart';
import 'package:client_app/data/remote/helper/app_response.dart';
import 'package:client_app/features/shipment/data/models/order_models.dart';

class OrderRepository {
  // Create new order
  Future<CreateOrderResponse> createOrder(CreateOrderRequest request) async {
    try {
      final AppResponse response = await AppRequest.post(
        AppEndPoints.createOrder,
        true, // requires authentication
        data: request.toJson(),
      );

      if (response.success) {
        // Parse from response.origin which contains the full API response
        return CreateOrderResponse.fromJson(response.origin!);
      } else {
        // Use the error sanitizer to make error messages user-friendly
        String errorMessage = ErrorMessageSanitizer.sanitizeApiError(
          response.origin,
        );
        throw Exception(errorMessage);
      }
    } catch (e) {
      // Sanitize the error message to make it user-friendly
      String errorMessage = ErrorMessageSanitizer.sanitize(e.toString());
      throw Exception(errorMessage);
    }
  }

  // Get user orders (for listing)
  Future<List<OrderSummary>> getUserOrders() async {
    try {
      final AppResponse response = await AppRequest.get(
        AppEndPoints.orders,
        true, // requires authentication
      );

      if (response.success) {
        final List<dynamic> ordersJson = response.data['data'] ?? [];
        return ordersJson
            .map((json) => OrderSummary.fromOrderData(OrderData.fromJson(json)))
            .toList();
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

  // Get order details by ID
  Future<OrderData> getOrderDetails(int orderId) async {
    try {
      final AppResponse response = await AppRequest.get(
        AppEndPoints.orderDetails(orderId),
        true, // requires authentication
      );

      if (response.success) {
        return OrderData.fromJson(response.data['data']);
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

  // Get client pickup orders (new API)
  Future<GetOrdersResponse> getClientOrders({
    String? status,
    String? fromDate,
    String? toDate,
    String? query,
    int page = 1,
  }) async {
    try {
      Map<String, dynamic> queryParams = {'page': page.toString()};

      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }
      if (fromDate != null && fromDate.isNotEmpty) {
        queryParams['from_date'] = fromDate;
      }
      if (toDate != null && toDate.isNotEmpty) {
        queryParams['to_date'] = toDate;
      }
      if (query != null && query.isNotEmpty) {
        queryParams['query'] = query;
      }

      final AppResponse response = await AppRequest.get(
        AppEndPoints.clientOrders,
        true, // requires authentication
        queryParameters: queryParams,
      );

      if (response.success) {
        // Parse from response.origin which contains the full API response
        return GetOrdersResponse.fromJson(response.origin!);
      } else {
        // Use the error sanitizer to make error messages user-friendly
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
