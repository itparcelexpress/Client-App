import 'package:client_app/core/utilities/logger.dart';
import 'package:client_app/features/invoices/cubit/invoice_state.dart';
import 'package:client_app/features/invoices/data/models/invoice_models.dart';
import 'package:client_app/features/invoices/data/repositories/invoice_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvoiceCubit extends Cubit<InvoiceState> {
  InvoiceCubit() : super(InvoiceInitial());

  // Current page for pagination
  int _currentPage = 1;
  List<Invoice> _allInvoices = [];
  bool _isLoadingMore = false;

  /// Load invoices with pagination support
  Future<void> loadInvoices({bool refresh = false}) async {
    if (_isLoadingMore) return;

    if (refresh) {
      _currentPage = 1;
      _allInvoices = [];
      if (!isClosed) emit(InvoiceLoading());
    } else if (_currentPage == 1) {
      if (!isClosed) emit(InvoiceLoading());
    }

    try {
      _isLoadingMore = true;

      final response = await InvoiceRepository.getInvoices(
        page: _currentPage,
        perPage: 10,
      );

      if (!isClosed) {
        if (response.data.isEmpty && _currentPage == 1) {
          emit(InvoiceEmpty());
          return;
        }

        if (refresh) {
          _allInvoices = response.data;
        } else {
          _allInvoices.addAll(response.data);
        }

        // For now, assume all data is loaded since API doesn't return pagination info
        final hasReachedMax = true;

        emit(
          InvoiceLoaded(
            invoices: List.from(_allInvoices),
            hasReachedMax: hasReachedMax,
          ),
        );
      }
    } catch (e) {
      Logger.error('Error loading invoices: $e');
      if (!isClosed) emit(InvoiceError(message: e.toString()));
    } finally {
      _isLoadingMore = false;
    }
  }

  /// Load more invoices for pagination
  Future<void> loadMoreInvoices() async {
    if (_isLoadingMore) return;

    final currentState = state;
    if (currentState is InvoiceLoaded && !currentState.hasReachedMax) {
      await loadInvoices();
    }
  }

  /// Load specific invoice details
  Future<void> loadInvoiceDetails(int invoiceId) async {
    if (!isClosed) emit(InvoiceDetailLoading());

    try {
      final response = await InvoiceRepository.getInvoiceDetails(invoiceId);
      if (!isClosed) emit(InvoiceDetailLoaded(invoice: response.data));
    } catch (e) {
      Logger.error('Error loading invoice details: $e');
      if (!isClosed) emit(InvoiceDetailError(message: e.toString()));
    }
  }

  /// Download invoice PDF
  Future<void> downloadInvoicePdf(int invoiceId, String invoiceNo) async {
    if (!isClosed) emit(InvoicePdfDownloading());

    try {
      final pdfBytes = await InvoiceRepository.downloadInvoicePdf(invoiceId);
      if (!isClosed) {
        emit(InvoicePdfDownloaded(pdfBytes: pdfBytes, invoiceNo: invoiceNo));
      }
    } catch (e) {
      Logger.error('Error downloading invoice PDF: $e');
      if (!isClosed) emit(InvoicePdfDownloadError(message: e.toString()));
    }
  }

  /// Search invoices by invoice number or status
  Future<void> searchInvoices({
    String? invoiceNo,
    String? status,
    int page = 1,
  }) async {
    if (!isClosed) emit(InvoiceSearching());

    try {
      final response = await InvoiceRepository.searchInvoices(
        invoiceNo: invoiceNo,
        status: status,
        page: page,
        perPage: 10,
      );

      if (!isClosed) {
        if (response.data.isEmpty) {
          emit(InvoiceSearchEmpty(searchQuery: invoiceNo ?? status ?? ''));
          return;
        }

        emit(
          InvoiceSearchResults(
            invoices: response.data,
            searchQuery: invoiceNo ?? '',
            searchStatus: status,
          ),
        );
      }
    } catch (e) {
      Logger.error('Error searching invoices: $e');
      if (!isClosed) emit(InvoiceSearchError(message: e.toString()));
    }
  }

  /// Clear search and return to all invoices
  Future<void> clearSearch() async {
    _currentPage = 1;
    _allInvoices = [];
    await loadInvoices(refresh: true);
  }

  /// Refresh invoices
  Future<void> refreshInvoices() async {
    await loadInvoices(refresh: true);
  }

  /// Filter invoices by status from current loaded invoices
  void filterInvoicesByStatus(String? status) {
    if (isClosed) return;

    final currentState = state;
    if (currentState is InvoiceLoaded) {
      if (status == null || status.isEmpty) {
        // Show all invoices
        emit(currentState);
        return;
      }

      final filteredInvoices =
          _allInvoices
              .where(
                (invoice) =>
                    invoice.status.toLowerCase() == status.toLowerCase(),
              )
              .toList();

      if (filteredInvoices.isEmpty) {
        emit(InvoiceSearchEmpty(searchQuery: status));
        return;
      }

      emit(
        InvoiceSearchResults(
          invoices: filteredInvoices,
          searchQuery: '',
          searchStatus: status,
        ),
      );
    }
  }

  /// Get invoice statistics from current loaded invoices
  Map<String, int> getInvoiceStatistics() {
    final stats = <String, int>{};
    stats['total'] = _allInvoices.length;
    stats['paid'] =
        _allInvoices.where((i) => i.status.toLowerCase() == 'paid').length;
    stats['pending'] =
        _allInvoices.where((i) => i.status.toLowerCase() == 'pending').length;
    stats['overdue'] =
        _allInvoices.where((i) => i.status.toLowerCase() == 'overdue').length;
    return stats;
  }

  /// Get total amount from current loaded invoices
  double getTotalAmount() {
    return _allInvoices.fold(
      0.0,
      (sum, invoice) => sum + double.parse(invoice.amount),
    );
  }

  /// Get paid amount from current loaded invoices
  double getPaidAmount() {
    return _allInvoices
        .where((invoice) => invoice.status.toLowerCase() == 'paid')
        .fold(0.0, (sum, invoice) => sum + double.parse(invoice.amount));
  }

  /// Get pending amount from current loaded invoices
  double getPendingAmount() {
    return _allInvoices
        .where((invoice) => invoice.status.toLowerCase() != 'paid')
        .fold(0.0, (sum, invoice) => sum + double.parse(invoice.amount));
  }

  // Payment Methods

  /// Load payment summary only
  Future<void> loadPaymentSummary() async {
    if (!isClosed) emit(PaymentLoading());

    try {
      final response = await InvoiceRepository.getPaymentSummary();
      if (!isClosed) emit(PaymentSummaryLoaded(summary: response.data));
    } catch (e) {
      Logger.error('Error loading payment summary: $e');
      if (!isClosed) emit(PaymentError(message: e.toString()));
    }
  }

  /// Load payment transactions only
  Future<void> loadPaymentTransactions() async {
    if (!isClosed) emit(PaymentLoading());

    try {
      final response = await InvoiceRepository.getPaymentTransactions();

      if (!isClosed) {
        if (response.data.isEmpty) {
          emit(PaymentEmpty());
          return;
        }

        emit(PaymentTransactionsLoaded(transactions: response.data));
      }
    } catch (e) {
      Logger.error('Error loading payment transactions: $e');
      if (!isClosed) emit(PaymentError(message: e.toString()));
    }
  }

  /// Load both payment summary and transactions
  Future<void> loadPaymentData() async {
    if (!isClosed) emit(PaymentLoading());

    try {
      final summaryFuture = InvoiceRepository.getPaymentSummary();
      final transactionsFuture = InvoiceRepository.getPaymentTransactions();

      final results = await Future.wait([summaryFuture, transactionsFuture]);

      if (!isClosed) {
        final summaryResponse = results[0] as PaymentSummaryResponse;
        final transactionsResponse = results[1] as PaymentTransactionsResponse;

        emit(
          PaymentCombinedLoaded(
            summary: summaryResponse.data,
            transactions: transactionsResponse.data,
          ),
        );
      }
    } catch (e) {
      Logger.error('Error loading payment data: $e');
      if (!isClosed) emit(PaymentError(message: e.toString()));
    }
  }

  /// Refresh payment data
  Future<void> refreshPaymentData() async {
    await loadPaymentData();
  }

  /// Filter transactions by type
  void filterTransactionsByType(String? type) {
    if (isClosed) return;

    final currentState = state;
    if (currentState is PaymentCombinedLoaded) {
      if (type == null || type.isEmpty) {
        // Show all transactions
        emit(currentState);
        return;
      }

      final filteredTransactions =
          currentState.transactions
              .where(
                (transaction) =>
                    transaction.type.toLowerCase() == type.toLowerCase(),
              )
              .toList();

      if (filteredTransactions.isEmpty) {
        emit(PaymentEmpty());
        return;
      }

      emit(
        PaymentCombinedLoaded(
          summary: currentState.summary,
          transactions: filteredTransactions,
        ),
      );
    }
  }

  /// Filter transactions by status
  void filterTransactionsByStatus(String? status) {
    if (isClosed) return;

    final currentState = state;
    if (currentState is PaymentCombinedLoaded) {
      if (status == null || status.isEmpty) {
        // Show all transactions
        emit(currentState);
        return;
      }

      final filteredTransactions =
          currentState.transactions
              .where(
                (transaction) =>
                    transaction.status.toLowerCase() == status.toLowerCase(),
              )
              .toList();

      if (filteredTransactions.isEmpty) {
        emit(PaymentEmpty());
        return;
      }

      emit(
        PaymentCombinedLoaded(
          summary: currentState.summary,
          transactions: filteredTransactions,
        ),
      );
    }
  }
}
