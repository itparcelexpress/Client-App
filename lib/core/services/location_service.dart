import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/location_models.dart';
import '../utilities/app_endpoints.dart';
import '../../data/remote/app_request.dart';
import '../../data/remote/helper/app_response.dart';

class LocationService {
  static const String _governoratesBoxName = 'governorates';
  static const String _statesBoxName = 'states';
  static const String _placesBoxName = 'places';

  // Hive boxes
  static Box<Governorate>? _governoratesBox;
  static Box<StateModel>? _statesBox;
  static Box<Place>? _placesBox;

  // Initialize Hive and boxes
  static Future<void> initialize() async {
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(GovernorateAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(StateModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(PlaceAdapter());
    }

    // Open boxes
    _governoratesBox = await Hive.openBox<Governorate>(_governoratesBoxName);
    _statesBox = await Hive.openBox<StateModel>(_statesBoxName);
    _placesBox = await Hive.openBox<Place>(_placesBoxName);

    // Load data if boxes are empty
    await _loadInitialData();
  }

  // Load initial data from JSON files
  static Future<void> _loadInitialData() async {
    if (_governoratesBox!.isEmpty) {
      // Try to load from API first, fallback to JSON
      try {
        final apiGovernorates = await fetchGovernorates();
        if (apiGovernorates.isNotEmpty) {
          for (final governorate in apiGovernorates) {
            await _governoratesBox!.put(governorate.id, governorate);
          }
          debugPrint(
            'Governorates loaded from API: ${apiGovernorates.length} items',
          );
        } else {
          await _loadGovernoratesFromJson();
        }
      } catch (e) {
        debugPrint(
          'Failed to load governorates from API, falling back to JSON: $e',
        );
        await _loadGovernoratesFromJson();
      }
    }
    if (_statesBox!.isEmpty) {
      // Try to load from API first, fallback to JSON
      try {
        final apiStates = await fetchStates();
        if (apiStates.isNotEmpty) {
          for (final state in apiStates) {
            await _statesBox!.put(state.id, state);
          }
          debugPrint('States loaded from API: ${apiStates.length} items');
        } else {
          await _loadStatesFromJson();
        }
      } catch (e) {
        debugPrint('Failed to load states from API, falling back to JSON: $e');
        await _loadStatesFromJson();
      }
    }
    if (_placesBox!.isEmpty) {
      // Try to load from API first, fallback to JSON
      try {
        final apiPlaces = await fetchPlaces();
        if (apiPlaces.isNotEmpty) {
          for (final place in apiPlaces) {
            await _placesBox!.put(place.id, place);
          }
          debugPrint('Places loaded from API: ${apiPlaces.length} items');
        } else {
          await _loadPlacesFromJson();
        }
      } catch (e) {
        debugPrint('Failed to load places from API, falling back to JSON: $e');
        await _loadPlacesFromJson();
      }
    }
  }

  // Load governorates from JSON
  static Future<void> _loadGovernoratesFromJson() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/jsons/governrates.json',
      );
      final jsonData = json.decode(jsonString);
      final response = GovernorateResponse.fromJson(jsonData);

