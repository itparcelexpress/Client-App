import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  @override
  void initState() {
    super.initState();
    context.read<MapCubit>().loadMapData();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _updateMarkers(List<Station> stations, List<hub_models.HubDetail> hubs) {
    _markers.clear();

    // Add station markers
    for (final station in stations) {
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
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          onTap: () {
            context.read<MapCubit>().selectStation(station);
            _animateCarouselToItem(station);
          },
        ),
      );
    }

    // Add hub markers
    for (final hub in hubs) {
      _markers.add(
        Marker(
          markerId: MarkerId('hub_${hub.id}'),
          position: LatLng(double.parse(hub.lat), double.parse(hub.lng)),
          infoWindow: InfoWindow(title: hub.name, snippet: hub.location),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          onTap: () {
            context.read<MapCubit>().selectHub(hub);
            _animateCarouselToItem(hub);
          },
        ),
      );
    }
  }

  void _animateCarouselToItem(dynamic item) {
    final index = _allItems.indexOf(item);
    if (index != -1) {
      setState(() {
        _currentCarouselIndex = index;
      });
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(double.parse(item.lat), double.parse(item.lng)),
        ),
      );
    }
  }

  void _onCarouselItemSelected(int index, dynamic item) {
    setState(() {
      _currentCarouselIndex = index;
    });
    if (item is Station) {
      context.read<MapCubit>().selectStation(item);
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(double.parse(item.lat), double.parse(item.lng)),
        ),
      );
    } else if (item is hub_models.HubDetail) {
      context.read<MapCubit>().selectHub(item);
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(double.parse(item.lat), double.parse(item.lng)),
        ),
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
        title: Text(_isMapView ? 'Map View' : 'List View'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isMapView ? Icons.list : Icons.map),
            onPressed: _toggleView,
            tooltip: _isMapView ? 'Switch to List View' : 'Switch to Map View',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<MapCubit>().refreshMapData(),
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: BlocBuilder<MapCubit, MapState>(
        builder: (context, state) {
          if (state is MapLoading) {
            return const Center(child: CircularProgressIndicator());
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
                    child: const Text('Retry'),
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
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  Widget _buildMapView(MapLoaded state) {
    _updateMarkers(state.stations, state.hubs);

    return Stack(
      children: [
        MapViewWidget(
          markers: _markers,
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
            target: LatLng(23.5859, 58.4059), // Muscat coordinates
            zoom: 10.0,
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
        // Show empty state overlay when no data
        if (state.stations.isEmpty && state.hubs.isEmpty)
          Positioned(
            top: 100,
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
                    'No Locations Available',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Stations and hubs will appear here once the API is available.',
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
    );
  }
}
