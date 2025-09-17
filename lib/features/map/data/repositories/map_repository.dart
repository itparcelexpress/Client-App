import '../../../../data/remote/helper/app_response.dart';

abstract class MapRepository {
  Future<AppResponse> getStations();
  Future<AppResponse> getHubs();
}
