class GuestOrderRequest {
  final String name;
  final String email;
  final String cellphone;
  final String alternatePhone;
  final String? district;
  final String zipcode;
  final String streetAddress;
  final String? notes;
  final String payment_type;
  final double amount;
  final String customer_name;
  final String customer_phone;
  final int country_id;
  final int governorate_id;
  final int state_id;
  final int place_id;
  final int city_id;
  final String? identify;
  final String? taxNumber;
  final String? location_url;

  GuestOrderRequest({
    required this.name,
    required this.email,
    required this.cellphone,
    required this.alternatePhone,
    this.district,
    required this.zipcode,
    required this.streetAddress,
    this.notes,
    required this.payment_type,
    required this.amount,
    required this.customer_name,
    required this.customer_phone,
    required this.country_id,
    required this.governorate_id,
    required this.state_id,
    required this.place_id,
    required this.city_id,
    this.identify,
    this.taxNumber,
    this.location_url,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'cellphone': cellphone,
      'alternatePhone': alternatePhone,
      'district': district ?? '',
      'zipcode': zipcode,
      'streetAddress': streetAddress,
      'notes': notes ?? '',
      'payment_type': payment_type,
      'amount': amount,
      'customer_name': customer_name,
      'customer_phone': customer_phone,
      'country_id': country_id,
      'governorate_id': governorate_id,
      'state_id': state_id,
      'place_id': place_id,
      'city_id': city_id,
      'identify': identify ?? '',
      'taxNumber': taxNumber ?? '',
      'location_url': location_url ?? '',
    };
  }
}

class GuestOrderResponse {
  final String message;
  final bool success;
  final GuestOrderData? data;
  final List<String> errors;

  GuestOrderResponse({
    required this.message,
    required this.success,
    this.data,
    required this.errors,
  });

