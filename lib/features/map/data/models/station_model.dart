import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'station_model.g.dart';

@JsonSerializable()
class StationResponse extends Equatable {
  final String message;
  final bool success;
  final StationData data;
  final List<dynamic> errors;

  const StationResponse({
    required this.message,
    required this.success,
    required this.data,
    required this.errors,
  });

  factory StationResponse.fromJson(Map<String, dynamic> json) =>
      _$StationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StationResponseToJson(this);

  @override
  List<Object?> get props => [message, success, data, errors];
}

@JsonSerializable()
class StationData extends Equatable {
  @JsonKey(name: 'current_page')
  final int currentPage;
  final List<Station> data;
  @JsonKey(name: 'first_page_url')
  final String firstPageUrl;
  final int? from;
  @JsonKey(name: 'last_page')
  final int lastPage;
  @JsonKey(name: 'last_page_url')
  final String lastPageUrl;
  final List<StationLink> links;
  @JsonKey(name: 'next_page_url')
  final String? nextPageUrl;
  final String path;
  @JsonKey(name: 'per_page')
  final int perPage;
  @JsonKey(name: 'prev_page_url')
  final String? prevPageUrl;
  final int? to;
  final int total;

  const StationData({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    this.to,
    required this.total,
  });

  factory StationData.fromJson(Map<String, dynamic> json) =>
      _$StationDataFromJson(json);

  Map<String, dynamic> toJson() => _$StationDataToJson(this);

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

@JsonSerializable()
class Station extends Equatable {
  final int id;
  @JsonKey(name: 'owner_type')
  final String? ownerType;
  @JsonKey(name: 'owner_id')
  final int? ownerId;
  @JsonKey(name: 'hub_id')
  final int hubId;
  final String name;
  @JsonKey(name: 'contact_number')
  final String contactNumber;
  final String location;
  final String? address;
  @JsonKey(name: 'country_id')
  final int countryId;
  @JsonKey(name: 'governorate_id')
  final int governorateId;
  @JsonKey(name: 'state_id')
  final int stateId;
  @JsonKey(name: 'place_id')
  final int placeId;
  @JsonKey(name: 'city_id')
  final int cityId;
  final String lat;
  final String lng;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  final Hub hub;

  const Station({
    required this.id,
    this.ownerType,
    this.ownerId,
    required this.hubId,
    required this.name,
    required this.contactNumber,
    required this.location,
    this.address,
    required this.countryId,
    required this.governorateId,
    required this.stateId,
    required this.placeId,
    required this.cityId,
    required this.lat,
    required this.lng,
    required this.createdAt,
    required this.updatedAt,
    required this.hub,
  });

  factory Station.fromJson(Map<String, dynamic> json) =>
      _$StationFromJson(json);

  Map<String, dynamic> toJson() => _$StationToJson(this);

  @override
  List<Object?> get props => [
    id,
    ownerType,
    ownerId,
    hubId,
    name,
    contactNumber,
    location,
    address,
    countryId,
    governorateId,
    stateId,
    placeId,
    cityId,
    lat,
    lng,
    createdAt,
    updatedAt,
    hub,
  ];
}

@JsonSerializable()
class Hub extends Equatable {
  final int id;
  final String name;
  final String location;
  final String? address;
  @JsonKey(name: 'owner_type')
  final String? ownerType;
  @JsonKey(name: 'owner_id')
  final int? ownerId;
  @JsonKey(name: 'contact_number')
  final String contactNumber;
  @JsonKey(name: 'country_id')
  final int countryId;
  @JsonKey(name: 'governorate_id')
  final int governorateId;
  @JsonKey(name: 'state_id')
  final int stateId;
  @JsonKey(name: 'place_id')
  final int placeId;
  @JsonKey(name: 'city_id')
  final int cityId;
  final String lat;
  final String lng;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  const Hub({
    required this.id,
    required this.name,
    required this.location,
    this.address,
    this.ownerType,
    this.ownerId,
    required this.contactNumber,
    required this.countryId,
    required this.governorateId,
    required this.stateId,
    required this.placeId,
    required this.cityId,
    required this.lat,
    required this.lng,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Hub.fromJson(Map<String, dynamic> json) => _$HubFromJson(json);

  Map<String, dynamic> toJson() => _$HubToJson(this);

  @override
  List<Object?> get props => [
    id,
    name,
    location,
    address,
    ownerType,
    ownerId,
    contactNumber,
    countryId,
    governorateId,
    stateId,
    placeId,
    cityId,
    lat,
    lng,
    createdAt,
    updatedAt,
  ];
}

@JsonSerializable()
class StationLink extends Equatable {
  final String? url;
  final String label;
  final bool active;

  const StationLink({this.url, required this.label, required this.active});

  factory StationLink.fromJson(Map<String, dynamic> json) =>
      _$StationLinkFromJson(json);

  Map<String, dynamic> toJson() => _$StationLinkToJson(this);

  @override
  List<Object?> get props => [url, label, active];
}
