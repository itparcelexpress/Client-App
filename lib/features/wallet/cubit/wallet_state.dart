import 'package:client_app/features/invoices/data/models/invoice_models.dart';

abstract class WalletState {}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletEmpty extends WalletState {}

class WalletLoaded extends WalletState {
  final String balance;
  final List<WalletTransaction> transactions;
  final int currentPage;
  final int totalPages;
  final int total;
  final bool hasMorePages;

  WalletLoaded({
    required this.balance,
    required this.transactions,
    required this.currentPage,
    required this.totalPages,
    required this.total,
    required this.hasMorePages,
  });
}

class WalletError extends WalletState {
  final String message;
  final List<dynamic>? errors;
  WalletError({required this.message, this.errors});
}