  factory GuestOrderResponse.fromJson(Map<String, dynamic> json) {
    // Extract success from either direct success field or status code
    final bool isSuccess = json['success'] == true;

    // Extract message, with fallback to empty string
    final String msg = json['message']?.toString() ?? '';

    return GuestOrderResponse(
      message: msg,
      success: isSuccess,
      data: json['data'] != null ? GuestOrderData.fromJson(json['data']) : null,
      errors:
          (json['errors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class GuestOrderData {
  final int id;
  final int? shipper_id;
  final int? consignee_id;
  final dynamic client_id;
  final String tracking_no;
  final dynamic created_by;
  final String? notes;
  final String payment_type;
  final dynamic value;
  final String delivery_fee;
  final num amount;
  final dynamic fee_payer;
  final String customer_name;
  final String customer_phone;
  final dynamic owner_id;
  final dynamic owner_type;
  final int is_walkin;
  final DateTime created_at;
  final DateTime updated_at;
  final ConsigneeData? consignee;
  final ShipperData? shipper;
  final List<dynamic> order_items;

  GuestOrderData({
    required this.id,
    this.shipper_id,
    this.consignee_id,
    this.client_id,
    required this.tracking_no,
    this.created_by,
    this.notes,
    required this.payment_type,
    this.value,
    required this.delivery_fee,
    required this.amount,
    this.fee_payer,
    required this.customer_name,
    required this.customer_phone,
    this.owner_id,
    this.owner_type,
    required this.is_walkin,
    required this.created_at,
    required this.updated_at,
    this.consignee,
    this.shipper,
    required this.order_items,
  });

  factory GuestOrderData.fromJson(Map<String, dynamic> json) {
    return GuestOrderData(
      id:
          json['id'] is String
              ? int.parse(json['id'])
              : (json['id'] as num).toInt(),
      shipper_id:
          json['shipper_id'] != null
              ? (json['shipper_id'] as num).toInt()
              : null,
      consignee_id:
          json['consignee_id'] != null
              ? (json['consignee_id'] as num).toInt()
              : null,
      client_id: json['client_id'],
      tracking_no: json['tracking_no']?.toString() ?? '',
      created_by: json['created_by'],
      notes: json['notes']?.toString(),
      payment_type: json['payment_type']?.toString() ?? '',
      value: json['value'],
      delivery_fee: json['delivery_fee']?.toString() ?? '',
      amount:
          json['amount'] is String
              ? num.parse(json['amount'])
              : json['amount'] as num,
      fee_payer: json['fee_payer'],
      customer_name: json['customer_name']?.toString() ?? '',
      customer_phone: json['customer_phone']?.toString() ?? '',
      owner_id: json['owner_id'],
      owner_type: json['owner_type'],
      is_walkin:
          json['is_walkin'] is String
              ? int.parse(json['is_walkin'])
              : (json['is_walkin'] as num).toInt(),
      created_at: DateTime.parse(json['created_at'] as String),
      updated_at: DateTime.parse(json['updated_at'] as String),
      consignee:
          json['consignee'] != null
              ? ConsigneeData.fromJson(json['consignee'])
              : null,
      shipper:
          json['shipper'] != null
              ? ShipperData.fromJson(json['shipper'])
              : null,
      order_items: json['order_items'] as List<dynamic>? ?? [],
    );
  }
}

class ConsigneeData {
  final int id;
  final int country_id;
  final int governorate_id;
  final int state_id;
  final int place_id;
  final dynamic city_id;
  final String name;
  final String email;
  final String cellphone;
  final String alternatePhone;
  final dynamic district;
  final String zipcode;
  final String streetAddress;
  final dynamic identify;
  final dynamic taxNumber;
  final String? longitude;
  final String? latitude;
  final dynamic location;
  final String? location_url;
  final dynamic address_update_url;
  final dynamic update_token;
  final int address_confirmed;
  final dynamic owner_type;
  final dynamic owner_id;
  final DateTime created_at;
  final DateTime updated_at;

  ConsigneeData({
    required this.id,
    required this.country_id,
    required this.governorate_id,
    required this.state_id,
    required this.place_id,
    this.city_id,
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
    this.location_url,
    this.address_update_url,
    this.update_token,
    required this.address_confirmed,
    this.owner_type,
    this.owner_id,
    required this.created_at,
    required this.updated_at,
  });

  factory ConsigneeData.fromJson(Map<String, dynamic> json) {
    return ConsigneeData(
      id:
          json['id'] is String
              ? int.parse(json['id'])
              : (json['id'] as num).toInt(),
      country_id:
          json['country_id'] is String
              ? int.parse(json['country_id'])
              : (json['country_id'] as num).toInt(),
      governorate_id:
          json['governorate_id'] is String
              ? int.parse(json['governorate_id'])
              : (json['governorate_id'] as num).toInt(),
      state_id:
          json['state_id'] is String
              ? int.parse(json['state_id'])
              : (json['state_id'] as num).toInt(),
      place_id:
          json['place_id'] is String
              ? int.parse(json['place_id'])
              : (json['place_id'] as num).toInt(),
      city_id: json['city_id'],
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      cellphone: json['cellphone']?.toString() ?? '',
      alternatePhone: json['alternatePhone']?.toString() ?? '',
      district: json['district'],
      zipcode: json['zipcode']?.toString() ?? '',
      streetAddress: json['streetAddress']?.toString() ?? '',
      identify: json['identify'],
      taxNumber: json['taxNumber'],
      longitude: json['longitude']?.toString(),
      latitude: json['latitude']?.toString(),
      location: json['location'],
      location_url: json['location_url']?.toString(),
      address_update_url: json['address_update_url'],
      update_token: json['update_token'],
      address_confirmed:
          json['address_confirmed'] is String
              ? int.parse(json['address_confirmed'])
              : (json['address_confirmed'] as num).toInt(),
      owner_type: json['owner_type'],
      owner_id: json['owner_id'],
      created_at: DateTime.parse(json['created_at'] as String),
      updated_at: DateTime.parse(json['updated_at'] as String),
    );
  }
}

class ShipperData {
  final int id;
  final String name;
  final String email;
  final String contact;
  final int country_id;
  final int state_id;
  final int governorate_id;
  final int place_id;
  final String address;
  final String zip_code;
  final String website;
  final String notes;
  final int is_active;
  final String owner_type;
  final int owner_id;
  final DateTime created_at;
  final DateTime updated_at;

  ShipperData({
    required this.id,
    required this.name,
    required this.email,
    required this.contact,
    required this.country_id,
    required this.state_id,
    required this.governorate_id,
    required this.place_id,
    required this.address,
    required this.zip_code,
    required this.website,
    required this.notes,
    required this.is_active,
    required this.owner_type,
    required this.owner_id,
    required this.created_at,
    required this.updated_at,
  });

  factory ShipperData.fromJson(Map<String, dynamic> json) {
    return ShipperData(
      id:
          json['id'] is String
              ? int.parse(json['id'])
              : (json['id'] as num).toInt(),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      contact: json['contact']?.toString() ?? '',
      country_id:
          json['country_id'] is String
              ? int.parse(json['country_id'])
              : (json['country_id'] as num).toInt(),
      state_id:
          json['state_id'] is String
              ? int.parse(json['state_id'])
              : (json['state_id'] as num).toInt(),
      governorate_id:
          json['governorate_id'] is String
              ? int.parse(json['governorate_id'])
              : (json['governorate_id'] as num).toInt(),
      place_id:
          json['place_id'] is String
              ? int.parse(json['place_id'])
              : (json['place_id'] as num).toInt(),
      address: json['address']?.toString() ?? '',
      zip_code: json['zip_code']?.toString() ?? '',
      website: json['website']?.toString() ?? '',
      notes: json['notes']?.toString() ?? '',
      is_active:
          json['is_active'] is String
              ? int.parse(json['is_active'])
              : (json['is_active'] as num).toInt(),
      owner_type: json['owner_type']?.toString() ?? '',
      owner_id:
          json['owner_id'] is String
              ? int.parse(json['owner_id'])
              : (json['owner_id'] as num).toInt(),
      created_at: DateTime.parse(json['created_at'] as String),
      updated_at: DateTime.parse(json['updated_at'] as String),
    );
  }
}
