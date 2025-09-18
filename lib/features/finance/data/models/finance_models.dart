import 'package:equatable/equatable.dart';

/// Finance feature data models
///
/// This file contains all the data models for the finance feature
/// including account summary, transactions, and pagination data.

/// Account summary model containing financial overview
class AccountSummary extends Equatable {
  final double totalCod;
  final double totalFees;
  final double totalSettlements;
  final double currentBalance;

  const AccountSummary({
    required this.totalCod,
    required this.totalFees,
    required this.totalSettlements,
    required this.currentBalance,
  });

  factory AccountSummary.fromJson(Map<String, dynamic> json) {
    return AccountSummary(
      totalCod: (json['total_cod'] ?? 0).toDouble(),
      totalFees: (json['total_fees'] ?? 0).toDouble(),
      totalSettlements: (json['total_settlements'] ?? 0).toDouble(),
      currentBalance: (json['current_balance'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_cod': totalCod,
      'total_fees': totalFees,
      'total_settlements': totalSettlements,
      'current_balance': currentBalance,
    };
  }

  @override
  List<Object?> get props => [
    totalCod,
    totalFees,
    totalSettlements,
    currentBalance,
  ];
}

/// Transaction model representing individual financial transactions
class Transaction extends Equatable {
  final String date;
  final String reference;
  final String type;
  final String description;
  final double amount;

  const Transaction({
    required this.date,
    required this.reference,
    required this.type,
    required this.description,
    required this.amount,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      date: json['date'] ?? '',
      reference: json['reference'] ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'reference': reference,
      'type': type,
      'description': description,
      'amount': amount,
    };
  }

  /// Check if transaction is a credit (positive amount)
  bool get isCredit => amount > 0;

  /// Check if transaction is a debit (negative amount)
  bool get isDebit => amount < 0;

  /// Get formatted amount with currency symbol
  String get formattedAmount {
    final sign = isDebit ? '-' : '+';
    return '$sign${amount.abs().toStringAsFixed(2)}';
  }

  @override
  List<Object?> get props => [date, reference, type, description, amount];
}

/// Pagination link model for navigation
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

  Map<String, dynamic> toJson() {
    return {'url': url, 'label': label, 'active': active};
  }

  @override
  List<Object?> get props => [url, label, active];
}

/// Finance data response model containing all finance information
class FinanceData extends Equatable {
  final AccountSummary summary;
  final List<Transaction> transactions;
  final List<PaginationLink> links;
  final int total;
  final int currentPage;
  final int lastPage;

  const FinanceData({
    required this.summary,
    required this.transactions,
    required this.links,
    required this.total,
    required this.currentPage,
    required this.lastPage,
  });

  factory FinanceData.fromJson(Map<String, dynamic> json) {
    return FinanceData(
      summary: AccountSummary.fromJson(json['summary'] ?? {}),
      transactions:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) => Transaction.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      links:
          (json['links'] as List<dynamic>?)
              ?.map(
                (item) => PaginationLink.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      total: json['total'] ?? 0,
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summary.toJson(),
      'data': transactions.map((transaction) => transaction.toJson()).toList(),
      'links': links.map((link) => link.toJson()).toList(),
      'total': total,
      'current_page': currentPage,
      'last_page': lastPage,
    };
  }

  /// Check if there are more pages available
  bool get hasMorePages => currentPage < lastPage;

  /// Check if there are previous pages available
  bool get hasPreviousPages => currentPage > 1;

  @override
  List<Object?> get props => [
    summary,
    transactions,
    links,
    total,
    currentPage,
    lastPage,
  ];
}

/// Finance response model wrapping the API response
class FinanceResponse extends Equatable {
  final String message;
  final List<dynamic> success;
  final FinanceData data;
  final List<dynamic> errors;

  const FinanceResponse({
    required this.message,
    required this.success,
    required this.data,
    required this.errors,
  });

  factory FinanceResponse.fromJson(Map<String, dynamic> json) {
    return FinanceResponse(
      message: json['message'] ?? '',
      success: json['success'] ?? [],
      data: FinanceData.fromJson(json['data'] ?? {}),
      errors: json['errors'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'success': success,
      'data': data.toJson(),
      'errors': errors,
    };
  }

  /// Check if the response indicates success
  bool get isSuccess => errors.isEmpty;

  @override
  List<Object?> get props => [message, success, data, errors];
}
