import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:client_app/core/widgets/loading_widgets.dart';
import 'package:client_app/l10n/app_localizations.dart';

import '../../cubit/map_cubit.dart';
import '../../data/models/hub_model.dart' as hub_models;
import '../../data/models/station_model.dart';
import '../widgets/map_carousel_slider.dart';
import '../widgets/map_view_widget.dart';
import 'locations_list_page.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  int _currentCarouselIndex = 0;
  bool _isMapView = true; // Toggle between map and list view
  BitmapDescriptor? _stationIcon;
  BitmapDescriptor? _hubIcon;
  BitmapDescriptor? _selectedStationIcon;
  BitmapDescriptor? _selectedHubIcon;

  @override
  void initState() {
    super.initState();
    _createCustomMarkers();
    context.read<MapCubit>().loadMapData();
  }

  Future<void> _createCustomMarkers() async {
    // Create custom markers with better styling
    _stationIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/images/station_marker.png',
    ).catchError((_) {
      // Fallback to default marker if custom asset not found
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    });

    _hubIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/images/hub_marker.png',
    ).catchError((_) {
      // Fallback to default marker if custom asset not found
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    });

    _selectedStationIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(56, 56)),
      'assets/images/selected_station_marker.png',
    ).catchError((_) {
      // Fallback to default marker if custom asset not found
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan);
    });

    _selectedHubIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(56, 56)),
      'assets/images/selected_hub_marker.png',
    ).catchError((_) {
      // Fallback to default marker if custom asset not found
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    print('🗺️ Map created, controller set');
    // Fit all markers in view after a short delay to ensure markers are loaded
    Future.delayed(const Duration(milliseconds: 1000), () {
      _fitMarkersInView();
    });
  }

  void _fitMarkersInView() {
    if (_markers.isEmpty || _mapController == null) {
      print(
        '🗺️ Cannot fit markers: markers=${_markers.length}, controller=${_mapController != null}',
      );
      return;
    }

    print('🗺️ Fitting ${_markers.length} markers in view');
    final LatLngBounds bounds = _createBoundsFromMarkers();
    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 100.0), // 100px padding
    );
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
      '🗺️ Updating markers: ${stations.length} stations, ${hubs.length} hubs',
    );
    _markers.clear();

    // Add a test marker at Muscat center to verify map is working
    // _markers.add(
    //   Marker(
    //     markerId: const MarkerId('test_marker'),
    //     position: const LatLng(23.5859, 58.4059),
    //     infoWindow: const InfoWindow(
    //       title: 'Test Marker',
    //       snippet: 'Muscat Center',
    //     ),
    //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    //   ),
    // );

    final state = context.read<MapCubit>().state;
    final selectedStationId =
        state is MapLoaded ? state.selectedStationId : null;
    final selectedHubId = state is MapLoaded ? state.selectedHubId : null;

    // Add station markers
    for (final station in stations) {
      print(
        '🗺️ Adding station marker: ${station.name} at ${station.lat}, ${station.lng}',
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
          icon:
              isSelected
                  ? (_selectedStationIcon ??
                      BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueCyan,
                      ))
                  : (_stationIcon ??
                      BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueBlue,
                      )),
          onTap: () {
            context.read<MapCubit>().selectStation(station);
            _animateCarouselToItem(station);
            _animateToLocation(
              LatLng(double.parse(station.lat), double.parse(station.lng)),
            );
          },
        ),
      );
    }

    // Add hub markers
    for (final hub in hubs) {
      print('🗺️ Adding hub marker: ${hub.name} at ${hub.lat}, ${hub.lng}');
      final isSelected = selectedHubId == hub.id.toString();
      _markers.add(
        Marker(
          markerId: MarkerId('hub_${hub.id}'),
          position: LatLng(double.parse(hub.lat), double.parse(hub.lng)),
          infoWindow: InfoWindow(title: hub.name, snippet: hub.location),
          icon:
              isSelected
                  ? (_selectedHubIcon ??
                      BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueOrange,
                      ))
                  : (_hubIcon ??
                      BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed,
                      )),
          onTap: () {
            context.read<MapCubit>().selectHub(hub);
            _animateCarouselToItem(hub);
            _animateToLocation(
              LatLng(double.parse(hub.lat), double.parse(hub.lng)),
            );
          },
        ),
      );
    }
    print('🗺️ Total markers created: ${_markers.length}');
  }

  void _animateCarouselToItem(dynamic item) {
    final index = _allItems.indexOf(item);
    if (index != -1) {
      setState(() {
        _currentCarouselIndex = index;
      });
      _animateToLocation(
        LatLng(double.parse(item.lat), double.parse(item.lng)),
      );
    }
  }

  void _animateToLocation(LatLng location) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: location,
          zoom: 15.0, // Closer zoom for better detail
          bearing: 0.0,
          tilt: 0.0,
        ),
      ),
    );
  }

  void _onCarouselItemSelected(int index, dynamic item) {
    setState(() {
      _currentCarouselIndex = index;
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
          if (state is MapLoading) {
            return LoadingWidgets.mapLoading();
          } else if (state is MapError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
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
          } else if (state is MapLoaded) {
            if (_isMapView) {
              return _buildMapView(state);
            } else {
              return _buildListView(state);
            }
          }
          return Center(
            child: Text(AppLocalizations.of(context)!.noDataAvailable),
          );
        },
      ),
    );
  }

  Widget _buildMapView(MapLoaded state) {
    // Update markers immediately when state changes
    _updateMarkers(state.stations, state.hubs);

    return Stack(
      children: [
        MapViewWidget(
          markers: _markers,
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
            target: LatLng(23.5859, 58.4059), // Muscat coordinates
            zoom: 8.0, // Reduced zoom to show more area
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: MapCarouselSlider(
            stations: state.stations,
            hubs: state.hubs,
            currentIndex: _currentCarouselIndex,
            onItemSelected: _onCarouselItemSelected,
          ),
        ),
        // Debug info overlay
        Positioned(
          top: 100,
          left: 16,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Stations: ${state.stations.length}\nHubs: ${state.hubs.length}\nMarkers: ${_markers.length}',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
        // Floating action button to fit all markers
        if (state.stations.isNotEmpty || state.hubs.isNotEmpty)
          Positioned(
            top: 100,
            right: 16,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).primaryColor,
              onPressed: _fitMarkersInView,
              tooltip: 'Show all locations',
              child: const Icon(Icons.my_location),
            ),
          ),
        // Show empty state overlay when no data
        if (state.stations.isEmpty && state.hubs.isEmpty)
          Positioned(
            top: 200,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_off, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 12),
                  Text(
                    AppLocalizations.of(context)!.noLocationsAvailable,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.stationsAndHubsWillAppearHere,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildListView(MapLoaded state) {
    return LocationsListPage(
      stations: state.stations,
      hubs: state.hubs,
      onRefresh: () => context.read<MapCubit>().refreshMapData(),
      onItemSelected: (item) {
        // Switch to map view and navigate to selected item
        setState(() {
          _isMapView = true;
        });
        if (item is Station) {
          context.read<MapCubit>().selectStation(item);
          _animateCarouselToItem(item);
        } else if (item is hub_models.HubDetail) {
          context.read<MapCubit>().selectHub(item);
          _animateCarouselToItem(item);
        }
      },
    );
  }
}
