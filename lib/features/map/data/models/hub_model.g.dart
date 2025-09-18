// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hub_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HubResponse _$HubResponseFromJson(Map<String, dynamic> json) => HubResponse(
      message: json['message'] as String,
      success: json['success'] as bool,
      data: HubData.fromJson(json['data'] as Map<String, dynamic>),
      errors: json['errors'] as List<dynamic>,
    );

Map<String, dynamic> _$HubResponseToJson(HubResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      'data': instance.data,
      'errors': instance.errors,
    };

HubData _$HubDataFromJson(Map<String, dynamic> json) => HubData(
      currentPage: (json['current_page'] as num).toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => HubDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      firstPageUrl: json['first_page_url'] as String,
      from: (json['from'] as num?)?.toInt(),
      lastPage: (json['last_page'] as num).toInt(),
      lastPageUrl: json['last_page_url'] as String,
      links: (json['links'] as List<dynamic>)
          .map((e) => HubLink.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextPageUrl: json['next_page_url'] as String?,
      path: json['path'] as String,
      perPage: (json['per_page'] as num).toInt(),
      prevPageUrl: json['prev_page_url'] as String?,
      to: (json['to'] as num?)?.toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$HubDataToJson(HubData instance) => <String, dynamic>{
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

HubDetail _$HubDetailFromJson(Map<String, dynamic> json) => HubDetail(
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
      country: Country.fromJson(json['country'] as Map<String, dynamic>),
      state: State.fromJson(json['state'] as Map<String, dynamic>),
      city: City.fromJson(json['city'] as Map<String, dynamic>),
      governorate:
          Governorate.fromJson(json['governorate'] as Map<String, dynamic>),
      place: Place.fromJson(json['place'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HubDetailToJson(HubDetail instance) => <String, dynamic>{
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
      'country': instance.country,
      'state': instance.state,
      'city': instance.city,
      'governorate': instance.governorate,
      'place': instance.place,
    };

Country _$CountryFromJson(Map<String, dynamic> json) => Country(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      code: json['code'] as String,
      phonecode: (json['phonecode'] as num).toInt(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$CountryToJson(Country instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'phonecode': instance.phonecode,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

State _$StateFromJson(Map<String, dynamic> json) => State(
      id: (json['id'] as num).toInt(),
      countryId: (json['country_id'] as num).toInt(),
      governorateId: (json['governorate_id'] as num).toInt(),
      enName: json['en_name'] as String,
      arName: json['ar_name'] as String,
      lat: json['lat'] as String,
      lng: json['lng'] as String,
      polygon: json['polygon'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      polygonGeojson: json['polygon_geojson'] == null
          ? null
          : PolygonGeojson.fromJson(
              json['polygon_geojson'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StateToJson(State instance) => <String, dynamic>{
      'id': instance.id,
      'country_id': instance.countryId,
      'governorate_id': instance.governorateId,
      'en_name': instance.enName,
      'ar_name': instance.arName,
      'lat': instance.lat,
      'lng': instance.lng,
      'polygon': instance.polygon,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'polygon_geojson': instance.polygonGeojson,
    };

City _$CityFromJson(Map<String, dynamic> json) => City(
      id: (json['id'] as num).toInt(),
      stateId: (json['state_id'] as num).toInt(),
      name: json['name'] as String,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$CityToJson(City instance) => <String, dynamic>{
      'id': instance.id,
      'state_id': instance.stateId,
      'name': instance.name,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

Governorate _$GovernorateFromJson(Map<String, dynamic> json) => Governorate(
      id: (json['id'] as num).toInt(),
      countryId: (json['country_id'] as num).toInt(),
      enName: json['en_name'] as String,
      arName: json['ar_name'] as String,
      lat: json['lat'] as String,
      lng: json['lng'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$GovernorateToJson(Governorate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'country_id': instance.countryId,
      'en_name': instance.enName,
      'ar_name': instance.arName,
      'lat': instance.lat,
      'lng': instance.lng,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

Place _$PlaceFromJson(Map<String, dynamic> json) => Place(
      id: (json['id'] as num).toInt(),
      stateId: (json['state_id'] as num).toInt(),
      arName: json['ar_name'] as String,
      enName: json['en_name'] as String,
      lat: json['lat'] as String?,
      lng: json['lng'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$PlaceToJson(Place instance) => <String, dynamic>{
      'id': instance.id,
      'state_id': instance.stateId,
      'ar_name': instance.arName,
      'en_name': instance.enName,
      'lat': instance.lat,
      'lng': instance.lng,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

PolygonGeojson _$PolygonGeojsonFromJson(Map<String, dynamic> json) =>
    PolygonGeojson(
      type: json['type'] as String,
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => (e as List<dynamic>)
              .map((e) => (e as List<dynamic>)
                  .map((e) => (e as List<dynamic>)
                      .map((e) => (e as num).toDouble())
                      .toList())
                  .toList())
              .toList())
          .toList(),
    );

Map<String, dynamic> _$PolygonGeojsonToJson(PolygonGeojson instance) =>
    <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
    };

HubLink _$HubLinkFromJson(Map<String, dynamic> json) => HubLink(
      url: json['url'] as String?,
      label: json['label'] as String,
      active: json['active'] as bool,
    );

Map<String, dynamic> _$HubLinkToJson(HubLink instance) => <String, dynamic>{
      'url': instance.url,
      'label': instance.label,
      'active': instance.active,
    };
