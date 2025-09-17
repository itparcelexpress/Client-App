import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/hub_model.dart';
import '../data/models/station_model.dart';
import '../data/repositories/map_repository.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  final MapRepository _mapRepository;

  MapCubit(this._mapRepository) : super(MapInitial());

  Future<void> loadMapData() async {
    if (isClosed) return;

    try {
      emit(MapLoading());

      // Fetch both stations and hubs in parallel
      final stationsFuture = _mapRepository.getStations();
      final hubsFuture = _mapRepository.getHubs();

      final results = await Future.wait([stationsFuture, hubsFuture]);
      final stationsResponse = results[0];
      final hubsResponse = results[1];

      if (isClosed) return;

      if (stationsResponse.success && hubsResponse.success) {
        emit(
          MapLoaded(
            stations: stationsResponse.data.data,
            hubs: hubsResponse.data.data,
          ),
        );
      } else {
        final errorMessage =
            stationsResponse.message?.isNotEmpty == true
                ? stationsResponse.message!
                : hubsResponse.message ?? 'Failed to load map data';
        emit(MapError(message: errorMessage));
      }
    } catch (e) {
      if (!isClosed) {
        emit(MapError(message: 'Failed to load map data: ${e.toString()}'));
      }
    }
  }

  Future<void> refreshMapData() async {
    // Don't show loading state on refresh to avoid UI flicker
    try {
      final stationsFuture = _mapRepository.getStations();
      final hubsFuture = _mapRepository.getHubs();

      final results = await Future.wait([stationsFuture, hubsFuture]);
      final stationsResponse = results[0];
      final hubsResponse = results[1];

      if (!isClosed && stationsResponse.success && hubsResponse.success) {
        emit(
          MapLoaded(
            stations: stationsResponse.data.data,
            hubs: hubsResponse.data.data,
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(MapError(message: 'Failed to refresh map data: ${e.toString()}'));
      }
    }
  }

  void selectStation(Station station) {
    updateSelection(
      selectedStationId: station.id.toString(),
      selectedHubId: null,
    );
  }

  void selectHub(HubDetail hub) {
    updateSelection(selectedHubId: hub.id.toString(), selectedStationId: null);
  }

  void updateSelection({String? selectedStationId, String? selectedHubId}) {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      emit(
        currentState.copyWith(
          selectedStationId: selectedStationId,
          selectedHubId: selectedHubId,
        ),
      );
    }
  }

  void reset() {
    if (!isClosed) {
      emit(MapInitial());
    }
  }
}
