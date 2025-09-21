import 'package:equatable/equatable.dart';

/// Enum for transaction types
enum TransactionType {
  all('All'),
  cod('COD'),
  fee('Fee'),
  settlement('Settlement');

  const TransactionType(this.value);
  final String value;

  static TransactionType fromString(String value) {
    return TransactionType.values.firstWhere(
      (type) => type.value.toLowerCase() == value.toLowerCase(),
      orElse: () => TransactionType.all,
    );
  }
}

/// Finance filter model for date range and transaction type filtering
class FinanceFilter extends Equatable {
  final DateTime? fromDate;
  final DateTime? toDate;
  final TransactionType transactionType;

  const FinanceFilter({
    this.fromDate,
    this.toDate,
    this.transactionType = TransactionType.all,
  });

  /// Create a copy of this filter with updated values
  FinanceFilter copyWith({
    DateTime? fromDate,
    DateTime? toDate,
    TransactionType? transactionType,
  }) {
    return FinanceFilter(
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      transactionType: transactionType ?? this.transactionType,
    );
  }

  /// Check if any filter is applied
  bool get hasActiveFilters {
    return fromDate != null ||
        toDate != null ||
        transactionType != TransactionType.all;
  }

  /// Get query parameters for API call
  Map<String, dynamic> get queryParameters {
    final params = <String, dynamic>{};

    if (fromDate != null) {
      params['from'] = _formatDate(fromDate!);
    }

    if (toDate != null) {
      params['to'] = _formatDate(toDate!);
    }

    if (transactionType != TransactionType.all) {
      params['type'] = transactionType.value;
    }

    return params;
  }

  /// Format date to DD-MM-YYYY format as shown in the API
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  /// Get display text for the filter
  String get displayText {
    final parts = <String>[];

    if (fromDate != null && toDate != null) {
      parts.add('${_formatDate(fromDate!)} - ${_formatDate(toDate!)}');
    } else if (fromDate != null) {
      parts.add('From ${_formatDate(fromDate!)}');
    } else if (toDate != null) {
      parts.add('To ${_formatDate(toDate!)}');
    }

    if (transactionType != TransactionType.all) {
      parts.add(transactionType.value);
    }

    return parts.isEmpty ? 'No filters' : parts.join(' • ');
  }

  @override
  List<Object?> get props => [fromDate, toDate, transactionType];
}
