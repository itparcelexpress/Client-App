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
  final String? locationUrl;
  // Optional dimensions and unit
  final String? feePayer;
  final double? width;
  final double? height;
  final double? length;
  final double? weight;
  final int? unitId;
  // Optional order items arrays
  final List<String>? itemNames;
  final List<String>? categories;
  final List<int>? quantities;

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
    this.locationUrl,
    this.feePayer,
    this.width,
    this.height,
    this.length,
    this.weight,
    this.unitId,
    this.itemNames,
    this.categories,
    this.quantities,
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
      if (locationUrl != null) 'location_url': locationUrl,
      if (stickerNumber != null && stickerNumber!.isNotEmpty)
        'tracking_no': stickerNumber,
      if (feePayer != null && feePayer!.isNotEmpty) 'fee_payer': feePayer,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (length != null) 'length': length,
      if (weight != null) 'weight': weight,
      if (unitId != null) 'unit_id': unitId,
      if (itemNames != null && itemNames!.isNotEmpty) 'item_name[]': itemNames,
      if (categories != null && categories!.isNotEmpty)
        'category[]': categories,
      if (quantities != null && quantities!.isNotEmpty)
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
    locationUrl,
    feePayer,
    width,
    height,
    length,
    weight,
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
  final String? shipperId;
  final String? notes;
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
    this.shipperId,
    this.notes,
    required this.consignee,
    required this.orderItems,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      paymentType: json['payment_type'] ?? '',
      deliveryFee: json['delivery_fee']?.toString() ?? '',
      clientId: json['client_id']?.toString() ?? '',
      trackingNo: json['tracking_no'] ?? '',
      createdBy: json['created_by'] ?? 0,
      consigneeId: json['consignee_id'] ?? 0,
      amount: (json['amount'] ?? 0).toDouble(),
      ownerId: json['owner_id']?.toString() ?? '',
      ownerType: json['owner_type'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      createdAt: json['created_at'] ?? '',
      id: json['id'] ?? 0,
      shipperId: json['shipper_id']?.toString(),
      notes: json['notes'],
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
    shipperId,
    notes,
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
  final String? locationUrl; // Added location_url field
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
    this.locationUrl, // Added location_url field
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
      longitude: json['longitude']?.toString(),
      latitude: json['latitude']?.toString(),
      location: json['location'],
      locationUrl: json['location_url'], // Added location_url parsing
      addressUpdateUrl: json['address_update_url'],
      updateToken: json['update_token'],
      addressConfirmed: json['address_confirmed'] ?? 0,
      ownerType: json['owner_type'],
      ownerId: json['owner_id']?.toString(),
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
    locationUrl, // Added location_url to props
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

// Get Orders API Response Models
class GetOrdersResponse extends Equatable {
  final String message;
  final bool success;
  final OrdersData data;
  final List<dynamic> errors;

  const GetOrdersResponse({
    required this.message,
    required this.success,
    required this.data,
    required this.errors,
  });

  factory GetOrdersResponse.fromJson(Map<String, dynamic> json) {
    return GetOrdersResponse(
      message: json['message'] ?? '',
      success: json['success'] ?? false,
      data: OrdersData.fromJson(json['data'] ?? {}),
      errors: json['errors'] ?? [],
    );
  }

  @override
  List<Object?> get props => [message, success, data, errors];
}

class OrdersData extends Equatable {
  final int currentPage;
  final List<PickupOrder> data;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<PaginationLink> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  const OrdersData({
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

  factory OrdersData.fromJson(Map<String, dynamic> json) {
    return OrdersData(
      currentPage: json['current_page'] ?? 1,
      data:
          (json['data'] as List?)
              ?.map((item) => PickupOrder.fromJson(item))
              .toList() ??
          [],
      firstPageUrl: json['first_page_url'] ?? '',
      from: json['from'] ?? 0,
      lastPage: json['last_page'] ?? 1,
      lastPageUrl: json['last_page_url'] ?? '',
      links:
          (json['links'] as List?)
              ?.map((item) => PaginationLink.fromJson(item))
              .toList() ??
          [],
      nextPageUrl: json['next_page_url'],
      path: json['path'] ?? '',
      perPage: json['per_page'] ?? 10,
      prevPageUrl: json['prev_page_url'],
      to: json['to'] ?? 0,
      total: json['total'] ?? 0,
    );
  }

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

class PickupOrder extends Equatable {
  final int id;
  final int pickupTaskId;
  final int? driverId;
  final int clientId;
  final String orderTrackingNo;
  final String status;
  final String createdAt;
  final String updatedAt;
  final DetailedOrder order;
  final PickupTask pickupTask;
  final dynamic driver; // Can be null

  const PickupOrder({
    required this.id,
    required this.pickupTaskId,
    this.driverId,
    required this.clientId,
    required this.orderTrackingNo,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.order,
    required this.pickupTask,
    this.driver,
  });

  factory PickupOrder.fromJson(Map<String, dynamic> json) {
    return PickupOrder(
      id: json['id'] ?? 0,
      pickupTaskId: json['pickup_task_id'] ?? 0,
      driverId: json['driver_id'],
      clientId: json['client_id'] ?? 0,
      orderTrackingNo: json['order_tracking_no'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      order: DetailedOrder.fromJson(json['order'] ?? {}),
      pickupTask: PickupTask.fromJson(json['pickup_task'] ?? {}),
      driver: json['driver'],
    );
  }

  @override
  List<Object?> get props => [
    id,
    pickupTaskId,
    driverId,
    clientId,
    orderTrackingNo,
    status,
    createdAt,
    updatedAt,
    order,
    pickupTask,
    driver,
  ];
}

class DetailedOrder extends Equatable {
  final int id;
  final String ownerType;
  final int ownerId;
  final int consigneeId;
  final int shipperId;
  final int clientId;
  final int? driverId;
  final int? assignmentId;
  final String trackingNo;
  final int? fromHubId;
  final int? currentHubId;
  final int? targetHubId;
  final int? finalHubId;
  final String? value;
  final String amount;
  final String deliveryFee;
  final String paymentType;
  final String? pickupAddress;
  final int isReturn;
  final int createdBy;
  final String notes;
  final String status;
  final int inException;
  final int isWalkin;
  final String? customerName;
  final String? customerPhone;
  final String? customerIdCard;
  final String? feePayer;
  final String createdAt;
  final String updatedAt;
  final DetailedConsignee consignee;
  final List<dynamic> orderItems;

  const DetailedOrder({
    required this.id,
    required this.ownerType,
    required this.ownerId,
    required this.consigneeId,
    required this.shipperId,
    required this.clientId,
    this.driverId,
    this.assignmentId,
    required this.trackingNo,
    this.fromHubId,
    this.currentHubId,
    this.targetHubId,
    this.finalHubId,
    this.value,
    required this.amount,
    required this.deliveryFee,
    required this.paymentType,
    this.pickupAddress,
    required this.isReturn,
    required this.createdBy,
    required this.notes,
    required this.status,
    required this.inException,
    required this.isWalkin,
    this.customerName,
    this.customerPhone,
    this.customerIdCard,
    this.feePayer,
    required this.createdAt,
    required this.updatedAt,
    required this.consignee,
    required this.orderItems,
  });

  factory DetailedOrder.fromJson(Map<String, dynamic> json) {
    return DetailedOrder(
      id: json['id'] ?? 0,
      ownerType: json['owner_type'] ?? '',
      ownerId: json['owner_id'] ?? 0,
      consigneeId: json['consignee_id'] ?? 0,
      shipperId: json['shipper_id'] ?? 0,
      clientId: json['client_id'] ?? 0,
      driverId: json['driver_id'],
      assignmentId: json['assignment_id'],
      trackingNo: json['tracking_no'] ?? '',
      fromHubId: json['from_hub_id'],
      currentHubId: json['current_hub_id'],
      targetHubId: json['target_hub_id'],
      finalHubId: json['final_hub_id'],
      value: json['value'],
      amount: json['amount']?.toString() ?? '0',
      deliveryFee: json['delivery_fee']?.toString() ?? '0',
      paymentType: json['payment_type'] ?? '',
      pickupAddress: json['pickup_address'],
      isReturn: json['is_return'] ?? 0,
      createdBy: json['created_by'] ?? 0,
      notes: json['notes'] ?? '',
      status: json['status'] ?? '',
      inException: json['in_exception'] ?? 0,
      isWalkin: json['is_walkin'] ?? 0,
      customerName: json['customer_name'],
      customerPhone: json['customer_phone'],
      customerIdCard: json['customer_id_card'],
      feePayer: json['fee_payer'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      consignee: DetailedConsignee.fromJson(json['consignee'] ?? {}),
      orderItems: json['order_items'] ?? [],
    );
  }

  @override
  List<Object?> get props => [
    id,
    ownerType,
    ownerId,
    consigneeId,
    shipperId,
    clientId,
    driverId,
    assignmentId,
    trackingNo,
    fromHubId,
    currentHubId,
    targetHubId,
    finalHubId,
    value,
    amount,
    deliveryFee,
    paymentType,
    pickupAddress,
    isReturn,
    createdBy,
    notes,
    status,
    inException,
    isWalkin,
    customerName,
    customerPhone,
    customerIdCard,
    feePayer,
    createdAt,
    updatedAt,
    consignee,
    orderItems,
  ];
}

class DetailedConsignee extends Equatable {
  final int id;
  final String name;
  final String cellphone;
  final String streetAddress;

  const DetailedConsignee({
    required this.id,
    required this.name,
    required this.cellphone,
    required this.streetAddress,
  });

  factory DetailedConsignee.fromJson(Map<String, dynamic> json) {
    return DetailedConsignee(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      cellphone: json['cellphone'] ?? '',
      streetAddress: json['streetAddress'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name, cellphone, streetAddress];
}

class PickupTask extends Equatable {
  final int id;
  final int clientId;
  final String status;
  final String createdAt;

  const PickupTask({
    required this.id,
    required this.clientId,
    required this.status,
    required this.createdAt,
  });

  factory PickupTask.fromJson(Map<String, dynamic> json) {
    return PickupTask(
      id: json['id'] ?? 0,
      clientId: json['client_id'] ?? 0,
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, clientId, status, createdAt];
}

class PaginationLink extends Equatable {
  final String? url;
  final String label;
  final bool active;

  const PaginationLink({this.url, required this.label, required this.active});

  factory PaginationLink.fromJson(Map<String, dynamic> json) {
    return PaginationLink(
      url: json['url'],
      label: json['label'] ?? '',
      active: json['active'] ?? false,
    );
  }

  @override
  List<Object?> get props => [url, label, active];
}

// Extended OrderSummary to work with PickupOrder
class PickupOrderSummary extends Equatable {
  final int id;
  final String orderTrackingNo;
  final String consigneeName;
  final String consigneePhone;
  final String consigneeAddress;
  final String paymentType;
  final String amount;
  final String deliveryFee;
  final String status;
  final String orderStatus;
  final String createdAt;
  final String notes;

  const PickupOrderSummary({
    required this.id,
    required this.orderTrackingNo,
    required this.consigneeName,
    required this.consigneePhone,
    required this.consigneeAddress,
    required this.paymentType,
    required this.amount,
    required this.deliveryFee,
    required this.status,
    required this.orderStatus,
    required this.createdAt,
    required this.notes,
  });

  factory PickupOrderSummary.fromPickupOrder(PickupOrder pickupOrder) {
    return PickupOrderSummary(
      id: pickupOrder.id,
      orderTrackingNo: pickupOrder.orderTrackingNo,
      consigneeName: pickupOrder.order.consignee.name,
      consigneePhone: pickupOrder.order.consignee.cellphone,
      consigneeAddress: pickupOrder.order.consignee.streetAddress,
      paymentType: pickupOrder.order.paymentType,
      amount: pickupOrder.order.amount,
      deliveryFee: pickupOrder.order.deliveryFee,
      status: pickupOrder.status,
      orderStatus: pickupOrder.order.status,
      createdAt: pickupOrder.createdAt,
      notes: pickupOrder.order.notes,
    );
  }

  @override
  List<Object?> get props => [
    id,
    orderTrackingNo,
    consigneeName,
    consigneePhone,
    consigneeAddress,
    paymentType,
    amount,
    deliveryFee,
    status,
    orderStatus,
    createdAt,
    notes,
  ];
}
