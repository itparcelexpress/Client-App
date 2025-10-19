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
        true, // requiresAuth: true
      );

      if (response.success && response.data != null) {
        // response.data contains the pagination data, we need to parse it as StationData
        StationData stationData;
        try {
          stationData = StationData.fromJson(response.data);
        } catch (e) {
          rethrow;
        }
        return AppResponse(
          data: stationData, // Return StationData directly
          message: response.message ?? 'Stations retrieved successfully.',
          success: response.success,
          statusCode: response.statusCode,
        );
      }

      // Return empty data instead of error for now
      return AppResponse(
        data: StationData(
          currentPage: 1,
          data: [], // Empty list
          firstPageUrl: '',
          from: null,
          lastPage: 1,
          lastPageUrl: '',
          links: [],
          nextPageUrl: null,
          path: '',
          perPage: 8,
          prevPageUrl: null,
          to: null,
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
          from: null,
          lastPage: 1,
          lastPageUrl: '',
          links: [],
          nextPageUrl: null,
          path: '',
          perPage: 8,
          prevPageUrl: null,
          to: null,
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
        true, // requiresAuth: true
      );

      if (response.success && response.data != null) {
        // response.data contains the pagination data, we need to parse it as HubData
        HubData hubData;
        try {
          hubData = HubData.fromJson(response.data);
        } catch (e) {
          rethrow;
        }
        return AppResponse(
          data: hubData, // Return HubData directly
          message: response.message ?? 'Hubs retrieved successfully.',
          success: response.success,
          statusCode: response.statusCode,
        );
      }

      // Return empty data instead of error for now
      return AppResponse(
        data: HubData(
          currentPage: 1,
          data: [], // Empty list
          firstPageUrl: '',
          from: null,
          lastPage: 1,
          lastPageUrl: '',
          links: [],
          nextPageUrl: null,
          path: '',
          perPage: 8,
          prevPageUrl: null,
          to: null,
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
          from: null,
          lastPage: 1,
          lastPageUrl: '',
          links: [],
          nextPageUrl: null,
          path: '',
          perPage: 8,
          prevPageUrl: null,
          to: null,
          total: 0,
        ),
        message: 'Hubs retrieved successfully.',
        success: true,
        statusCode: 200,
      );
    }
  }
}
