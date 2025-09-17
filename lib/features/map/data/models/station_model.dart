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
  final int currentPage;
  final List<Station> data;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<StationLink> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  const StationData({
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
  final String? ownerType;
  final int? ownerId;
  final int hubId;
  final String name;
  final String contactNumber;
  final String location;
  final String? address;
  final int countryId;
  final int governorateId;
  final int stateId;
  final int placeId;
  final int cityId;
  final String lat;
  final String lng;
  final String createdAt;
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
