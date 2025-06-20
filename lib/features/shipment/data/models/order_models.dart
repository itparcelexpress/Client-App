import 'package:equatable/equatable.dart';

// Order Request Model
class CreateOrderRequest extends Equatable {
  final String? stickerNumber;
  final String name;
  final String cellphone;
  final String alternatePhone;
  final String email;
  final String district;
  final int countryId;
  final int governorateId;
  final int stateId;
  final int placeId;
  final int cityId;
  final String zipcode;
  final String streetAddress;
  final String identify;
  final String taxNumber;
  final String longitude;
  final String latitude;
  final String shipperId;
  final String notes;
  final String paymentType;
  final double amount;
  final double deliveryFee;
  final int clientId;
  final String? trackingNo;
  final int? unitId;
  final List<String> itemNames;
  final List<String> categories;
  final List<int> quantities;

  const CreateOrderRequest({
    this.stickerNumber,
    required this.name,
    required this.cellphone,
    required this.alternatePhone,
    required this.email,
    this.district = "",
    required this.countryId,
    required this.governorateId,
    required this.stateId,
    required this.placeId,
    this.cityId = 1,
    required this.zipcode,
    required this.streetAddress,
    this.identify = "",
    this.taxNumber = "",
    this.longitude = "",
    this.latitude = "",
    this.shipperId = "",
    this.notes = "",
    required this.paymentType,
    required this.amount,
    required this.deliveryFee,
    required this.clientId,
    this.trackingNo,
    this.unitId,
    this.itemNames = const [],
    this.categories = const [],
    this.quantities = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'cellphone': cellphone,
      'alternatePhone': alternatePhone,
      'district': district,
      'country_id': countryId,
      'governorate_id': governorateId,
      'state_id': stateId,
      'place_id': placeId,
      'city_id': cityId,
      'zipcode': zipcode,
      'streetAddress': streetAddress,
      'identify': identify,
      'taxNumber': taxNumber,
      'longitude': longitude,
      'latitude': latitude,
      'shipper_id': shipperId,
      'notes': notes,
      'payment_type': paymentType,
      'amount': amount,
      'delivery_fee': deliveryFee,
      'client_id': clientId,
      if (trackingNo != null) 'tracking_no': trackingNo,
      if (unitId != null) 'unit_id': unitId,
      'item_name[]': itemNames,
      'category[]': categories,
      'quantity[]': quantities,
    };
  }

  @override
  List<Object?> get props => [
    stickerNumber,
    name,
    cellphone,
    alternatePhone,
    email,
    district,
    countryId,
    governorateId,
    stateId,
    placeId,
    cityId,
    zipcode,
    streetAddress,
    identify,
    taxNumber,
    longitude,
    latitude,
    shipperId,
    notes,
    paymentType,
    amount,
    deliveryFee,
    clientId,
    trackingNo,
    unitId,
    itemNames,
    categories,
    quantities,
  ];
}

// Order Response Models
class CreateOrderResponse extends Equatable {
  final String message;
  final bool success;
  final OrderData data;
  final List<dynamic> errors;

  const CreateOrderResponse({
    required this.message,
    required this.success,
    required this.data,
    required this.errors,
  });

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) {
    return CreateOrderResponse(
      message: json['message'] ?? '',
      success: json['success'] ?? false,
      data: OrderData.fromJson(json['data'] ?? {}),
      errors: json['errors'] ?? [],
    );
  }

  @override
  List<Object?> get props => [message, success, data, errors];
}

class OrderData extends Equatable {
  final String paymentType;
  final String deliveryFee;
  final String clientId;
  final String trackingNo;
  final int createdBy;
  final int consigneeId;
  final double amount;
  final String ownerId;
  final String ownerType;
  final String updatedAt;
  final String createdAt;
  final int id;
  final Consignee consignee;
  final List<dynamic> orderItems;

