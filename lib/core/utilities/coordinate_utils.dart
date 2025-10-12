import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Utility class for safely parsing coordinates
class CoordinateUtils {
  /// Default coordinates for Muscat, Oman (fallback location)
  static const double defaultLat = 23.5859;
  static const double defaultLng = 58.4059;

  /// Safely parse latitude string to double
  /// Returns default latitude if parsing fails
  static double parseLatitude(String? latString) {
    if (latString == null || latString.trim().isEmpty) {
      return defaultLat;
    }

    try {
      final lat = double.parse(latString.trim());
      // Validate latitude range (-90 to 90)
      if (lat >= -90.0 && lat <= 90.0) {
        return lat;
      } else {
        print('⚠️ Invalid latitude value: $latString (out of range)');
        return defaultLat;
      }
    } catch (e) {
      print('⚠️ Failed to parse latitude: $latString - $e');
      return defaultLat;
    }
  }

  /// Safely parse longitude string to double
  /// Returns default longitude if parsing fails
  static double parseLongitude(String? lngString) {
    if (lngString == null || lngString.trim().isEmpty) {
      return defaultLng;
    }

    try {
      final lng = double.parse(lngString.trim());
      // Validate longitude range (-180 to 180)
      if (lng >= -180.0 && lng <= 180.0) {
        return lng;
      } else {
        print('⚠️ Invalid longitude value: $lngString (out of range)');
        return defaultLng;
      }
    } catch (e) {
      print('⚠️ Failed to parse longitude: $lngString - $e');
      return defaultLng;
    }
  }

  /// Safely parse both latitude and longitude
  /// Returns a LatLng object with default coordinates if parsing fails
  static LatLng parseCoordinates(String? latString, String? lngString) {
    return LatLng(parseLatitude(latString), parseLongitude(lngString));
  }

  /// Check if coordinates are valid (within proper ranges)
  static bool isValidCoordinates(double lat, double lng) {
    return lat >= -90.0 && lat <= 90.0 && lng >= -180.0 && lng <= 180.0;
  }

  /// Check if coordinate strings are valid before parsing
  static bool isValidCoordinateStrings(String? latString, String? lngString) {
    if (latString == null || lngString == null) return false;
    if (latString.trim().isEmpty || lngString.trim().isEmpty) return false;

    try {
      final lat = double.parse(latString.trim());
      final lng = double.parse(lngString.trim());
      return isValidCoordinates(lat, lng);
    } catch (e) {
      return false;
    }
  }
}