      for (final governorate in response.data) {
        await _governoratesBox!.put(governorate.id, governorate);
      }
    } catch (e) {
      debugPrint('Error loading governorates from JSON: $e');
    }
  }

  // Load states from JSON
  static Future<void> _loadStatesFromJson() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/jsons/states.json',
      );
      final jsonData = json.decode(jsonString);
      final response = StateResponse.fromJson(jsonData);

      for (final state in response.data) {
        await _statesBox!.put(state.id, state);
      }
    } catch (e) {
      debugPrint('Error loading states from JSON: $e');
    }
  }

  // Load places from JSON
  static Future<void> _loadPlacesFromJson() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/jsons/places.json',
      );
      final jsonData = json.decode(jsonString);
      final response = PlaceResponse.fromJson(jsonData);

      for (final place in response.data) {
        await _placesBox!.put(place.id, place);
      }
    } catch (e) {
      debugPrint('Error loading places from JSON: $e');
    }
  }

  // Get all governorates
  static List<Governorate> getAllGovernorates() {
    return _governoratesBox?.values.toList() ?? [];
  }

  // Get all states
  static List<StateModel> getAllStates() {
    return _statesBox?.values.toList() ?? [];
  }

  // Get all places
  static List<Place> getAllPlaces() {
    return _placesBox?.values.toList() ?? [];
  }

  // Get states by governorate ID
  static List<StateModel> getStatesByGovernorateId(int governorateId) {
    return _statesBox?.values
            .where((state) => state.governorateId == governorateId)
            .toList() ??
        [];
  }

  // Get places by state ID
  static List<Place> getPlacesByStateId(int stateId) {
    return _placesBox?.values
            .where((place) => place.stateId == stateId)
            .toList() ??
        [];
  }

  // Get governorate by ID
  static Governorate? getGovernorateById(int id) {
    return _governoratesBox?.get(id);
  }

  // Get state by ID
  static StateModel? getStateById(int id) {
    return _statesBox?.get(id);
  }

  // Get place by ID
  static Place? getPlaceById(int id) {
    return _placesBox?.get(id);
  }

  // Refresh governorates from API
  static Future<void> refreshGovernorates() async {
    try {
      final apiGovernorates = await fetchGovernorates();
      if (apiGovernorates.isNotEmpty) {
        await _governoratesBox?.clear();
        for (final governorate in apiGovernorates) {
          await _governoratesBox!.put(governorate.id, governorate);
        }
        debugPrint(
          'Governorates refreshed from API: ${apiGovernorates.length} items',
        );
      }
    } catch (e) {
      debugPrint('Error refreshing governorates from API: $e');
      // Don't clear existing data if API fails
      debugPrint('Keeping existing governorate data');
    }
  }

  // Refresh states from API
  static Future<void> refreshStates() async {
    try {
      final apiStates = await fetchStates();
      if (apiStates.isNotEmpty) {
        await _statesBox?.clear();
        for (final state in apiStates) {
          await _statesBox!.put(state.id, state);
        }
        debugPrint('States refreshed from API: ${apiStates.length} items');
      }
    } catch (e) {
      debugPrint('Error refreshing states from API: $e');
      // Don't clear existing data if API fails
      debugPrint('Keeping existing state data');
    }
  }

  // Refresh places from API
  static Future<void> refreshPlaces() async {
    try {
      final apiPlaces = await fetchPlaces();
      if (apiPlaces.isNotEmpty) {
        await _placesBox?.clear();
        for (final place in apiPlaces) {
          await _placesBox!.put(place.id, place);
        }
        debugPrint('Places refreshed from API: ${apiPlaces.length} items');
      }
    } catch (e) {
      debugPrint('Error refreshing places from API: $e');
      // Don't clear existing data if API fails
      debugPrint('Keeping existing place data');
    }
  }

  // Clear all data (for testing or refresh)
  static Future<void> clearAllData() async {
    await _governoratesBox?.clear();
    await _statesBox?.clear();
    await _placesBox?.clear();
    await _loadInitialData();
  }

  // Close boxes (call this when app is disposed)
  static Future<void> dispose() async {
    await _governoratesBox?.close();
    await _statesBox?.close();
    await _placesBox?.close();
  }

  // Fetch countries from API
  static Future<List<Country>> fetchCountries() async {
    try {
      final AppResponse response = await AppRequest.get(
        AppEndPoints.countries,
        false, // No authentication required
      );

      if (response.success && response.origin != null) {
        final countryResponse = CountryResponse.fromJson(response.origin!);
        return countryResponse.data;
      } else {
        debugPrint('Failed to fetch countries: ${response.message}');
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching countries: $e');
      return [];
    }
  }

  // Fetch governorates from API
  static Future<List<Governorate>> fetchGovernorates() async {
    try {
      final AppResponse response = await AppRequest.get(
        AppEndPoints.governorates,
        true, // Authentication required
      );

      if (response.success && response.origin != null) {
        final governorateResponse = GovernorateResponse.fromJson(
          response.origin!,
        );
        return governorateResponse.data;
      } else {
        debugPrint('Failed to fetch governorates: ${response.message}');
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching governorates: $e');
      return [];
    }
  }

  // Fetch states from API
  static Future<List<StateModel>> fetchStates() async {
    try {
      final AppResponse response = await AppRequest.get(
        AppEndPoints.states,
        true, // Authentication required
      );

      if (response.success && response.origin != null) {
        final stateResponse = StateResponse.fromJson(response.origin!);
        return stateResponse.data;
      } else {
        debugPrint('Failed to fetch states: ${response.message}');
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching states: $e');
      return [];
    }
  }

  // Fetch places from API
  static Future<List<Place>> fetchPlaces() async {
    try {
      final AppResponse response = await AppRequest.get(
        AppEndPoints.places,
        true, // Authentication required
      );

      if (response.success && response.origin != null) {
        final placeResponse = PlaceResponse.fromJson(response.origin!);
        return placeResponse.data;
      } else {
        debugPrint('Failed to fetch places: ${response.message}');
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching places: $e');
      return [];
    }
  }
}
