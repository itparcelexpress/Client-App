import 'package:equatable/equatable.dart';

// Client Settings Response Model
class ClientSettingsResponse extends Equatable {
  final String message;
  final bool success;
  final ClientSettingsData data;
  final List<dynamic> errors;

  const ClientSettingsResponse({
    required this.message,
    required this.success,
    required this.data,
    required this.errors,
  });

  factory ClientSettingsResponse.fromJson(Map<String, dynamic> json) {
    try {
      return ClientSettingsResponse(
        message: json['message'] ?? '',
        success: json['success'] ?? false,
        data: ClientSettingsData.fromJson(json['data'] ?? {}),
        errors: json['errors'] ?? [],
      );
    } catch (e) {
      print('Error parsing ClientSettingsResponse: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'success': success,
      'data': data.toJson(),
      'errors': errors,
    };
  }

  @override
  List<Object?> get props => [message, success, data, errors];
}

// Client Settings Data Model
class ClientSettingsData extends Equatable {
  final int id;
  final int clientId;
  final NotificationSettings? notifications;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ClientSettingsData({
    required this.id,
    required this.clientId,
    this.notifications,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ClientSettingsData.fromJson(Map<String, dynamic> json) {
    try {
      return ClientSettingsData(
        id: json['id'] ?? 0,
        clientId: json['client_id'] ?? 0,
        notifications:
            json['notifications'] != null
                ? NotificationSettings.fromJson(json['notifications'])
                : null,
        createdAt:
            json['created_at'] != null
                ? DateTime.parse(json['created_at'])
                : DateTime.now(),
        updatedAt:
            json['updated_at'] != null
                ? DateTime.parse(json['updated_at'])
                : DateTime.now(),
      );
    } catch (e) {
      print('Error parsing ClientSettingsData: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'notifications': notifications?.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ClientSettingsData copyWith({
    int? id,
    int? clientId,
    NotificationSettings? notifications,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ClientSettingsData(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      notifications: notifications ?? this.notifications,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    clientId,
    notifications,
    createdAt,
    updatedAt,
  ];
}

// Notification Settings Model
class NotificationSettings extends Equatable {
  final bool whatsapp;
  final bool email;

  const NotificationSettings({required this.whatsapp, required this.email});

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    try {
      return NotificationSettings(
        whatsapp: json['whatsapp'] ?? false,
        email: json['email'] ?? false,
      );
    } catch (e) {
      print('Error parsing NotificationSettings: $e');
      return const NotificationSettings(whatsapp: false, email: false);
    }
  }

  Map<String, dynamic> toJson() {
    return {'whatsapp': whatsapp, 'email': email};
  }

  NotificationSettings copyWith({bool? whatsapp, bool? email}) {
    return NotificationSettings(
      whatsapp: whatsapp ?? this.whatsapp,
      email: email ?? this.email,
    );
  }

  @override
  List<Object?> get props => [whatsapp, email];
}

// Update Settings Request Model
class UpdateSettingsRequest extends Equatable {
  final int clientId;
  final NotificationSettings notifications;

  const UpdateSettingsRequest({
    required this.clientId,
    required this.notifications,
  });

  Map<String, dynamic> toJson() {
    return {
      'client_id': clientId,
      'notifications': {
        'whatsapp': notifications.whatsapp,
        'email': notifications.email,
      },
    };
  }

  @override
  List<Object?> get props => [clientId, notifications];
}