  const OrderData({
    required this.paymentType,
    required this.deliveryFee,
    required this.clientId,
    required this.trackingNo,
    required this.createdBy,
    required this.consigneeId,
    required this.amount,
    required this.ownerId,
    required this.ownerType,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    required this.consignee,
    required this.orderItems,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      paymentType: json['payment_type'] ?? '',
      deliveryFee: json['delivery_fee'] ?? '',
      clientId: json['client_id'] ?? '',
      trackingNo: json['tracking_no'] ?? '',
      createdBy: json['created_by'] ?? 0,
      consigneeId: json['consignee_id'] ?? 0,
      amount: (json['amount'] ?? 0).toDouble(),
      ownerId: json['owner_id'] ?? '',
      ownerType: json['owner_type'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      createdAt: json['created_at'] ?? '',
      id: json['id'] ?? 0,
      consignee: Consignee.fromJson(json['consignee'] ?? {}),
      orderItems: json['order_items'] ?? [],
    );
  }

  @override
  List<Object?> get props => [
    paymentType,
    deliveryFee,
    clientId,
    trackingNo,
    createdBy,
    consigneeId,
    amount,
    ownerId,
    ownerType,
    updatedAt,
    createdAt,
    id,
    consignee,
    orderItems,
  ];
}

class Consignee extends Equatable {
  final int id;
  final int countryId;
  final int governorateId;
  final int stateId;
  final int placeId;
  final int? cityId;
  final String name;
  final String email;
  final String cellphone;
  final String alternatePhone;
  final String? district;
  final String zipcode;
  final String streetAddress;
  final String? identify;
  final String? taxNumber;
  final String? longitude;
  final String? latitude;
  final String? location;
  final String? addressUpdateUrl;
  final String? updateToken;
  final int addressConfirmed;
  final String? ownerType;
  final String? ownerId;
  final String createdAt;
  final String updatedAt;

  const Consignee({
    required this.id,
    required this.countryId,
    required this.governorateId,
    required this.stateId,
    required this.placeId,
    this.cityId,
    required this.name,
    required this.email,
    required this.cellphone,
    required this.alternatePhone,
    this.district,
    required this.zipcode,
    required this.streetAddress,
    this.identify,
    this.taxNumber,
    this.longitude,
    this.latitude,
    this.location,
    this.addressUpdateUrl,
    this.updateToken,
    required this.addressConfirmed,
    this.ownerType,
    this.ownerId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Consignee.fromJson(Map<String, dynamic> json) {
    return Consignee(
      id: json['id'] ?? 0,
      countryId: json['country_id'] ?? 0,
      governorateId: json['governorate_id'] ?? 0,
      stateId: json['state_id'] ?? 0,
      placeId: json['place_id'] ?? 0,
      cityId: json['city_id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      cellphone: json['cellphone'] ?? '',
      alternatePhone: json['alternatePhone'] ?? '',
      district: json['district'],
      zipcode: json['zipcode'] ?? '',
      streetAddress: json['streetAddress'] ?? '',
      identify: json['identify'],
      taxNumber: json['taxNumber'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      location: json['location'],
      addressUpdateUrl: json['address_update_url'],
      updateToken: json['update_token'],
      addressConfirmed: json['address_confirmed'] ?? 0,
      ownerType: json['owner_type'],
      ownerId: json['owner_id'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
    id,
    countryId,
    governorateId,
    stateId,
    placeId,
    cityId,
    name,
    email,
    cellphone,
    alternatePhone,
    district,
    zipcode,
    streetAddress,
    identify,
    taxNumber,
    longitude,
    latitude,
    location,
    addressUpdateUrl,
    updateToken,
    addressConfirmed,
    ownerType,
    ownerId,
    createdAt,
    updatedAt,
  ];
}

// Order List Model for displaying orders
class OrderSummary extends Equatable {
  final int id;
  final String trackingNo;
  final String consigneeName;
  final String paymentType;
  final double amount;
  final String deliveryFee;
  final String status;
  final String createdAt;

  const OrderSummary({
    required this.id,
    required this.trackingNo,
    required this.consigneeName,
    required this.paymentType,
    required this.amount,
    required this.deliveryFee,
    required this.status,
    required this.createdAt,
  });

  factory OrderSummary.fromOrderData(OrderData orderData) {
    return OrderSummary(
      id: orderData.id,
      trackingNo: orderData.trackingNo,
      consigneeName: orderData.consignee.name,
      paymentType: orderData.paymentType,
      amount: orderData.amount,
      deliveryFee: orderData.deliveryFee,
      status: 'Created', // Default status for new orders
      createdAt: orderData.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    trackingNo,
    consigneeName,
    paymentType,
    amount,
    deliveryFee,
    status,
    createdAt,
  ];
}
