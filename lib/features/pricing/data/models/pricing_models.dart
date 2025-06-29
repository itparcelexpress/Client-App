import 'package:json_annotation/json_annotation.dart';

part 'pricing_models.g.dart';

@JsonSerializable()
class PricingResponse {
  final String message;
  final bool success;
  final List<PricingData> data;
  final List<dynamic> errors;

  PricingResponse({
    required this.message,
    required this.success,
    required this.data,
    required this.errors,
  });

  factory PricingResponse.fromJson(Map<String, dynamic> json) =>
      _$PricingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PricingResponseToJson(this);
}

@JsonSerializable()
class PricingData {
  final int id;
  @JsonKey(name: 'client_id')
  final int clientId;
  @JsonKey(name: 'country_id')
  final int countryId;
  @JsonKey(name: 'state_id')
  final int stateId;
  @JsonKey(name: 'delivery_fee')
  final String deliveryFee;
  @JsonKey(name: 'return_fee')
  final String returnFee;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  // Additional fields for UI display (will be populated from location data)
  String? stateName;
  String? countryName;

  PricingData({
    required this.id,
    required this.clientId,
    required this.countryId,
    required this.stateId,
    required this.deliveryFee,
    required this.returnFee,
    required this.createdAt,
    required this.updatedAt,
    this.stateName,
    this.countryName,
  });

  factory PricingData.fromJson(Map<String, dynamic> json) =>
      _$PricingDataFromJson(json);

  Map<String, dynamic> toJson() => _$PricingDataToJson(this);

  // Helper methods to get fee values as double
  double get deliveryFeeValue => double.tryParse(deliveryFee) ?? 0.0;
  double get returnFeeValue => double.tryParse(returnFee) ?? 0.0;

  // Copy with method for updating additional fields
  PricingData copyWith({
    int? id,
    int? clientId,
    int? countryId,
    int? stateId,
    String? deliveryFee,
    String? returnFee,
    String? createdAt,
    String? updatedAt,
    String? stateName,
    String? countryName,
  }) {
    return PricingData(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      countryId: countryId ?? this.countryId,
      stateId: stateId ?? this.stateId,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      returnFee: returnFee ?? this.returnFee,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      stateName: stateName ?? this.stateName,
      countryName: countryName ?? this.countryName,
    );
  }
}
