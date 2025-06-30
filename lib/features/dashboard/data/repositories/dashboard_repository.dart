import 'package:client_app/core/utilities/app_endpoints.dart';
import 'package:client_app/data/remote/app_request.dart';
import 'package:client_app/data/remote/helper/app_response.dart';
import 'package:client_app/features/dashboard/data/models/dashboard_models.dart';

class DashboardRepository {
  // Get dashboard statistics
  Future<DashboardResponse> getDashboardStats() async {
    try {
      final AppResponse response = await AppRequest.get(
        AppEndPoints.clientDashboard,
        true, // requires authentication
      );

      if (response.success) {
        return DashboardResponse.fromJson(response.origin!);
      } else {
        // Extract error message from API response
        String errorMessage =
            response.message ?? 'Failed to fetch dashboard data';

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
      throw Exception('Error fetching dashboard data: ${e.toString()}');
    }
  }
}
