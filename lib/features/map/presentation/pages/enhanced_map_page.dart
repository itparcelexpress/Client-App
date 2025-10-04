import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:client_app/core/widgets/loading_widgets.dart';
import 'package:client_app/l10n/app_localizations.dart';

import '../../cubit/map_cubit.dart';
import '../../data/models/hub_model.dart' as hub_models;
import '../../data/models/station_model.dart';
import '../widgets/locations_carousel.dart';
import '../widgets/enhanced_location_card.dart';

class EnhancedMapPage extends StatefulWidget {
  const EnhancedMapPage({super.key});

  @override
  State<EnhancedMapPage> createState() => _EnhancedMapPageState();
}

class _EnhancedMapPageState extends State<EnhancedMapPage>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  int _currentIndex = 0;
  bool _isMapView = true;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );

    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    // Fit all markers in view after a delay
    Future.delayed(const Duration(milliseconds: 1000), () {
      _fitMarkersInView();
    });
  }

  void _fitMarkersInView() {
    if (_markers.isEmpty || _mapController == null) return;

    final LatLngBounds bounds = _createBoundsFromMarkers();
    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100.0));
  }

  LatLngBounds _createBoundsFromMarkers() {
    double minLat = double.infinity;
    double maxLat = -double.infinity;
    double minLng = double.infinity;
    double maxLng = -double.infinity;

    for (final marker in _markers) {
      final lat = marker.position.latitude;
      final lng = marker.position.longitude;

      minLat = minLat < lat ? minLat : lat;
      maxLat = maxLat > lat ? maxLat : lat;
      minLng = minLng < lng ? minLng : lng;
      maxLng = maxLng > lng ? maxLng : lng;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  void _updateMarkers(List<Station> stations, List<hub_models.HubDetail> hubs) {
    print(
      '🗺️ EnhancedMapPage: Updating markers with ${stations.length} stations and ${hubs.length} hubs',
    );
    _markers.clear();
    final state = context.read<MapCubit>().state;
    final selectedStationId =
        state is MapLoaded ? state.selectedStationId : null;
    final selectedHubId = state is MapLoaded ? state.selectedHubId : null;

    // Add station markers
    for (final station in stations) {
      print(
        '🗺️ EnhancedMapPage: Adding station marker: ${station.name} at ${station.lat}, ${station.lng}',
      );
      final isSelected = selectedStationId == station.id.toString();
      _markers.add(
        Marker(
          markerId: MarkerId('station_${station.id}'),
          position: LatLng(
            double.parse(station.lat),
            double.parse(station.lng),
          ),
          infoWindow: InfoWindow(
            title: station.name,
            snippet: station.location,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            isSelected ? BitmapDescriptor.hueCyan : BitmapDescriptor.hueBlue,
          ),
          onTap: () {
            context.read<MapCubit>().selectStation(station);
            _animateToLocation(
              LatLng(double.parse(station.lat), double.parse(station.lng)),
            );
            _animateToIndex(_allItems.indexOf(station));
          },
        ),
      );
    }

    // Add hub markers
    for (final hub in hubs) {
      print(
        '🗺️ EnhancedMapPage: Adding hub marker: ${hub.name} at ${hub.lat}, ${hub.lng}',
      );
      final isSelected = selectedHubId == hub.id.toString();
      _markers.add(
        Marker(
          markerId: MarkerId('hub_${hub.id}'),
          position: LatLng(double.parse(hub.lat), double.parse(hub.lng)),
          infoWindow: InfoWindow(title: hub.name, snippet: hub.location),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            isSelected ? BitmapDescriptor.hueOrange : BitmapDescriptor.hueRed,
          ),
          onTap: () {
            context.read<MapCubit>().selectHub(hub);
            _animateToLocation(
              LatLng(double.parse(hub.lat), double.parse(hub.lng)),
            );
            _animateToIndex(_allItems.indexOf(hub));
          },
        ),
      );
    }

    print('🗺️ EnhancedMapPage: Total markers created: ${_markers.length}');
  }

  void _animateToLocation(LatLng location) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: location, zoom: 15.0, bearing: 0.0, tilt: 0.0),
      ),
    );
  }

  void _animateToIndex(int index) {
    if (index >= 0 && index < _allItems.length) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  void _onCarouselItemSelected(int index, dynamic item) {
    setState(() {
      _currentIndex = index;
    });

    if (item is Station) {
      context.read<MapCubit>().selectStation(item);
      _animateToLocation(
        LatLng(double.parse(item.lat), double.parse(item.lng)),
      );
    } else if (item is hub_models.HubDetail) {
      context.read<MapCubit>().selectHub(item);
      _animateToLocation(
        LatLng(double.parse(item.lat), double.parse(item.lng)),
      );
    }
  }

  void _toggleView() {
    setState(() {
      _isMapView = !_isMapView;
    });
  }

  List<dynamic> get _allItems {
    final state = context.read<MapCubit>().state;
    if (state is MapLoaded) {
      return [...state.stations, ...state.hubs];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isMapView
              ? AppLocalizations.of(context)!.mapView
              : AppLocalizations.of(context)!.listView,
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isMapView ? Icons.list : Icons.map),
            onPressed: _toggleView,
            tooltip:
                _isMapView
                    ? AppLocalizations.of(context)!.switchToListView
                    : AppLocalizations.of(context)!.switchToMapView,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<MapCubit>().refreshMapData(),
            tooltip: AppLocalizations.of(context)!.refreshData,
          ),
        ],
      ),
      body: BlocBuilder<MapCubit, MapState>(
        builder: (context, state) {
          print('🗺️ EnhancedMapPage: Current state: ${state.runtimeType}');

          if (state is MapInitial) {
            print(
              '🗺️ EnhancedMapPage: Showing initial state, loading data...',
            );
            // Automatically load data when in initial state
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<MapCubit>().loadMapData();
            });
            return LoadingWidgets.mapLoading();
          } else if (state is MapLoading) {
            print('🗺️ EnhancedMapPage: Showing loading state');
            return LoadingWidgets.mapLoading();
          } else if (state is MapError) {
            print('🗺️ EnhancedMapPage: Showing error state: ${state.message}');
            return _buildErrorState(state.message);
          } else if (state is MapLoaded) {
            print(
              '🗺️ EnhancedMapPage: Showing MapLoaded with ${state.stations.length} stations and ${state.hubs.length} hubs',
            );
            if (_isMapView) {
              return _buildMapView(state);
            } else {
              return _buildListView(state);
            }
          }

          print(
            '🗺️ EnhancedMapPage: Showing default state: ${state.runtimeType}',
          );
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_off, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.noDataAvailable,
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<MapCubit>().loadMapData(),
                  child: Text(AppLocalizations.of(context)!.retry),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 18, color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<MapCubit>().loadMapData(),
            child: Text(AppLocalizations.of(context)!.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildMapView(MapLoaded state) {
    print(
      '🗺️ EnhancedMapPage: Building map view with ${state.stations.length} stations and ${state.hubs.length} hubs',
    );
    _updateMarkers(state.stations, state.hubs);
    print('🗺️ EnhancedMapPage: Created ${_markers.length} markers');

    return Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
            target: LatLng(23.5859, 58.4059),
            zoom: 8.0,
          ),
          markers: _markers,
          mapType: MapType.normal,
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: true,
          mapToolbarEnabled: false,
          compassEnabled: true,
          rotateGesturesEnabled: true,
          scrollGesturesEnabled: true,
          tiltGesturesEnabled: true,
          zoomGesturesEnabled: true,
        ),
        // Carousel at the bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: LocationsCarousel(
            stations: state.stations,
            hubs: state.hubs,
            currentIndex: _currentIndex,
            onItemSelected: _onCarouselItemSelected,
            onRefresh: () => context.read<MapCubit>().refreshMapData(),
          ),
        ),
        // Floating action button to fit all markers
        if (state.stations.isNotEmpty || state.hubs.isNotEmpty)
          Positioned(
            top: 100,
            right: 16,
            child: AnimatedBuilder(
              animation: _fabAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _fabAnimation.value,
                  child: FloatingActionButton(
                    mini: true,
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).primaryColor,
                    onPressed: _fitMarkersInView,
                    tooltip: AppLocalizations.of(context)!.showAllLocations,
                    child: const Icon(Icons.my_location),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildListView(MapLoaded state) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              Icon(Icons.list, color: Theme.of(context).primaryColor, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(
                        context,
                      )!.locationsCount(_allItems.length),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.stationsAndHubsCount(
                        state.stations.length,
                        state.hubs.length,
                      ),
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _allItems.length,
            itemBuilder: (context, index) {
              final item = _allItems[index];
              final isSelected = index == _currentIndex;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: EnhancedLocationCard(
                  item: item,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      _currentIndex = index;
                    });
                    if (item is Station) {
                      context.read<MapCubit>().selectStation(item);
                    } else if (item is hub_models.HubDetail) {
                      context.read<MapCubit>().selectHub(item);
                    }
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
