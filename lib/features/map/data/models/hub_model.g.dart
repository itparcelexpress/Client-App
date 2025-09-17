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
      currentPage: (json['currentPage'] as num).toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => HubDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      firstPageUrl: json['firstPageUrl'] as String,
      from: (json['from'] as num).toInt(),
      lastPage: (json['lastPage'] as num).toInt(),
      lastPageUrl: json['lastPageUrl'] as String,
      links: (json['links'] as List<dynamic>)
          .map((e) => HubLink.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextPageUrl: json['nextPageUrl'] as String?,
      path: json['path'] as String,
      perPage: (json['perPage'] as num).toInt(),
      prevPageUrl: json['prevPageUrl'] as String?,
      to: (json['to'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$HubDataToJson(HubData instance) => <String, dynamic>{
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

HubDetail _$HubDetailFromJson(Map<String, dynamic> json) => HubDetail(
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
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$CountryToJson(Country instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'phonecode': instance.phonecode,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

State _$StateFromJson(Map<String, dynamic> json) => State(
      id: (json['id'] as num).toInt(),
      countryId: (json['countryId'] as num).toInt(),
      governorateId: (json['governorateId'] as num).toInt(),
      enName: json['enName'] as String,
      arName: json['arName'] as String,
      lat: json['lat'] as String,
      lng: json['lng'] as String,
      polygon: json['polygon'] as String?,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      polygonGeojson: json['polygonGeojson'] == null
          ? null
          : PolygonGeojson.fromJson(
              json['polygonGeojson'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StateToJson(State instance) => <String, dynamic>{
      'id': instance.id,
      'countryId': instance.countryId,
      'governorateId': instance.governorateId,
      'enName': instance.enName,
      'arName': instance.arName,
      'lat': instance.lat,
      'lng': instance.lng,
      'polygon': instance.polygon,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'polygonGeojson': instance.polygonGeojson,
    };

City _$CityFromJson(Map<String, dynamic> json) => City(
      id: (json['id'] as num).toInt(),
      stateId: (json['stateId'] as num).toInt(),
      name: json['name'] as String,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$CityToJson(City instance) => <String, dynamic>{
      'id': instance.id,
      'stateId': instance.stateId,
      'name': instance.name,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

Governorate _$GovernorateFromJson(Map<String, dynamic> json) => Governorate(
      id: (json['id'] as num).toInt(),
      countryId: (json['countryId'] as num).toInt(),
      enName: json['enName'] as String,
      arName: json['arName'] as String,
      lat: json['lat'] as String,
      lng: json['lng'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$GovernorateToJson(Governorate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'countryId': instance.countryId,
      'enName': instance.enName,
      'arName': instance.arName,
      'lat': instance.lat,
      'lng': instance.lng,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

Place _$PlaceFromJson(Map<String, dynamic> json) => Place(
      id: (json['id'] as num).toInt(),
      stateId: (json['stateId'] as num).toInt(),
      arName: json['arName'] as String,
      enName: json['enName'] as String,
      lat: json['lat'] as String?,
      lng: json['lng'] as String?,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$PlaceToJson(Place instance) => <String, dynamic>{
      'id': instance.id,
      'stateId': instance.stateId,
      'arName': instance.arName,
      'enName': instance.enName,
      'lat': instance.lat,
      'lng': instance.lng,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
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
