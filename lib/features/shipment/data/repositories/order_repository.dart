import 'package:client_app/core/utilities/app_endpoints.dart';
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
        // Extract error message from API response
        String errorMessage = response.message ?? 'Failed to create order';

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
      throw Exception('Error creating order: ${e.toString()}');
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
        throw Exception(response.message ?? 'Failed to fetch orders');
      }
    } catch (e) {
      throw Exception('Error fetching orders: ${e.toString()}');
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
        throw Exception(response.message ?? 'Failed to fetch order details');
      }
    } catch (e) {
      throw Exception('Error fetching order details: ${e.toString()}');
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
        // Extract error message from API response
        String errorMessage = response.message ?? 'Failed to fetch orders';

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
      throw Exception('Error fetching client orders: ${e.toString()}');
    }
  }
}
