import 'package:equatable/equatable.dart';

/// Settlement request model for requesting financial settlements
class SettlementRequest extends Equatable {
  final double amount;
  final String notes;

  const SettlementRequest({required this.amount, required this.notes});

  factory SettlementRequest.fromJson(Map<String, dynamic> json) {
    return SettlementRequest(
      amount: (json['amount'] ?? 0).toDouble(),
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'amount': amount, 'notes': notes};
  }

  @override
  List<Object?> get props => [amount, notes];
}

/// Settlement request response model
class SettlementRequestResponse extends Equatable {
  final String message;
  final List<dynamic> success;
  final List<dynamic> data;
  final List<dynamic> errors;

  const SettlementRequestResponse({
    required this.message,
    required this.success,
    required this.data,
    required this.errors,
  });

  factory SettlementRequestResponse.fromJson(Map<String, dynamic> json) {
    return SettlementRequestResponse(
      message: json['message'] ?? '',
      success: json['success'] ?? [],
      data: json['data'] ?? [],
      errors: json['errors'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'success': success,
      'data': data,
      'errors': errors,
    };
  }

  /// Check if the response indicates success
  bool get isSuccess => errors.isEmpty;

  @override
  List<Object?> get props => [message, success, data, errors];
}
