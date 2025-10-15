import 'package:equatable/equatable.dart';

// Country Model (simple structure from API)
class Country extends Equatable {
  final int id;
  final String name;

  const Country({required this.id, required this.name});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(id: json['id'] ?? 0, name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  @override
  List<Object?> get props => [id, name];
}

// Governorate Model for Address Book (matches API response)
class AddressGovernorate extends Equatable {
  final int id;
  final String enName;
  final String arName;

  const AddressGovernorate({
    required this.id,
    required this.enName,
    required this.arName,
  });

  factory AddressGovernorate.fromJson(Map<String, dynamic> json) {
    return AddressGovernorate(
      id: json['id'] ?? 0,
      enName: json['en_name'] ?? '',
      arName: json['ar_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'en_name': enName, 'ar_name': arName};
  }

  @override
  List<Object?> get props => [id, enName, arName];
}

// State Model for Address Book (matches API response)
class AddressState extends Equatable {
  final int id;
  final String enName;
  final String arName;
  final List<dynamic> zones;

  const AddressState({
    required this.id,
    required this.enName,
    required this.arName,
    required this.zones,
  });

  factory AddressState.fromJson(Map<String, dynamic> json) {
    return AddressState(
      id: json['id'] ?? 0,
      enName: json['en_name'] ?? '',
      arName: json['ar_name'] ?? '',
      zones: json['zones'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'en_name': enName, 'ar_name': arName, 'zones': zones};
  }

  @override
  List<Object?> get props => [id, enName, arName, zones];
}

// Place Model for Address Book (matches API response)
class AddressPlace extends Equatable {
  final int id;
  final String enName;
  final String arName;

  const AddressPlace({
    required this.id,
    required this.enName,
    required this.arName,
  });

  factory AddressPlace.fromJson(Map<String, dynamic> json) {
    return AddressPlace(
      id: json['id'] ?? 0,
      enName: json['en_name'] ?? '',
      arName: json['ar_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'en_name': enName, 'ar_name': arName};
  }

  @override
  List<Object?> get props => [id, enName, arName];
}

// Address Book Entry Model
class AddressBookEntry extends Equatable {
  final int? id;
  final int? clientId;
  final String name;
  final String email;
  final String cellphone;
  final String alternatePhone;
  final int countryId;
  final int governorateId;
  final int stateId;
  final int placeId;
  final String? zipcode;
  final String streetAddress;
  final String? locationUrl;
  final String? createdAt;
  final String? updatedAt;
  final Country? country;
  final AddressGovernorate? governorate;
  final AddressState? state;
  final AddressPlace? place;

  const AddressBookEntry({
    this.id,
    this.clientId,
    required this.name,
    required this.email,
    required this.cellphone,
    required this.alternatePhone,
    required this.countryId,
    required this.governorateId,
    required this.stateId,
    required this.placeId,
    this.zipcode,
    required this.streetAddress,
    this.locationUrl,
    this.createdAt,
    this.updatedAt,
    this.country,
    this.governorate,
    this.state,
    this.place,
  });

  factory AddressBookEntry.fromJson(Map<String, dynamic> json) {
    return AddressBookEntry(
      id: json['id'],
      clientId: json['client_id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      cellphone: json['cellphone'] ?? '',
      alternatePhone: json['alternatePhone'] ?? '',
      countryId: json['country_id'] ?? 0,
      governorateId: json['governorate_id'] ?? 0,
      stateId: json['state_id'] ?? 0,
      placeId: json['place_id'] ?? 0,
      zipcode: json['zipcode'],
      streetAddress: json['streetAddress'] ?? '',
      locationUrl: json['location_url'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      country:
          json['country'] != null ? Country.fromJson(json['country']) : null,
      governorate:
          json['governorate'] != null
              ? AddressGovernorate.fromJson(json['governorate'])
              : null,
      state:
          json['state'] != null ? AddressState.fromJson(json['state']) : null,
      place:
          json['place'] != null ? AddressPlace.fromJson(json['place']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'name': name,
      'email': email,
      'cellphone': cellphone,
      'alternatePhone': alternatePhone,
      'country_id': countryId,
      'governorate_id': governorateId,
      'state_id': stateId,
      'place_id': placeId,
      'zipcode': zipcode,
      'streetAddress': streetAddress,
      'location_url': locationUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'country': country?.toJson(),
      'governorate': governorate?.toJson(),
      'state': state?.toJson(),
      'place': place?.toJson(),
    };
  }

  // Create a request model for API calls (without server-generated fields)
  Map<String, dynamic> toCreateRequest() {
    return {
      'name': name,
      'email': email,
      'cellphone': cellphone,
      'alternatePhone': alternatePhone,
      'country_id': countryId.toString(),
      'governorate_id': governorateId.toString(),
      'state_id': stateId.toString(),
      'place_id': placeId.toString(),
      'streetAddress': streetAddress,
      if (zipcode != null) 'zipcode': zipcode,
      if (locationUrl != null) 'location_url': locationUrl,
    };
  }

  @override
  List<Object?> get props => [
    id,
    clientId,
    name,
    email,
    cellphone,
    alternatePhone,
    countryId,
    governorateId,
    stateId,
    placeId,
    zipcode,
    streetAddress,
    locationUrl,
    createdAt,
    updatedAt,
    country,
    governorate,
    state,
    place,
  ];
}

// Address Book Request Model for creating new entries
class AddressBookRequest extends Equatable {
  final String name;
  final String email;
  final String cellphone;
  final String alternatePhone;
  final int countryId;
  final int governorateId;
  final int stateId;
  final int placeId;
  final String streetAddress;
  final String? zipcode;
  final String? locationUrl;

  const AddressBookRequest({
    required this.name,
    this.email = "",
    required this.cellphone,
    required this.alternatePhone,
    required this.countryId,
    required this.governorateId,
    required this.stateId,
    required this.placeId,
    required this.streetAddress,
    this.zipcode,
    this.locationUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'cellphone': cellphone,
      'alternatePhone': alternatePhone,
      'country_id': countryId.toString(),
      'governorate_id': governorateId.toString(),
      'state_id': stateId.toString(),
      'place_id': placeId.toString(),
      'streetAddress': streetAddress,
      if (zipcode != null) 'zipcode': zipcode,
      if (locationUrl != null) 'location_url': locationUrl,
    };
  }

  @override
  List<Object?> get props => [
    name,
    email,
    cellphone,
    alternatePhone,
    countryId,
    governorateId,
    stateId,
    placeId,
    streetAddress,
    zipcode,
    locationUrl,
  ];
}

// Address Book Pagination Data
class AddressBookPaginationData extends Equatable {
  final int currentPage;
  final List<AddressBookEntry> data;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<PaginationLink> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  const AddressBookPaginationData({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory AddressBookPaginationData.fromJson(Map<String, dynamic> json) {
    return AddressBookPaginationData(
      currentPage: json['current_page'] ?? 1,
      data:
          (json['data'] as List<dynamic>? ?? [])
              .map(
                (item) =>
                    AddressBookEntry.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
      firstPageUrl: json['first_page_url'] ?? '',
      from: json['from'] ?? 0,
      lastPage: json['last_page'] ?? 1,
      lastPageUrl: json['last_page_url'] ?? '',
      links:
          (json['links'] as List<dynamic>? ?? [])
              .map(
                (item) => PaginationLink.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
      nextPageUrl: json['next_page_url'],
      path: json['path'] ?? '',
      perPage: json['per_page'] ?? 10,
      prevPageUrl: json['prev_page_url'],
      to: json['to'] ?? 0,
      total: json['total'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
    currentPage,
    data,
    firstPageUrl,
    from,
    lastPage,
    lastPageUrl,
    links,
    nextPageUrl,
    path,
    perPage,
    prevPageUrl,
    to,
    total,
  ];
}

// Pagination Link Model
class PaginationLink extends Equatable {
  final String? url;
  final String label;
  final bool active;

  const PaginationLink({this.url, required this.label, required this.active});

  factory PaginationLink.fromJson(Map<String, dynamic> json) {
    return PaginationLink(
      url: json['url'],
      label: json['label'] ?? '',
      active: json['active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'label': label, 'active': active};
  }

  @override
  List<Object?> get props => [url, label, active];
}

// Address Book Response Models
class AddressBookResponse extends Equatable {
  final String message;
  final bool success;
  final AddressBookEntry? data;
  final List<dynamic> errors;

  const AddressBookResponse({
    required this.message,
    required this.success,
    this.data,
    required this.errors,
  });

  factory AddressBookResponse.fromJson(Map<String, dynamic> json) {
    return AddressBookResponse(
      message: json['message'] ?? '',
      success: json['success'] ?? false,
      data:
          json['data'] != null ? AddressBookEntry.fromJson(json['data']) : null,
      errors: json['errors'] ?? [],
    );
  }

  @override
  List<Object?> get props => [message, success, data, errors];
}

class AddressBookListResponse extends Equatable {
  final String message;
  final bool success;
  final AddressBookPaginationData data;
  final List<dynamic> errors;

  const AddressBookListResponse({
    required this.message,
    required this.success,
    required this.data,
    required this.errors,
  });

  factory AddressBookListResponse.fromJson(Map<String, dynamic> json) {
    return AddressBookListResponse(
      message: json['message'] ?? '',
      success: json['success'] ?? false,
      data: AddressBookPaginationData.fromJson(json['data'] ?? {}),
      errors: json['errors'] ?? [],
    );
  }

  @override
  List<Object?> get props => [message, success, data, errors];
}
