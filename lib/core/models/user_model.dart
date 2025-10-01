class UserModel {
  int? id;
  String? name;
  String? email;
  String? token;
  String? createdAt;
  String? updatedAt;
  String? location;
  Role? role;
  List<Settings>? settings;
  Driver? driver;
  Workspace? currentWorkspace;
  List<Workspace>? workspaces;
  Client? client;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.token,
    this.createdAt,
    this.updatedAt,
    this.location,
    this.role,
    this.settings,
    this.driver,
    this.currentWorkspace,
    this.workspaces,
    this.client,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    token = json['token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    location = json['location'];
    role = json['role'] != null ? Role.fromJson(json['role']) : null;
    if (json['settings'] != null) {
      settings = <Settings>[];
      json['settings'].forEach((v) {
        settings!.add(Settings.fromJson(v));
      });
    }
    driver = json['driver'] != null ? Driver.fromJson(json['driver']) : null;
    currentWorkspace =
        json['current_workspace'] != null
            ? Workspace.fromJson(json['current_workspace'])
            : null;
    if (json['workspaces'] != null) {
      workspaces = <Workspace>[];
      json['workspaces'].forEach((v) {
        workspaces!.add(Workspace.fromJson(v));
      });
    }
    client = json['client'] != null ? Client.fromJson(json['client']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['token'] = token;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['location'] = location;
    if (role != null) {
      data['role'] = role!.toJson();
    }
    if (settings != null) {
      data['settings'] = settings!.map((v) => v.toJson()).toList();
    }
    if (driver != null) {
      data['driver'] = driver!.toJson();
    }
    if (currentWorkspace != null) {
      data['current_workspace'] = currentWorkspace!.toJson();
    }
    if (workspaces != null) {
      data['workspaces'] = workspaces!.map((v) => v.toJson()).toList();
    }
    if (client != null) {
      data['client'] = client!.toJson();
    }
    return data;
  }
}

class Role {
  int? id;
  String? name;
  List<Permission>? permissions;
  String? createdAt;
  String? updatedAt;

  Role({this.id, this.name, this.permissions, this.createdAt, this.updatedAt});

  Role.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['permissions'] != null) {
      permissions = <Permission>[];
      json['permissions'].forEach((v) {
        permissions!.add(Permission.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (permissions != null) {
      data['permissions'] = permissions!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Permission {
  int? id;
  String? name;
  String? guardName;
  String? type;
  String? createdAt;
  String? updatedAt;
  int? parentId;
  Pivot? pivot;

  Permission({
    this.id,
    this.name,
    this.guardName,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.parentId,
    this.pivot,
  });

  Permission.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    guardName = json['guard_name'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    parentId = json['parent_id'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['guard_name'] = guardName;
    data['type'] = type;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['parent_id'] = parentId;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    return data;
  }
}

class Pivot {
  int? roleId;
  int? permissionId;

  Pivot({this.roleId, this.permissionId});

  Pivot.fromJson(Map<String, dynamic> json) {
    roleId = json['role_id'];
    permissionId = json['permission_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['role_id'] = roleId;
    data['permission_id'] = permissionId;
    return data;
  }
}

class Settings {
  int? id;
  String? key;
  String? value;
  String? description;
  String? type;
  String? status;
  String? createdAt;
  String? updatedAt;

  Settings({
    this.id,
    this.key,
    this.value,
    this.description,
    this.type,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Settings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    key = json['key'];
    value = json['value'];
    description = json['description'];
    type = json['type'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['key'] = key;
    data['value'] = value;
    data['description'] = description;
    data['type'] = type;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Driver {
  int? id;
  String? ownerType;
  int? ownerId;
  int? userId;
  int? companyId;
  int? status;
  String? phone;
  String? idCard;
  String? license;
  String? carOwnershipId;
  String? createdAt;
  String? updatedAt;
  Company? company;
  DriverSettings? settings;

  Driver({
    this.id,
    this.ownerType,
    this.ownerId,
    this.userId,
    this.companyId,
    this.status,
    this.phone,
    this.idCard,
    this.license,
    this.carOwnershipId,
    this.createdAt,
    this.updatedAt,
    this.company,
    this.settings,
  });

  Driver.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ownerType = json['owner_type'];
    ownerId = json['owner_id'];
    userId = json['user_id'];
    companyId = json['company_id'];
    status = json['status'];
    phone = json['phone'];
    idCard = json['id_card'];
    license = json['license'];
    carOwnershipId = json['car_ownership_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    company =
        json['company'] != null ? Company.fromJson(json['company']) : null;
    settings =
        json['settings'] != null
            ? DriverSettings.fromJson(json['settings'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['owner_type'] = ownerType;
    data['owner_id'] = ownerId;
    data['user_id'] = userId;
    data['company_id'] = companyId;
    data['status'] = status;
    data['phone'] = phone;
    data['id_card'] = idCard;
    data['license'] = license;
    data['car_ownership_id'] = carOwnershipId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (company != null) {
      data['company'] = company!.toJson();
    }
    if (settings != null) {
      data['settings'] = settings!.toJson();
    }
    return data;
  }
}

class Company {
  int? id;
  String? name;
  int? paymentProofRequired;
  String? createdAt;
  String? updatedAt;

  Company({
    this.id,
    this.name,
    this.paymentProofRequired,
    this.createdAt,
    this.updatedAt,
  });

  Company.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    paymentProofRequired = json['payment_proof_required'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['payment_proof_required'] = paymentProofRequired;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class DriverSettings {
  int? id;
  int? driverId;
  int? editProof;
  String? deliveryConfirmationMethod;
  String? createdAt;
  String? updatedAt;

  DriverSettings({
    this.id,
    this.driverId,
    this.editProof,
    this.deliveryConfirmationMethod,
    this.createdAt,
    this.updatedAt,
  });

  DriverSettings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    driverId = json['driver_id'];
    editProof = json['edit_proof'];
    deliveryConfirmationMethod = json['delivery_confirmation_method'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['driver_id'] = driverId;
    data['edit_proof'] = editProof;
    data['delivery_confirmation_method'] = deliveryConfirmationMethod;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Workspace {
  dynamic id; // Can be int or String (encrypted ID)
  String? name;
  String? type;
  String? description;
  String? createdAt;
  String? updatedAt;

  Workspace({
    this.id,
    this.name,
    this.type,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  Workspace.fromJson(Map<String, dynamic> json) {
    id = json['id']; // Can be int or String
    name = json['name'];
    type = json['type'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['type'] = type;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Client {
  int? id;
  int? countryId;
  int? governorateId;
  int? stateId;
  int? placeId;
  int? userId;
  String? address;
  String? countryCode;
  String? contactNo;
  double? lat;
  double? lng;
  String? currency;
  String? facilityToFacilityFees;
  String? ownerType;
  int? ownerId;
  String? createdAt;
  String? updatedAt;
  Governorate? governorate;
  State? state;
  Place? place;

  Client({
    this.id,
    this.countryId,
    this.governorateId,
    this.stateId,
    this.placeId,
    this.userId,
    this.address,
    this.countryCode,
    this.contactNo,
    this.lat,
    this.lng,
    this.currency,
    this.facilityToFacilityFees,
    this.ownerType,
    this.ownerId,
    this.createdAt,
    this.updatedAt,
    this.governorate,
    this.state,
    this.place,
  });

  Client.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryId = json['country_id'];
    governorateId = json['governorate_id'];
    stateId = json['state_id'];
    placeId = json['place_id'];
    userId = json['user_id'];
    address = json['address'];
    countryCode = json['country_code'];
    contactNo = json['contact_no'];
    lat = json['lat']?.toDouble();
    lng = json['lng']?.toDouble();
    currency = json['currency'];
    facilityToFacilityFees = json['facility_to_facility_fees'];
    ownerType = json['owner_type'];
    ownerId = json['owner_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    governorate =
        json['governorate'] != null
            ? Governorate.fromJson(json['governorate'])
            : null;
    state = json['state'] != null ? State.fromJson(json['state']) : null;
    place = json['place'] != null ? Place.fromJson(json['place']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['country_id'] = countryId;
    data['governorate_id'] = governorateId;
    data['state_id'] = stateId;
    data['place_id'] = placeId;
    data['user_id'] = userId;
    data['address'] = address;
    data['country_code'] = countryCode;
    data['contact_no'] = contactNo;
    data['lat'] = lat;
    data['lng'] = lng;
    data['currency'] = currency;
    data['facility_to_facility_fees'] = facilityToFacilityFees;
    data['owner_type'] = ownerType;
    data['owner_id'] = ownerId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (governorate != null) {
      data['governorate'] = governorate!.toJson();
    }
    if (state != null) {
      data['state'] = state!.toJson();
    }
    if (place != null) {
      data['place'] = place!.toJson();
    }
    return data;
  }
}

class Governorate {
  int? id;
  int? countryId;
  String? enName;
  String? arName;
  String? lat;
  String? lng;
  Map<String, dynamic>? polygon;
  String? createdAt;
  String? updatedAt;

  Governorate({
    this.id,
    this.countryId,
    this.enName,
    this.arName,
    this.lat,
    this.lng,
    this.polygon,
    this.createdAt,
    this.updatedAt,
  });

  Governorate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryId = json['country_id'];
    enName = json['en_name'];
    arName = json['ar_name'];
    lat = json['lat'];
    lng = json['lng'];
    polygon = json['polygon'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['country_id'] = countryId;
    data['en_name'] = enName;
    data['ar_name'] = arName;
    data['lat'] = lat;
    data['lng'] = lng;
    data['polygon'] = polygon;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class State {
  int? id;
  int? countryId;
  int? governorateId;
  String? enName;
  String? arName;
  String? lat;
  String? lng;
  dynamic polygon;
  Map<String, dynamic>? polygonGeojson;
  String? createdAt;
  String? updatedAt;

  State({
    this.id,
    this.countryId,
    this.governorateId,
    this.enName,
    this.arName,
    this.lat,
    this.lng,
    this.polygon,
    this.polygonGeojson,
    this.createdAt,
    this.updatedAt,
  });

  State.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryId = json['country_id'];
    governorateId = json['governorate_id'];
    enName = json['en_name'];
    arName = json['ar_name'];
    lat = json['lat'];
    lng = json['lng'];
    polygon = json['polygon'];
    polygonGeojson = json['polygon_geojson'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['country_id'] = countryId;
    data['governorate_id'] = governorateId;
    data['en_name'] = enName;
    data['ar_name'] = arName;
    data['lat'] = lat;
    data['lng'] = lng;
    data['polygon'] = polygon;
    data['polygon_geojson'] = polygonGeojson;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }

  // Helper getter for backwards compatibility
  String? get name => enName;
}

class Place {
  int? id;
  int? stateId;
  String? enName;
  String? arName;
  String? lat;
  String? lng;
  String? createdAt;
  String? updatedAt;

  Place({
    this.id,
    this.stateId,
    this.enName,
    this.arName,
    this.lat,
    this.lng,
    this.createdAt,
    this.updatedAt,
  });

  Place.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stateId = json['state_id'];
    enName = json['en_name'];
    arName = json['ar_name'];
    lat = json['lat'];
    lng = json['lng'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['state_id'] = stateId;
    data['en_name'] = enName;
    data['ar_name'] = arName;
    data['lat'] = lat;
    data['lng'] = lng;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
