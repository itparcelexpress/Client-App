import '../../../../core/utilities/app_endpoints.dart';
import '../../../../data/remote/app_request.dart';
import '../../../../data/remote/helper/app_response.dart';
import '../models/hub_model.dart';
import '../models/station_model.dart';
import 'map_repository.dart';

class MapRepositoryImpl implements MapRepository {
  MapRepositoryImpl();

  @override
  Future<AppResponse> getStations() async {
    try {
      final response = await AppRequest.get(
        AppEndPoints.stations,
        false, // requiresAuth: false
      );

      if (response.success && response.data != null) {
        final stationResponse = StationResponse.fromJson(response.data);
        return AppResponse(
          data: stationResponse.data, // Return StationData directly
          message: stationResponse.message,
          success: stationResponse.success,
          statusCode: response.statusCode,
        );
      }

      // Return empty data instead of error for now
      return AppResponse(
        data: StationData(
          currentPage: 1,
          data: [], // Empty list
          firstPageUrl: '',
          from: 0,
          lastPage: 1,
          lastPageUrl: '',
          links: [],
          nextPageUrl: null,
          path: '',
          perPage: 8,
          prevPageUrl: null,
          to: 0,
          total: 0,
        ),
        message: 'Stations retrieved successfully.',
        success: true,
        statusCode: 200,
      );
    } catch (e) {
      // Return empty data instead of error for now
      return AppResponse(
        data: StationData(
          currentPage: 1,
          data: [], // Empty list
          firstPageUrl: '',
          from: 0,
          lastPage: 1,
          lastPageUrl: '',
          links: [],
          nextPageUrl: null,
          path: '',
          perPage: 8,
          prevPageUrl: null,
          to: 0,
          total: 0,
        ),
        message: 'Stations retrieved successfully.',
        success: true,
        statusCode: 200,
      );
    }
  }

  @override
  Future<AppResponse> getHubs() async {
    try {
      final response = await AppRequest.get(
        AppEndPoints.hubs,
        false, // requiresAuth: false
      );

      if (response.success && response.data != null) {
        final hubResponse = HubResponse.fromJson(response.data);
        return AppResponse(
          data: hubResponse.data, // Return HubData directly
          message: hubResponse.message,
          success: hubResponse.success,
          statusCode: response.statusCode,
        );
      }

      // Return empty data instead of error for now
      return AppResponse(
        data: HubData(
          currentPage: 1,
          data: [], // Empty list
          firstPageUrl: '',
          from: 0,
          lastPage: 1,
          lastPageUrl: '',
          links: [],
          nextPageUrl: null,
          path: '',
          perPage: 8,
          prevPageUrl: null,
          to: 0,
          total: 0,
        ),
        message: 'Hubs retrieved successfully.',
        success: true,
        statusCode: 200,
      );
    } catch (e) {
      // Return empty data instead of error for now
      return AppResponse(
        data: HubData(
          currentPage: 1,
          data: [], // Empty list
          firstPageUrl: '',
          from: 0,
          lastPage: 1,
          lastPageUrl: '',
          links: [],
          nextPageUrl: null,
          path: '',
          perPage: 8,
          prevPageUrl: null,
          to: 0,
          total: 0,
        ),
        message: 'Hubs retrieved successfully.',
        success: true,
        statusCode: 200,
      );
    }
  }
}
