import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapViewWidget extends StatelessWidget {
  final Set<Marker> markers;
  final Function(GoogleMapController) onMapCreated;
  final CameraPosition initialCameraPosition;
  final Function(LatLng)? onMapTapped;

  const MapViewWidget({
    super.key,
    required this.markers,
    required this.onMapCreated,
    required this.initialCameraPosition,
    this.onMapTapped,
  });

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: onMapCreated,
      initialCameraPosition: initialCameraPosition,
      markers: markers,
      mapType: MapType.normal,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: true,
      mapToolbarEnabled: false,
      compassEnabled: true,
      rotateGesturesEnabled: true,
      scrollGesturesEnabled: true,
      tiltGesturesEnabled: true,
      zoomGesturesEnabled: true,
      onTap: onMapTapped,
      onCameraMove: (CameraPosition position) {
        // Handle camera movement if needed
      },
      onCameraIdle: () {
        // Handle camera idle if needed
      },
    );
  }
}
