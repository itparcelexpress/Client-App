// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pricing_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PricingResponse _$PricingResponseFromJson(Map<String, dynamic> json) =>
    PricingResponse(
      message: json['message'] as String,
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => PricingData.fromJson(e as Map<String, dynamic>))
          .toList(),
      errors: json['errors'] as List<dynamic>,
    );

Map<String, dynamic> _$PricingResponseToJson(PricingResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      'data': instance.data,
      'errors': instance.errors,
    };

PricingData _$PricingDataFromJson(Map<String, dynamic> json) => PricingData(
      id: (json['id'] as num).toInt(),
      clientId: (json['client_id'] as num).toInt(),
      countryId: (json['country_id'] as num).toInt(),
      stateId: (json['state_id'] as num).toInt(),
      deliveryFee: json['delivery_fee'] as String,
      returnFee: json['return_fee'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      stateName: json['stateName'] as String?,
      countryName: json['countryName'] as String?,
    );

Map<String, dynamic> _$PricingDataToJson(PricingData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'client_id': instance.clientId,
      'country_id': instance.countryId,
      'state_id': instance.stateId,
      'delivery_fee': instance.deliveryFee,
      'return_fee': instance.returnFee,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'stateName': instance.stateName,
      'countryName': instance.countryName,
    };
