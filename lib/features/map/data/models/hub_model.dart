import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'hub_model.g.dart';

@JsonSerializable()
class HubResponse extends Equatable {
  final String message;
  final bool success;
  final HubData data;
  final List<dynamic> errors;

  const HubResponse({
    required this.message,
    required this.success,
    required this.data,
    required this.errors,
  });

  factory HubResponse.fromJson(Map<String, dynamic> json) =>
      _$HubResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HubResponseToJson(this);

  @override
  List<Object?> get props => [message, success, data, errors];
}

@JsonSerializable()
class HubData extends Equatable {
  final int currentPage;
  final List<HubDetail> data;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<HubLink> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  const HubData({
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

  factory HubData.fromJson(Map<String, dynamic> json) =>
      _$HubDataFromJson(json);

  Map<String, dynamic> toJson() => _$HubDataToJson(this);

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
class HubDetail extends Equatable {
  final int id;
  final String name;
  final String location;
  final String? address;
  final String? ownerType;
  final int? ownerId;
  final String contactNumber;
  final int countryId;
  final int governorateId;
  final int stateId;
  final int placeId;
  final int cityId;
  final String lat;
  final String lng;
  final String createdAt;
  final String updatedAt;
  final Country country;
  final State state;
  final City city;
  final Governorate governorate;
  final Place place;

  const HubDetail({
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
    required this.country,
    required this.state,
    required this.city,
    required this.governorate,
    required this.place,
  });

  factory HubDetail.fromJson(Map<String, dynamic> json) =>
      _$HubDetailFromJson(json);

  Map<String, dynamic> toJson() => _$HubDetailToJson(this);

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
    country,
    state,
    city,
    governorate,
    place,
  ];
}

@JsonSerializable()
class Country extends Equatable {
  final int id;
  final String name;
  final String code;
  final int phonecode;
  final String? createdAt;
  final String? updatedAt;

  const Country({
    required this.id,
    required this.name,
    required this.code,
    required this.phonecode,
    this.createdAt,
    this.updatedAt,
  });

  factory Country.fromJson(Map<String, dynamic> json) =>
      _$CountryFromJson(json);

  Map<String, dynamic> toJson() => _$CountryToJson(this);

  @override
  List<Object?> get props => [id, name, code, phonecode, createdAt, updatedAt];
}

@JsonSerializable()
class State extends Equatable {
  final int id;
  final int countryId;
  final int governorateId;
  final String enName;
  final String arName;
  final String lat;
  final String lng;
  final String? polygon;
  final String createdAt;
  final String updatedAt;
  final PolygonGeojson? polygonGeojson;

  const State({
    required this.id,
    required this.countryId,
    required this.governorateId,
    required this.enName,
    required this.arName,
    required this.lat,
    required this.lng,
    this.polygon,
    required this.createdAt,
    required this.updatedAt,
    this.polygonGeojson,
  });

  factory State.fromJson(Map<String, dynamic> json) => _$StateFromJson(json);

  Map<String, dynamic> toJson() => _$StateToJson(this);

  @override
  List<Object?> get props => [
    id,
    countryId,
    governorateId,
    enName,
    arName,
    lat,
    lng,
    polygon,
    createdAt,
    updatedAt,
    polygonGeojson,
  ];
}

@JsonSerializable()
class City extends Equatable {
  final int id;
  final int stateId;
  final String name;
  final String? createdAt;
  final String? updatedAt;

  const City({
    required this.id,
    required this.stateId,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);

  Map<String, dynamic> toJson() => _$CityToJson(this);

  @override
  List<Object?> get props => [id, stateId, name, createdAt, updatedAt];
}

@JsonSerializable()
class Governorate extends Equatable {
  final int id;
  final int countryId;
  final String enName;
  final String arName;
  final String lat;
  final String lng;
  final String createdAt;
  final String updatedAt;

  const Governorate({
    required this.id,
    required this.countryId,
    required this.enName,
    required this.arName,
    required this.lat,
    required this.lng,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Governorate.fromJson(Map<String, dynamic> json) =>
      _$GovernorateFromJson(json);

  Map<String, dynamic> toJson() => _$GovernorateToJson(this);

  @override
  List<Object?> get props => [
    id,
    countryId,
    enName,
    arName,
    lat,
    lng,
    createdAt,
    updatedAt,
  ];
}

@JsonSerializable()
class Place extends Equatable {
  final int id;
  final int stateId;
  final String arName;
  final String enName;
  final String? lat;
  final String? lng;
  final String createdAt;
  final String updatedAt;

  const Place({
    required this.id,
    required this.stateId,
    required this.arName,
    required this.enName,
    this.lat,
    this.lng,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceToJson(this);

  @override
  List<Object?> get props => [
    id,
    stateId,
    arName,
    enName,
    lat,
    lng,
    createdAt,
    updatedAt,
  ];
}

@JsonSerializable()
class PolygonGeojson extends Equatable {
  final String type;
  final List<List<List<List<double>>>> coordinates;

  const PolygonGeojson({required this.type, required this.coordinates});

  factory PolygonGeojson.fromJson(Map<String, dynamic> json) =>
      _$PolygonGeojsonFromJson(json);

  Map<String, dynamic> toJson() => _$PolygonGeojsonToJson(this);

  @override
  List<Object?> get props => [type, coordinates];
}

@JsonSerializable()
class HubLink extends Equatable {
  final String? url;
  final String label;
  final bool active;

  const HubLink({this.url, required this.label, required this.active});

  factory HubLink.fromJson(Map<String, dynamic> json) =>
      _$HubLinkFromJson(json);

  Map<String, dynamic> toJson() => _$HubLinkToJson(this);

  @override
  List<Object?> get props => [url, label, active];
}
