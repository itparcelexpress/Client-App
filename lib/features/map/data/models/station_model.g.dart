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
      currentPage: (json['current_page'] as num).toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => Station.fromJson(e as Map<String, dynamic>))
          .toList(),
      firstPageUrl: json['first_page_url'] as String,
      from: (json['from'] as num?)?.toInt(),
      lastPage: (json['last_page'] as num).toInt(),
      lastPageUrl: json['last_page_url'] as String,
      links: (json['links'] as List<dynamic>)
          .map((e) => StationLink.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextPageUrl: json['next_page_url'] as String?,
      path: json['path'] as String,
      perPage: (json['per_page'] as num).toInt(),
      prevPageUrl: json['prev_page_url'] as String?,
      to: (json['to'] as num?)?.toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$StationDataToJson(StationData instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'data': instance.data,
      'first_page_url': instance.firstPageUrl,
      'from': instance.from,
      'last_page': instance.lastPage,
      'last_page_url': instance.lastPageUrl,
      'links': instance.links,
      'next_page_url': instance.nextPageUrl,
      'path': instance.path,
      'per_page': instance.perPage,
      'prev_page_url': instance.prevPageUrl,
      'to': instance.to,
      'total': instance.total,
    };

Station _$StationFromJson(Map<String, dynamic> json) => Station(
      id: (json['id'] as num).toInt(),
      ownerType: json['owner_type'] as String?,
      ownerId: (json['owner_id'] as num?)?.toInt(),
      hubId: (json['hub_id'] as num).toInt(),
      name: json['name'] as String,
      contactNumber: json['contact_number'] as String,
      location: json['location'] as String,
      address: json['address'] as String?,
      countryId: (json['country_id'] as num).toInt(),
      governorateId: (json['governorate_id'] as num).toInt(),
      stateId: (json['state_id'] as num).toInt(),
      placeId: (json['place_id'] as num).toInt(),
      cityId: (json['city_id'] as num).toInt(),
      lat: json['lat'] as String,
      lng: json['lng'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      hub: Hub.fromJson(json['hub'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StationToJson(Station instance) => <String, dynamic>{
      'id': instance.id,
      'owner_type': instance.ownerType,
      'owner_id': instance.ownerId,
      'hub_id': instance.hubId,
      'name': instance.name,
      'contact_number': instance.contactNumber,
      'location': instance.location,
      'address': instance.address,
      'country_id': instance.countryId,
      'governorate_id': instance.governorateId,
      'state_id': instance.stateId,
      'place_id': instance.placeId,
      'city_id': instance.cityId,
      'lat': instance.lat,
      'lng': instance.lng,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'hub': instance.hub,
    };

Hub _$HubFromJson(Map<String, dynamic> json) => Hub(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      location: json['location'] as String,
      address: json['address'] as String?,
      ownerType: json['owner_type'] as String?,
      ownerId: (json['owner_id'] as num?)?.toInt(),
      contactNumber: json['contact_number'] as String,
      countryId: (json['country_id'] as num).toInt(),
      governorateId: (json['governorate_id'] as num).toInt(),
      stateId: (json['state_id'] as num).toInt(),
      placeId: (json['place_id'] as num).toInt(),
      cityId: (json['city_id'] as num).toInt(),
      lat: json['lat'] as String,
      lng: json['lng'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$HubToJson(Hub instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': instance.location,
      'address': instance.address,
      'owner_type': instance.ownerType,
      'owner_id': instance.ownerId,
      'contact_number': instance.contactNumber,
      'country_id': instance.countryId,
      'governorate_id': instance.governorateId,
      'state_id': instance.stateId,
      'place_id': instance.placeId,
      'city_id': instance.cityId,
      'lat': instance.lat,
      'lng': instance.lng,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
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
