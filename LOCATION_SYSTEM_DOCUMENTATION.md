# Location System Implementation Documentation
## Country → Governorate → State → Place Hierarchy

This document provides a complete description of how the Client App handles location data fetching, selection, ID passing, and cascade behavior for implementing in the Driver App.

---

## 📋 Table of Contents
1. [Overview](#overview)
2. [Data Models](#data-models)
3. [API Endpoints](#api-endpoints)
4. [Service Layer Architecture](#service-layer-architecture)
5. [UI Widgets](#ui-widgets)
6. [Selection Flow & Cascade Logic](#selection-flow--cascade-logic)
7. [Order Creation & ID Passing](#order-creation--id-passing)
8. [Caching Strategy](#caching-strategy)
9. [Implementation Checklist](#implementation-checklist)

---

## 🎯 Overview

The location system manages a 4-level hierarchy:
- **Country** (id, name, code, phonecode)
- **Governorate** (id, enName, arName, countryId)
- **State** (id, enName, arName, governorateId)
- **Place** (id, enName, arName, stateId)

### Key Features:
- ✅ Bilingual support (English/Arabic)
- ✅ Local caching with Hive for offline access
- ✅ API fallback with JSON asset fallback
- ✅ Searchable dropdown modals
- ✅ Cascading selection (changing governorate resets state/place)
- ✅ Automatic pricing updates based on state selection

---

## 📦 Data Models

### Location: `lib/core/models/location_models.dart`

```dart
// Country Model
@HiveType(typeId: 3)
class Country extends Equatable {
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String? updatedAt;

  factory Country.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}

// Governorate Model
@HiveType(typeId: 0)
class Governorate extends Equatable {
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  final String enName;
  
  @HiveField(2)
  final String arName;
  
  @HiveField(3)
  final int countryId;  // ⬅️ Foreign key to Country

  factory Governorate.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}

// State Model
@HiveType(typeId: 1)
class StateModel extends Equatable {
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  final String enName;
  
  @HiveField(2)
  final String arName;
  
  @HiveField(3)
  final int governorateId;  // ⬅️ Foreign key to Governorate

  factory StateModel.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}

// Place Model
@HiveType(typeId: 2)
class Place extends Equatable {
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  final String enName;
  
  @HiveField(2)
  final String arName;
  
  @HiveField(3)
  final int stateId;  // ⬅️ Foreign key to State

  factory Place.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}

// Response wrappers
class GovernorateResponse {
  final String message;
  final bool success;
  final List<Governorate> data;
  final List<dynamic> errors;
}

class StateResponse {
  final String message;
  final bool success;
  final List<StateModel> data;
  final List<dynamic> errors;
}

class PlaceResponse {
  final String message;
  final bool success;
  final List<Place> data;
  final List<dynamic> errors;
}

class CountryResponse {
  final String message;
  final bool success;
  final List<Country> data;
  final List<dynamic> errors;
}
```

---

## 🌐 API Endpoints

### Location: `lib/core/utilities/app_endpoints.dart`

```dart
class AppEndPoints {
  // Base URL
  static const String _productionSite = 'https://dashboard.parcelexpress.om';
  static const String _testSite = 'https://test.parcelexpress.om';
  static String get baseUrl => '$site/api/';

  // Location Endpoints
  static const String countries = 'countries';                // GET (No Auth)
  static const String governorates = 'governorates/all';      // GET (Auth Required)
  static const String states = 'states/all';                  // GET (Auth Required)
  static const String places = 'places/all';                  // GET (Auth Required)

  // Order Endpoints
  static const String createOrder = 'client/orders/store';    // POST (Auth Required)
}
```

### Request/Response Details:

| Endpoint | Method | Auth | Response Structure |
|----------|--------|------|-------------------|
| `/api/countries` | GET | ❌ No | `{ message, success, data: [Country], errors }` |
| `/api/governorates/all` | GET | ✅ Yes | `{ message, success, data: [Governorate], errors }` |
| `/api/states/all` | GET | ✅ Yes | `{ message, success, data: [State], errors }` |
| `/api/places/all` | GET | ✅ Yes | `{ message, success, data: [Place], errors }` |

---

## 🔧 Service Layer Architecture

### Location Service: `lib/core/services/location_service.dart`

This is the **core service** that handles all location data operations.

#### Initialization Flow:
```dart
class LocationService {
  // Hive boxes for local caching
  static Box<Governorate>? _governoratesBox;
  static Box<StateModel>? _statesBox;
  static Box<Place>? _placesBox;

  // Initialize: called in main.dart before app starts
  static Future<void> initialize() async {
    await Hive.initFlutter();
    
    // Register Hive adapters
    Hive.registerAdapter(GovernorateAdapter());
    Hive.registerAdapter(StateModelAdapter());
    Hive.registerAdapter(PlaceAdapter());
    
    // Open boxes
    _governoratesBox = await Hive.openBox<Governorate>('governorates');
    _statesBox = await Hive.openBox<StateModel>('states');
    _placesBox = await Hive.openBox<Place>('places');
    
    // Load initial data (API first, JSON fallback)
    await _loadInitialData();
  }
}
```

#### Data Loading Strategy:
```dart
static Future<void> _loadInitialData() async {
  // For Governorates:
  if (_governoratesBox!.isEmpty) {
    try {
      // 1. Try API first
      final apiGovernorates = await fetchGovernorates();
      if (apiGovernorates.isNotEmpty) {
        for (final gov in apiGovernorates) {
          await _governoratesBox!.put(gov.id, gov);
        }
      } else {
        // 2. Fallback to JSON assets
        await _loadGovernoratesFromJson();
      }
    } catch (e) {
      // 3. Error: fallback to JSON
      await _loadGovernoratesFromJson();
    }
  }
  
  // Repeat same logic for States and Places
}
```

#### API Fetching Methods:
```dart
// Fetch Countries from API
static Future<List<Country>> fetchCountries() async {
  final AppResponse response = await AppRequest.get(
    AppEndPoints.countries,
    false,  // No authentication
  );
  
  if (response.success && response.origin != null) {
    final countryResponse = CountryResponse.fromJson(response.origin!);
    return countryResponse.data;
  }
  return [];
}

// Fetch Governorates from API
static Future<List<Governorate>> fetchGovernorates() async {
  final AppResponse response = await AppRequest.get(
    AppEndPoints.governorates,
    true,  // Authentication required
  );
  
  if (response.success && response.origin != null) {
    final governorateResponse = GovernorateResponse.fromJson(response.origin!);
    return governorateResponse.data;
  }
  return [];
}

// Fetch States from API
static Future<List<StateModel>> fetchStates() async {
  final AppResponse response = await AppRequest.get(
    AppEndPoints.states,
    true,  // Authentication required
  );
  
  if (response.success && response.origin != null) {
    final stateResponse = StateResponse.fromJson(response.origin!);
    return stateResponse.data;
  }
  return [];
}

// Fetch Places from API
static Future<List<Place>> fetchPlaces() async {
  final AppResponse response = await AppRequest.get(
    AppEndPoints.places,
    true,  // Authentication required
  );
  
  if (response.success && response.origin != null) {
    final placeResponse = PlaceResponse.fromJson(response.origin!);
    return placeResponse.data;
  }
  return [];
}
```

#### Data Access Methods:
```dart
// Get all data
static List<Governorate> getAllGovernorates() {
  return _governoratesBox?.values.toList() ?? [];
}

static List<StateModel> getAllStates() {
  return _statesBox?.values.toList() ?? [];
}

static List<Place> getAllPlaces() {
  return _placesBox?.values.toList() ?? [];
}

// Get filtered data by parent ID
static List<StateModel> getStatesByGovernorateId(int governorateId) {
  return _statesBox?.values
      .where((state) => state.governorateId == governorateId)
      .toList() ?? [];
}

static List<Place> getPlacesByStateId(int stateId) {
  return _placesBox?.values
      .where((place) => place.stateId == stateId)
      .toList() ?? [];
}

// Get by ID
static Governorate? getGovernorateById(int id) {
  return _governoratesBox?.get(id);
}

static StateModel? getStateById(int id) {
  return _statesBox?.get(id);
}

static Place? getPlaceById(int id) {
  return _placesBox?.get(id);
}

// Refresh data from API
static Future<void> refreshGovernorates() async {
  final apiGovernorates = await fetchGovernorates();
  if (apiGovernorates.isNotEmpty) {
    await _governoratesBox?.clear();
    for (final gov in apiGovernorates) {
      await _governoratesBox!.put(gov.id, gov);
    }
  }
}

// Same for refreshStates() and refreshPlaces()
```

### Country Localization Service: `lib/core/services/country_localization_service.dart`

Handles country data separately with translation support:

```dart
class CountryLocalizationService {
  static Box<Country>? _countriesBox;
  static Box<CountryTranslation>? _translationsBox;
  
  // Cache for quick access
  static List<Country> _cachedCountries = [];
  static Map<int, CountryTranslation> _cachedTranslations = {};
  
  static Future<void> initialize() async {
    // Similar initialization with Hive
    // Loads from assets/jsons/countries.json
    // Loads from assets/jsons/country_translations.json
  }
  
  static List<Country> getAllCountries() {
    return _cachedCountries;
  }
  
  static Country? getCountryById(int id) {
    return _cachedCountries.firstWhere(
      (country) => country.id == id,
      orElse: () => _cachedCountries.first,
    );
  }
  
  static String getLocalizedCountryName(int countryId, Locale locale) {
    final translation = _cachedTranslations[countryId];
    return locale.languageCode == 'ar' 
        ? translation.arName 
        : translation.enName;
  }
}
```

---

## 🎨 UI Widgets

### Searchable Dropdown Widgets

All location dropdowns follow the same pattern with these features:
- Modal bottom sheet for selection
- Search functionality
- Bilingual display (AR/EN)
- Validation support
- Cascading filters

#### 1. Governorate Dropdown
Location: `lib/core/widgets/searchable_governorate_dropdown.dart`

```dart
SearchableGovernorateDropdown(
  value: _selectedGovernorate,
  onChanged: (governorate) async {
    setState(() {
      _selectedGovernorate = governorate;
      if (governorate != null) {
        _loadStatesForGovernorate(governorate.id);
      }
    });
    
    // Refresh states from API
    if (governorate != null) {
      await LocationService.refreshStates();
    }
  },
  label: 'Governorate',
  icon: Icons.location_city_outlined,
  countryId: _selectedCountry?.id,  // ⬅️ Filters by country
  shouldShowErrors: _hasValidated,
  validator: (value) => value == null ? 'Please select governorate' : null,
)
```

**Key Props:**
- `countryId`: Filters governorates by country (pass `null` to show all)
- `value`: Currently selected governorate
- `onChanged`: Callback when selection changes
- `validator`: Custom validation logic

**Internal Logic:**
```dart
void _loadGovernorates() {
  List<Governorate> allGovernorates = LocationService.getAllGovernorates();
  
  // Filter by country if specified
  if (widget.countryId != null) {
    allGovernorates = allGovernorates
        .where((g) => g.countryId == widget.countryId)
        .toList();
  }
  
  _filteredGovernorates = allGovernorates;
}

void _onSearchChanged() {
  if (_isSearching) {
    // When searching, show ALL governorates (ignore country filter)
    List<Governorate> allGovernorates = LocationService.getAllGovernorates();
    
    _filteredGovernorates = allGovernorates.where((governorate) {
      final isRTL = Localizations.localeOf(context).languageCode == 'ar';
      final localizedName = isRTL ? governorate.arName : governorate.enName;
      return localizedName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  } else {
    _loadGovernorates();  // Restore country filter
  }
}
```

#### 2. State Dropdown
Location: `lib/core/widgets/searchable_state_dropdown.dart`

```dart
SearchableStateDropdown(
  value: _selectedState,
  onChanged: (state) async {
    setState(() {
      _selectedState = state;
      if (state != null) {
        _loadPlacesForState(state.id);
        _updateDeliveryFeeForState(state.id);  // Update pricing
      }
    });
    
    if (state != null) {
      await LocationService.refreshPlaces();
    }
  },
  label: 'State',
  icon: Icons.location_searching_outlined,
  governorateId: _selectedGovernorate?.id,  // ⬅️ Filters by governorate
  shouldShowErrors: _hasValidated,
  validator: (value) => value == null ? 'Please select state' : null,
)
```

**Filtering Logic:**
```dart
void _loadStates() {
  List<StateModel> allStates = LocationService.getAllStates();
  
  // Filter by governorate if specified
  if (widget.governorateId != null) {
    allStates = allStates
        .where((s) => s.governorateId == widget.governorateId)
        .toList();
  }
  
  _filteredStates = allStates;
}
```

#### 3. Place Dropdown
Location: `lib/core/widgets/searchable_place_dropdown.dart`

```dart
SearchablePlaceDropdown(
  value: _selectedPlace,
  onChanged: (place) {
    setState(() {
      _selectedPlace = place;
    });
  },
  label: 'Place',
  icon: Icons.place_outlined,
  stateId: _selectedState?.id,  // ⬅️ Filters by state
  isRequired: false,  // Place is optional
  shouldShowErrors: _hasValidated,
)
```

**Filtering Logic:**
```dart
void _loadPlaces() {
  List<Place> allPlaces = LocationService.getAllPlaces();
  
  // Filter by state if specified
  if (widget.stateId != null) {
    allPlaces = allPlaces
        .where((p) => p.stateId == widget.stateId)
        .toList();
  }
  
  _filteredPlaces = allPlaces;
}
```

#### 4. Country Dropdown
Location: `lib/core/widgets/searchable_country_dropdown.dart`

```dart
SearchableCountryDropdown(
  value: _selectedCountry,
  onChanged: (country) async {
    setState(() {
      _selectedCountry = country;
      // Reset all dependent fields
      _selectedGovernorate = null;
      _selectedState = null;
      _selectedPlace = null;
    });
    
    if (country != null) {
      await LocationService.refreshGovernorates();
    }
  },
  label: 'Country',
  icon: Icons.public_outlined,
  shouldShowErrors: _hasValidated,
  validator: (value) => value == null ? 'Please select country' : null,
)
```

---

## 🔄 Selection Flow & Cascade Logic

### Create Order Page: `lib/features/shipment/presentation/pages/create_order_page.dart`

#### State Variables:
```dart
// Selected location entities
Country? _selectedCountry;
Governorate? _selectedGovernorate;
StateModel? _selectedState;
Place? _selectedPlace;

// Pricing data (loaded separately)
List<PricingData> _pricingData = [];
```

#### Cascade Functions:

```dart
// When Governorate changes
void _loadStatesForGovernorate(int governorateId) {
  setState(() {
    _selectedState = null;      // ⬅️ Reset state
    _selectedPlace = null;       // ⬅️ Reset place
    // States are fetched by SearchableStateDropdown
  });
}

// When State changes
void _loadPlacesForState(int stateId) {
  setState(() {
    _selectedPlace = null;       // ⬅️ Reset place
    // Places are fetched by SearchablePlaceDropdown
  });
}

// When Country changes (in onChanged callback)
_selectedCountry = country;
_selectedGovernorate = null;   // ⬅️ Reset governorate
_selectedState = null;         // ⬅️ Reset state
_selectedPlace = null;         // ⬅️ Reset place
```

#### Automatic Pricing Update:
```dart
void _updateDeliveryFeeForState(int stateId) {
  print('Looking for pricing for state ID: $stateId');
  
  // If no pricing data, reload
  if (_pricingData.isEmpty && _pricingCubit != null) {
    _pricingCubit!.loadPricingForClient(LocalData.user!.id!);
    return;
  }
  
  final pricingForState = _pricingData.firstWhere(
    (pricing) => pricing.stateId == stateId,
    orElse: () => PricingData(
      deliveryFee: '5.00',  // Default fallback
      // ... other fields
    ),
  );
  
  setState(() {
    _deliveryFeeController.text = pricingForState.deliveryFee;
  });
}
```

#### Initialization Flow:
```dart
@override
void initState() {
  super.initState();
  
  _loadCountries();      // Load and set default country (Oman, ID: 165)
  _loadLocationData();   // Refresh governorates from API
  _loadPricingData();    // Load pricing data for delivery fees
}

void _loadCountries() async {
  try {
    final countries = CountryLocalizationService.getAllCountries();
    setState(() {
      // Set default to Oman (ID: 165)
      _selectedCountry = countries.firstWhere(
        (country) => country.id == 165,
        orElse: () => countries.first,
      );
    });
  } catch (e) {
    // Fallback to API
    final countries = await LocationService.fetchCountries();
    setState(() {
      _selectedCountry = countries.firstWhere(
        (country) => country.id == 165,
        orElse: () => countries.first,
      );
    });
  }
}

void _loadLocationData() async {
  try {
    await LocationService.refreshGovernorates();
  } catch (e) {
    debugPrint('Failed to refresh governorates: $e');
  }
}
```

---

## 📤 Order Creation & ID Passing

### Order Request Model: `lib/features/shipment/data/models/order_models.dart`

```dart
class CreateOrderRequest extends Equatable {
  // ... other fields
  
  final int countryId;         // ⬅️ Required
  final int governorateId;     // ⬅️ Required
  final int stateId;           // ⬅️ Required
  final int? placeId;          // ⬅️ Optional (can be null)
  final int cityId;            // ⬅️ Required (default: 1)
  
  // ... other fields
  
  const CreateOrderRequest({
    // ... other params
    required this.countryId,
    required this.governorateId,
    required this.stateId,
    this.placeId,              // Optional
    this.cityId = 1,           // Default value
    // ... other params
  });
  
  Map<String, dynamic> toJson() {
    return {
      // ... other fields
      'country_id': countryId,
      'governorate_id': governorateId,
      'state_id': stateId,
      if (placeId != null) 'place_id': placeId,  // ⬅️ Only include if not null
      'city_id': cityId,
      // ... other fields
    };
  }
}
```

### Order Submission Flow:

```dart
void _submitOrder() {
  // Validate form
  if (_formKey.currentState!.validate()) {
    // Validate required location selections
    if (_selectedCountry == null ||
        _selectedGovernorate == null ||
        _selectedState == null) {
      _showErrorToast('Please select all required location fields');
      return;
    }
    
    // Create request with IDs
    final request = CreateOrderRequest(
      // ... other fields
      countryId: _selectedCountry!.id,           // ⬅️ Pass Country ID
      governorateId: _selectedGovernorate!.id,   // ⬅️ Pass Governorate ID
      stateId: _selectedState!.id,               // ⬅️ Pass State ID
      placeId: _selectedPlace?.id,               // ⬅️ Pass Place ID (nullable)
      cityId: 1,                                  // ⬅️ Default city ID
      // ... other fields
    );
    
    // Submit to API
    context.read<OrderCubit>().createOrder(request);
  }
}
```

### API Call:
```dart
// In OrderRepository
Future<CreateOrderResponse> createOrder(CreateOrderRequest request) async {
  final response = await AppRequest.post(
    AppEndPoints.createOrder,
    request.toJson(),
    true,  // Authentication required
  );
  
  if (response.success && response.origin != null) {
    return CreateOrderResponse.fromJson(response.origin!);
  } else {
    throw Exception(response.message);
  }
}
```

### API Request Body Example:
```json
{
  "name": "Ahmed Ali",
  "cellphone": "+96899887766",
  "streetAddress": "Building 123, Street 45",
  "country_id": 165,           // ⬅️ Oman
  "governorate_id": 3,         // ⬅️ Muscat
  "state_id": 25,              // ⬅️ Al Khuwair
  "place_id": 102,             // ⬅️ Optional: specific place in Al Khuwair
  "city_id": 1,                // ⬅️ Default
  "payment_type": "cod",
  "amount": 25.500,
  "delivery_fee": 3.000,
  "notes": "Order created via mobile app"
}
```

---

## 💾 Caching Strategy

### Why Caching?
- **Offline Support**: Users can select locations without internet
- **Performance**: Instant dropdown loading
- **Reduced API Calls**: Data is cached locally
- **Fallback**: Assets (JSON files) if API fails

### Storage Layers:

1. **Primary Storage: Hive Boxes**
   - `governorates` box (typeId: 0)
   - `states` box (typeId: 1)
   - `places` box (typeId: 2)
   - `countries` box (typeId: 3)

2. **Fallback Storage: JSON Assets**
   - `assets/jsons/countries.json`
   - `assets/jsons/governrates.json` (sic - typo in filename)
   - `assets/jsons/states.json`
   - `assets/jsons/places.json`
   - `assets/jsons/country_translations.json`

### Loading Priority:
```
1. Check Hive Box
   ↓ (if empty)
2. Try API
   ↓ (if fails)
3. Load from JSON Asset
```

### Refresh Strategy:
```dart
// Refresh on demand (when user selects a parent entity)
// Example: When governorate is selected, refresh states

if (governorate != null) {
  try {
    await LocationService.refreshStates();
  } catch (e) {
    debugPrint('Failed to refresh states: $e');
    // Continue with cached data
  }
}
```

---

## 📋 Implementation Checklist for Driver App

### 1. Setup Dependencies
```yaml
# pubspec.yaml
dependencies:
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  equatable: ^2.0.5

dev_dependencies:
  hive_generator: ^2.0.0
  build_runner: ^2.4.0
```

### 2. Create Data Models
- [ ] Copy `lib/core/models/location_models.dart`
- [ ] Copy `lib/core/models/location_models.g.dart` (generated)
- [ ] Run `flutter pub run build_runner build`

### 3. Create Service Layer
- [ ] Copy `lib/core/services/location_service.dart`
- [ ] Copy `lib/core/services/country_localization_service.dart`
- [ ] Update API endpoints if needed

### 4. Add API Endpoints
- [ ] Update `AppEndPoints` class with:
  ```dart
  static const String countries = 'countries';
  static const String governorates = 'governorates/all';
  static const String states = 'states/all';
  static const String places = 'places/all';
  ```

### 5. Create UI Widgets
- [ ] Copy `lib/core/widgets/searchable_country_dropdown.dart`
- [ ] Copy `lib/core/widgets/searchable_governorate_dropdown.dart`
- [ ] Copy `lib/core/widgets/searchable_state_dropdown.dart`
- [ ] Copy `lib/core/widgets/searchable_place_dropdown.dart`

### 6. Add JSON Assets
- [ ] Copy `assets/jsons/countries.json`
- [ ] Copy `assets/jsons/governrates.json`
- [ ] Copy `assets/jsons/states.json`
- [ ] Copy `assets/jsons/places.json`
- [ ] Copy `assets/jsons/country_translations.json`
- [ ] Update `pubspec.yaml` assets section

### 7. Initialize Services
```dart
// In main.dart before runApp()
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize location services
  await CountryLocalizationService.initialize();
  await LocationService.initialize();
  
  runApp(MyApp());
}
```

### 8. Update Driver Order Model
Based on your driver app's create order endpoint, create a model like:

```dart
class DriverCreateOrderRequest extends Equatable {
  // Driver-specific fields
  final int driverId;
  final String pickupLocation;
  final String deliveryLocation;
  
  // Location IDs
  final int countryId;
  final int governorateId;
  final int stateId;
  final int? placeId;
  final int cityId;
  
  // Other fields specific to driver orders
  
  Map<String, dynamic> toJson() {
    return {
      'driver_id': driverId,
      'pickup_location': pickupLocation,
      'delivery_location': deliveryLocation,
      'country_id': countryId,
      'governorate_id': governorateId,
      'state_id': stateId,
      if (placeId != null) 'place_id': placeId,
      'city_id': cityId,
      // ... other fields
    };
  }
}
```

### 9. Implement Selection UI
```dart
// In your driver order creation page

// State variables
Country? _selectedCountry;
Governorate? _selectedGovernorate;
StateModel? _selectedState;
Place? _selectedPlace;

// UI
Column(
  children: [
    SearchableCountryDropdown(
      value: _selectedCountry,
      onChanged: (country) {
        setState(() {
          _selectedCountry = country;
          _selectedGovernorate = null;
          _selectedState = null;
          _selectedPlace = null;
        });
      },
      // ... other props
    ),
    
    SearchableGovernorateDropdown(
      value: _selectedGovernorate,
      countryId: _selectedCountry?.id,
      onChanged: (gov) {
        setState(() {
          _selectedGovernorate = gov;
          _selectedState = null;
          _selectedPlace = null;
        });
      },
      // ... other props
    ),
    
    SearchableStateDropdown(
      value: _selectedState,
      governorateId: _selectedGovernorate?.id,
      onChanged: (state) {
        setState(() {
          _selectedState = state;
          _selectedPlace = null;
        });
      },
      // ... other props
    ),
    
    SearchablePlaceDropdown(
      value: _selectedPlace,
      stateId: _selectedState?.id,
      onChanged: (place) {
        setState(() {
          _selectedPlace = place;
        });
      },
      isRequired: false,
      // ... other props
    ),
  ],
)
```

### 10. Submit Order with IDs
```dart
void _submitDriverOrder() {
  if (_formKey.currentState!.validate()) {
    if (_selectedCountry == null ||
        _selectedGovernorate == null ||
        _selectedState == null) {
      // Show error
      return;
    }
    
    final request = DriverCreateOrderRequest(
      driverId: currentDriverId,
      pickupLocation: _pickupController.text,
      deliveryLocation: _deliveryController.text,
      countryId: _selectedCountry!.id,
      governorateId: _selectedGovernorate!.id,
      stateId: _selectedState!.id,
      placeId: _selectedPlace?.id,
      cityId: 1,
      // ... other fields
    );
    
    // Submit via Cubit/Bloc
    context.read<DriverOrderCubit>().createOrder(request);
  }
}
```

---

## 🔑 Key Design Decisions

### Why Separate Country Service?
- Countries are static and rarely change
- Need translation support for all countries
- Shared across multiple features
- No dependency on authentication

### Why Hive for Caching?
- Fast, synchronous access
- Type-safe with code generation
- Perfect for offline-first apps
- Small storage footprint

### Why Modal Bottom Sheets?
- Better UX on mobile than dropdown lists
- Allows search functionality
- Shows more options at once
- Consistent with Material Design

### Why Cascade Reset?
- Prevents invalid selections (e.g., state from different governorate)
- Forces user to make valid hierarchical choices
- Improves data integrity
- Better UX - clear what depends on what

### Why Place is Optional?
- Not all addresses have a specific place
- Allows flexibility in address entry
- State-level precision is usually sufficient
- Backend handles null place IDs

---

## 🚨 Important Notes

1. **Authentication**: Governorate, State, and Place endpoints require authentication. Country endpoint does not.

2. **Default Values**:
   - Default country: Oman (ID: 165)
   - Default city ID: 1

3. **Bilingual Support**: All location entities (except Country) have `enName` and `arName`. Use locale to determine which to display:
   ```dart
   final isRTL = Localizations.localeOf(context).languageCode == 'ar';
   final localizedName = isRTL ? governorate.arName : governorate.enName;
   ```

4. **Search Behavior**: When user searches in a dropdown, the filter temporarily ignores parent entity (e.g., searching states shows ALL states, not just from selected governorate). This helps users find locations across the hierarchy.

5. **Validation**: Country, Governorate, and State are **required**. Place is **optional**.

6. **IDs are Integers**: All location IDs are `int`, not `String`.

7. **Pricing Integration**: In the client app, selecting a state automatically updates delivery fee based on pricing data. Implement similar logic in driver app if needed.

---

