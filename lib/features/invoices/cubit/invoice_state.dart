import 'package:client_app/features/invoices/data/models/invoice_models.dart';
import 'package:equatable/equatable.dart';

abstract class InvoiceState extends Equatable {
  const InvoiceState();

  @override
  List<Object?> get props => [];
}

class InvoiceInitial extends InvoiceState {}

// Loading States
class InvoiceLoading extends InvoiceState {}

class InvoiceDetailLoading extends InvoiceState {}

class InvoicePdfDownloading extends InvoiceState {}

class InvoiceSearching extends InvoiceState {}

// Success States
class InvoiceLoaded extends InvoiceState {
  final List<Invoice> invoices;
  final InvoicesData? metadata;
  final bool hasReachedMax;

  const InvoiceLoaded({
    required this.invoices,
    this.metadata,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [invoices, metadata, hasReachedMax];

  InvoiceLoaded copyWith({
    List<Invoice>? invoices,
    InvoicesData? metadata,
    bool? hasReachedMax,
  }) {
    return InvoiceLoaded(
      invoices: invoices ?? this.invoices,
      metadata: metadata ?? this.metadata,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class InvoiceDetailLoaded extends InvoiceState {
  final Invoice invoice;

  const InvoiceDetailLoaded({required this.invoice});

  @override
  List<Object?> get props => [invoice];
}

class InvoicePdfDownloaded extends InvoiceState {
  final List<int> pdfBytes;
  final String invoiceNo;

  const InvoicePdfDownloaded({required this.pdfBytes, required this.invoiceNo});

  @override
  List<Object?> get props => [pdfBytes, invoiceNo];
}

class InvoiceSearchResults extends InvoiceState {
  final List<Invoice> invoices;
  final InvoicesData? metadata;
  final String searchQuery;
  final String? searchStatus;

  const InvoiceSearchResults({
    required this.invoices,
    this.metadata,
    required this.searchQuery,
    this.searchStatus,
  });

  @override
  List<Object?> get props => [invoices, metadata, searchQuery, searchStatus];
}

// Error States
class InvoiceError extends InvoiceState {
  final String message;

  const InvoiceError({required this.message});

  @override
  List<Object?> get props => [message];
}

class InvoiceDetailError extends InvoiceState {
  final String message;

  const InvoiceDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}

class InvoicePdfDownloadError extends InvoiceState {
  final String message;

  const InvoicePdfDownloadError({required this.message});

  @override
  List<Object?> get props => [message];
}

class InvoiceSearchError extends InvoiceState {
  final String message;

  const InvoiceSearchError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Empty States
class InvoiceEmpty extends InvoiceState {}

class InvoiceSearchEmpty extends InvoiceState {
  final String searchQuery;

  const InvoiceSearchEmpty({required this.searchQuery});

  @override
  List<Object?> get props => [searchQuery];
}

// Payment States
class PaymentLoading extends InvoiceState {}

class PaymentSummaryLoaded extends InvoiceState {
  final PaymentSummary summary;

  const PaymentSummaryLoaded({required this.summary});

  @override
  List<Object?> get props => [summary];
}

class PaymentTransactionsLoaded extends InvoiceState {
  final List<PaymentTransaction> transactions;

  const PaymentTransactionsLoaded({required this.transactions});

  @override
  List<Object?> get props => [transactions];
}

class PaymentCombinedLoaded extends InvoiceState {
  final PaymentSummary summary;
  final List<PaymentTransaction> transactions;

  const PaymentCombinedLoaded({
    required this.summary,
    required this.transactions,
  });

  @override
  List<Object?> get props => [summary, transactions];
}

class PaymentError extends InvoiceState {
  final String message;

  const PaymentError({required this.message});

  @override
  List<Object?> get props => [message];
}

class PaymentEmpty extends InvoiceState {}
