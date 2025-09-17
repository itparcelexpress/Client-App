part of 'map_cubit.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapLoaded extends MapState {
  final List<Station> stations;
  final List<HubDetail> hubs;
  final String? selectedStationId;
  final String? selectedHubId;

  const MapLoaded({
    required this.stations,
    required this.hubs,
    this.selectedStationId,
    this.selectedHubId,
  });

  @override
  List<Object?> get props => [stations, hubs, selectedStationId, selectedHubId];

  MapLoaded copyWith({
    List<Station>? stations,
    List<HubDetail>? hubs,
    String? selectedStationId,
    String? selectedHubId,
  }) {
    return MapLoaded(
      stations: stations ?? this.stations,
      hubs: hubs ?? this.hubs,
      selectedStationId: selectedStationId ?? this.selectedStationId,
      selectedHubId: selectedHubId ?? this.selectedHubId,
    );
  }
}

class MapError extends MapState {
  final String message;

  const MapError({required this.message});

  @override
  List<Object?> get props => [message];
}
