import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'location_models.g.dart';

// Country Model
@HiveType(typeId: 3)
class Country extends Equatable {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? updatedAt;

  const Country({required this.id, required this.name, this.updatedAt});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'updated_at': updatedAt};
  }

  @override
  List<Object?> get props => [id, name, updatedAt];
}

// Governorate Model
@HiveType(typeId: 0)
class Governorate extends Equatable {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String enName;

  @HiveField(2)
  final String arName;

  @HiveField(3)
  final int countryId;

  const Governorate({
    required this.id,
    required this.enName,
    required this.arName,
    required this.countryId,
  });

  factory Governorate.fromJson(Map<String, dynamic> json) {
    return Governorate(
      id: json['id'] ?? 0,
      enName: json['en_name'] ?? '',
      arName: json['ar_name'] ?? '',
      countryId: json['country_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'en_name': enName,
      'ar_name': arName,
      'country_id': countryId,
    };
  }

  @override
  List<Object?> get props => [id, enName, arName, countryId];
}

// State Model
@HiveType(typeId: 1)
class StateModel extends Equatable {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String enName;

  @HiveField(2)
  final String arName;

  @HiveField(3)
  final int governorateId;

  const StateModel({
    required this.id,
    required this.enName,
    required this.arName,
    required this.governorateId,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      id: json['id'] ?? 0,
      enName: json['en_name'] ?? '',
      arName: json['ar_name'] ?? '',
      governorateId: json['governorate_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'en_name': enName,
      'ar_name': arName,
      'governorate_id': governorateId,
    };
  }

  @override
  List<Object?> get props => [id, enName, arName, governorateId];
}

// Place Model
@HiveType(typeId: 2)
class Place extends Equatable {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String enName;

  @HiveField(2)
  final String arName;

  @HiveField(3)
  final int stateId;

  const Place({
    required this.id,
    required this.enName,
    required this.arName,
    required this.stateId,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] ?? 0,
      enName: json['en_name'] ?? '',
      arName: json['ar_name'] ?? '',
      stateId: json['state_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'en_name': enName,
      'ar_name': arName,
      'state_id': stateId,
    };
  }

  @override
  List<Object?> get props => [id, enName, arName, stateId];
}

// Response Models
class GovernorateResponse extends Equatable {
  final String message;
  final bool success;
  final List<Governorate> data;
  final List<dynamic> errors;

  const GovernorateResponse({
    required this.message,
    required this.success,
    required this.data,
    required this.errors,
  });

  factory GovernorateResponse.fromJson(Map<String, dynamic> json) {
    return GovernorateResponse(
      message: json['message'] ?? '',
      success: json['success'] ?? false,
      data:
          (json['data'] as List<dynamic>? ?? [])
              .map((item) => Governorate.fromJson(item as Map<String, dynamic>))
              .toList(),
      errors: json['errors'] ?? [],
    );
  }

  @override
  List<Object?> get props => [message, success, data, errors];
}

class StateResponse extends Equatable {
  final String message;
  final bool success;
  final List<StateModel> data;
  final List<dynamic> errors;

  const StateResponse({
    required this.message,
    required this.success,
    required this.data,
    required this.errors,
  });

  factory StateResponse.fromJson(Map<String, dynamic> json) {
    return StateResponse(
      message: json['message'] ?? '',
      success: json['success'] ?? false,
      data:
          (json['data'] as List<dynamic>? ?? [])
              .map((item) => StateModel.fromJson(item as Map<String, dynamic>))
              .toList(),
      errors: json['errors'] ?? [],
    );
  }

  @override
  List<Object?> get props => [message, success, data, errors];
}

class PlaceResponse extends Equatable {
  final String message;
  final bool success;
  final List<Place> data;
  final List<dynamic> errors;

  const PlaceResponse({
    required this.message,
    required this.success,
    required this.data,
    required this.errors,
  });

  factory PlaceResponse.fromJson(Map<String, dynamic> json) {
    return PlaceResponse(
      message: json['message'] ?? '',
      success: json['success'] ?? false,
      data:
          (json['data'] as List<dynamic>? ?? [])
              .map((item) => Place.fromJson(item as Map<String, dynamic>))
              .toList(),
      errors: json['errors'] ?? [],
    );
  }

  @override
  List<Object?> get props => [message, success, data, errors];
}

class CountryResponse extends Equatable {
  final String message;
  final bool success;
  final List<Country> data;
  final List<dynamic> errors;

  const CountryResponse({
    required this.message,
    required this.success,
    required this.data,
    required this.errors,
  });

  factory CountryResponse.fromJson(Map<String, dynamic> json) {
    return CountryResponse(
      message: json['message'] ?? '',
      success: json['success'] ?? false,
      data:
          (json['data'] as List<dynamic>? ?? [])
              .map((item) => Country.fromJson(item as Map<String, dynamic>))
              .toList(),
      errors: json['errors'] ?? [],
    );
  }

  @override
  List<Object?> get props => [message, success, data, errors];
}
