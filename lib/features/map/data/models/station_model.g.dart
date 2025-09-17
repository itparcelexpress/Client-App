// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StationResponse _$StationResponseFromJson(Map<String, dynamic> json) =>
    StationResponse(
      message: json['message'] as String,
      success: json['success'] as bool,
      data: StationData.fromJson(json['data'] as Map<String, dynamic>),
      errors: json['errors'] as List<dynamic>,
    );

Map<String, dynamic> _$StationResponseToJson(StationResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      'data': instance.data,
      'errors': instance.errors,
    };

StationData _$StationDataFromJson(Map<String, dynamic> json) => StationData(
      currentPage: (json['currentPage'] as num).toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => Station.fromJson(e as Map<String, dynamic>))
          .toList(),
      firstPageUrl: json['firstPageUrl'] as String,
      from: (json['from'] as num).toInt(),
      lastPage: (json['lastPage'] as num).toInt(),
      lastPageUrl: json['lastPageUrl'] as String,
      links: (json['links'] as List<dynamic>)
          .map((e) => StationLink.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextPageUrl: json['nextPageUrl'] as String?,
      path: json['path'] as String,
      perPage: (json['perPage'] as num).toInt(),
      prevPageUrl: json['prevPageUrl'] as String?,
      to: (json['to'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$StationDataToJson(StationData instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'data': instance.data,
      'firstPageUrl': instance.firstPageUrl,
      'from': instance.from,
      'lastPage': instance.lastPage,
      'lastPageUrl': instance.lastPageUrl,
      'links': instance.links,
      'nextPageUrl': instance.nextPageUrl,
      'path': instance.path,
      'perPage': instance.perPage,
      'prevPageUrl': instance.prevPageUrl,
      'to': instance.to,
      'total': instance.total,
    };

Station _$StationFromJson(Map<String, dynamic> json) => Station(
      id: (json['id'] as num).toInt(),
      ownerType: json['ownerType'] as String?,
      ownerId: (json['ownerId'] as num?)?.toInt(),
      hubId: (json['hubId'] as num).toInt(),
      name: json['name'] as String,
      contactNumber: json['contactNumber'] as String,
      location: json['location'] as String,
      address: json['address'] as String?,
      countryId: (json['countryId'] as num).toInt(),
      governorateId: (json['governorateId'] as num).toInt(),
      stateId: (json['stateId'] as num).toInt(),
      placeId: (json['placeId'] as num).toInt(),
      cityId: (json['cityId'] as num).toInt(),
      lat: json['lat'] as String,
      lng: json['lng'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      hub: Hub.fromJson(json['hub'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StationToJson(Station instance) => <String, dynamic>{
      'id': instance.id,
      'ownerType': instance.ownerType,
      'ownerId': instance.ownerId,
      'hubId': instance.hubId,
      'name': instance.name,
      'contactNumber': instance.contactNumber,
      'location': instance.location,
      'address': instance.address,
      'countryId': instance.countryId,
      'governorateId': instance.governorateId,
      'stateId': instance.stateId,
      'placeId': instance.placeId,
      'cityId': instance.cityId,
      'lat': instance.lat,
      'lng': instance.lng,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'hub': instance.hub,
    };

Hub _$HubFromJson(Map<String, dynamic> json) => Hub(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      location: json['location'] as String,
      address: json['address'] as String?,
      ownerType: json['ownerType'] as String?,
      ownerId: (json['ownerId'] as num?)?.toInt(),
      contactNumber: json['contactNumber'] as String,
      countryId: (json['countryId'] as num).toInt(),
      governorateId: (json['governorateId'] as num).toInt(),
      stateId: (json['stateId'] as num).toInt(),
      placeId: (json['placeId'] as num).toInt(),
      cityId: (json['cityId'] as num).toInt(),
      lat: json['lat'] as String,
      lng: json['lng'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$HubToJson(Hub instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': instance.location,
      'address': instance.address,
      'ownerType': instance.ownerType,
      'ownerId': instance.ownerId,
      'contactNumber': instance.contactNumber,
      'countryId': instance.countryId,
      'governorateId': instance.governorateId,
      'stateId': instance.stateId,
      'placeId': instance.placeId,
      'cityId': instance.cityId,
      'lat': instance.lat,
      'lng': instance.lng,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

StationLink _$StationLinkFromJson(Map<String, dynamic> json) => StationLink(
      url: json['url'] as String?,
      label: json['label'] as String,
      active: json['active'] as bool,
    );

Map<String, dynamic> _$StationLinkToJson(StationLink instance) =>
    <String, dynamic>{
      'url': instance.url,
      'label': instance.label,
      'active': instance.active,
    };
