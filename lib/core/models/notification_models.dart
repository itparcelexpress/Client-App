import 'package:equatable/equatable.dart';

// Notification Response Model
class NotificationResponse extends Equatable {
  final String message;
  final bool success;
  final NotificationPaginationData data;
  final List<dynamic> errors;

  const NotificationResponse({
    required this.message,
    required this.success,
    required this.data,
    required this.errors,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    try {
      print('Parsing NotificationResponse: $json'); // Debug log
      return NotificationResponse(
        message: json['message'] ?? '',
        success: json['success'] ?? false,
        data: NotificationPaginationData.fromJson(json['data'] ?? {}),
        errors: json['errors'] ?? [],
      );
    } catch (e) {
      print('Error parsing NotificationResponse: $e');
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

// Notification Pagination Data Model
class NotificationPaginationData extends Equatable {
  final int currentPage;
  final List<NotificationModel> notifications;
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

  const NotificationPaginationData({
    required this.currentPage,
    required this.notifications,
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

  factory NotificationPaginationData.fromJson(Map<String, dynamic> json) {
    try {
      print('Parsing NotificationPaginationData: $json'); // Debug log

      List<NotificationModel> notificationsList = [];
      if (json['data'] != null && json['data'] is List) {
        notificationsList =
            (json['data'] as List)
                .map(
                  (e) => NotificationModel.fromJson(e as Map<String, dynamic>),
                )
                .toList();
      }

      List<PaginationLink> linksList = [];
      if (json['links'] != null && json['links'] is List) {
        linksList =
            (json['links'] as List)
                .map((e) => PaginationLink.fromJson(e as Map<String, dynamic>))
                .toList();
      }

      return NotificationPaginationData(
        currentPage: json['current_page'] ?? 1,
        notifications: notificationsList,
        firstPageUrl: json['first_page_url'] ?? '',
        from: json['from'] ?? 0,
        lastPage: json['last_page'] ?? 1,
        lastPageUrl: json['last_page_url'] ?? '',
        links: linksList,
        nextPageUrl: json['next_page_url'],
        path: json['path'] ?? '',
        perPage: json['per_page'] ?? 0,
        prevPageUrl: json['prev_page_url'],
        to: json['to'] ?? 0,
        total: json['total'] ?? 0,
      );
    } catch (e) {
      print('Error parsing NotificationPaginationData: $e');
      print('JSON structure: ${json.runtimeType}');
      print('JSON keys: ${json.keys.toList()}');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': notifications.map((e) => e.toJson()).toList(),
      'first_page_url': firstPageUrl,
      'from': from,
      'last_page': lastPage,
      'last_page_url': lastPageUrl,
      'links': links.map((e) => e.toJson()).toList(),
      'next_page_url': nextPageUrl,
      'path': path,
      'per_page': perPage,
      'prev_page_url': prevPageUrl,
      'to': to,
      'total': total,
    };
  }

  @override
  List<Object?> get props => [
    currentPage,
    notifications,
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

// Individual Notification Model
class NotificationModel extends Equatable {
  final int id;
  final String notifiableType;
  final int notifiableId;
  final String title;
  final String content;
  final String type;
  final DateTime? readAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const NotificationModel({
    required this.id,
    required this.notifiableType,
    required this.notifiableId,
    required this.title,
    required this.content,
    required this.type,
    this.readAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    try {
      return NotificationModel(
        id: json['id'] ?? 0,
        notifiableType: json['notifiable_type'] ?? '',
        notifiableId: json['notifiable_id'] ?? 0,
        title: json['title'] ?? '',
        content: json['content'] ?? '',
        type: json['type'] ?? '',
        readAt:
            json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
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
      print('Error parsing NotificationModel: $e');
      print('JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'notifiable_type': notifiableType,
      'notifiable_id': notifiableId,
      'title': title,
      'content': content,
      'type': type,
      'read_at': readAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Helper method to check if notification is read
  bool get isRead => readAt != null;

  // Helper method to get notification type display name
  String get typeDisplayName {
    switch (type) {
      case 'statement_notification':
        return 'Statement';
      case 'pickup_notification':
        return 'Pickup';
      case 'promotional':
        return 'Promotion';
      case 'security_alert':
        return 'Security';
      case 'delivery_delay':
        return 'Delivery';
      case 'account_update':
        return 'Account';
      case 'system_announcement':
        return 'System';
      case 'payment_confirmation':
        return 'Payment';
      default:
        return 'General';
    }
  }

  // Copy method for updating notification
  NotificationModel copyWith({
    int? id,
    String? notifiableType,
    int? notifiableId,
    String? title,
    String? content,
    String? type,
    DateTime? readAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      notifiableType: notifiableType ?? this.notifiableType,
      notifiableId: notifiableId ?? this.notifiableId,
      title: title ?? this.title,
      content: content ?? this.content,
      type: type ?? this.type,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    notifiableType,
    notifiableId,
    title,
    content,
    type,
    readAt,
    createdAt,
    updatedAt,
  ];
}

// Pagination Link Model
class PaginationLink extends Equatable {
  final String? url;
  final String label;
  final bool active;

  const PaginationLink({this.url, required this.label, required this.active});

  factory PaginationLink.fromJson(Map<String, dynamic> json) {
    try {
      return PaginationLink(
        url: json['url'],
        label: json['label'] ?? '',
        active: json['active'] ?? false,
      );
    } catch (e) {
      print('Error parsing PaginationLink: $e');
      print('JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'label': label, 'active': active};
  }

  @override
  List<Object?> get props => [url, label, active];
}

// Mark Notification as Read Response Model
class MarkReadResponse extends Equatable {
  final String message;
  final bool success;
  final List<dynamic> errors;

  const MarkReadResponse({
    required this.message,
    required this.success,
    required this.errors,
  });

  factory MarkReadResponse.fromJson(Map<String, dynamic> json) {
    try {
      return MarkReadResponse(
        message: json['message'] ?? '',
        success: json['success'] ?? false,
        errors: json['errors'] ?? [],
      );
    } catch (e) {
      print('Error parsing MarkReadResponse: $e');
      print('JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'success': success, 'errors': errors};
  }

  @override
  List<Object?> get props => [message, success, errors];
}
