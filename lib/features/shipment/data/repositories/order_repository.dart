import 'package:client_app/data/remote/app_request.dart';
import 'package:client_app/data/remote/helper/app_response.dart';
import 'package:client_app/features/shipment/data/models/order_models.dart';
import 'package:dio/dio.dart';

class OrderRepository {
  // Create new order
  Future<CreateOrderResponse> createOrder(CreateOrderRequest request) async {
    try {
      final AppResponse response = await AppRequest.post(
        'orders/store',
        true, // requires authentication
        data: request.toJson(),
      );

      if (response.success) {
        return CreateOrderResponse.fromJson(response.data);
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

        return CreateOrderResponse(
          success: false,
          message: errorMessage,
          data: const OrderData(
            paymentType: '',
            deliveryFee: '',
            clientId: '',
            trackingNo: '',
            createdBy: 0,
            consigneeId: 0,
            amount: 0,
            ownerId: '',
            ownerType: '',
            updatedAt: '',
            createdAt: '',
            id: 0,
            consignee: Consignee(
              id: 0,
              countryId: 0,
              governorateId: 0,
              stateId: 0,
              placeId: 0,
              name: '',
              email: '',
              cellphone: '',
              alternatePhone: '',
              zipcode: '',
              streetAddress: '',
              addressConfirmed: 0,
              createdAt: '',
              updatedAt: '',
            ),
            orderItems: [],
          ),
          errors: response.origin?['errors'] ?? [],
        );
      }
    } catch (e) {
      // Handle DioException specifically to extract server error details
      if (e is DioException && e.response != null) {
        final responseData = e.response!.data;
        if (responseData is Map<String, dynamic>) {
          String errorMessage =
              responseData['message'] ?? 'Server error occurred';

          // Extract specific errors if available
          if (responseData['errors'] != null &&
              responseData['errors'] is List) {
            final errors = responseData['errors'] as List;
            if (errors.isNotEmpty) {
              errorMessage = errors.join(', ');
            }
          }

          return CreateOrderResponse(
            success: false,
            message: errorMessage,
            data: const OrderData(
              paymentType: '',
              deliveryFee: '',
              clientId: '',
              trackingNo: '',
              createdBy: 0,
              consigneeId: 0,
              amount: 0,
              ownerId: '',
              ownerType: '',
              updatedAt: '',
              createdAt: '',
              id: 0,
              consignee: Consignee(
                id: 0,
                countryId: 0,
                governorateId: 0,
                stateId: 0,
                placeId: 0,
                name: '',
                email: '',
                cellphone: '',
                alternatePhone: '',
                zipcode: '',
                streetAddress: '',
                addressConfirmed: 0,
                createdAt: '',
                updatedAt: '',
              ),
              orderItems: [],
            ),
            errors: responseData['errors'] ?? [],
          );
        }
      }

      return CreateOrderResponse(
        success: false,
        message: 'Error creating order: ${e.toString()}',
        data: const OrderData(
          paymentType: '',
          deliveryFee: '',
          clientId: '',
          trackingNo: '',
          createdBy: 0,
          consigneeId: 0,
          amount: 0,
          ownerId: '',
          ownerType: '',
          updatedAt: '',
          createdAt: '',
          id: 0,
          consignee: Consignee(
            id: 0,
            countryId: 0,
            governorateId: 0,
            stateId: 0,
            placeId: 0,
            name: '',
            email: '',
            cellphone: '',
            alternatePhone: '',
            zipcode: '',
            streetAddress: '',
            addressConfirmed: 0,
            createdAt: '',
            updatedAt: '',
          ),
          orderItems: [],
        ),
        errors: [],
      );
    }
  }

  // Get user orders (for listing)
  Future<List<OrderSummary>> getUserOrders() async {
    try {
      final AppResponse response = await AppRequest.get(
        'orders',
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
        'orders/$orderId',
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
}
