import 'package:client_app/core/utilities/error_message_sanitizer.dart';
import 'package:client_app/features/finance/data/models/finance_filter_model.dart';
import 'package:client_app/features/finance/data/models/finance_models.dart';
import 'package:client_app/features/finance/data/repositories/finance_repository.dart';
import 'package:client_app/features/finance/data/services/pdf_export_service.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'finance_state.dart';

/// Finance cubit for managing finance feature state
class FinanceCubit extends Cubit<FinanceState> {
  final FinanceRepository _financeRepository;

  FinanceCubit(this._financeRepository) : super(FinanceInitial());

  // Current data holders
  FinanceData? _financeData;
  int _currentPage = 1;
  int _perPage = 10;
  bool _isLoadingMore = false;
  bool _isExportingPdf = false;
  bool _isSubmittingSettlementRequest = false;
  FinanceFilter? _currentFilter;

  // Getters for current state
  FinanceData? get financeData => _financeData;
  int get currentPage => _currentPage;
  int get perPage => _perPage;
  bool get isLoadingMore => _isLoadingMore;
  bool get isExportingPdf => _isExportingPdf;
  bool get isSubmittingSettlementRequest => _isSubmittingSettlementRequest;
  bool get hasMorePages => _financeData?.hasMorePages ?? false;
  FinanceFilter? get currentFilter => _currentFilter;

  /// Load initial finance data
  Future<void> loadFinanceData({
    bool refresh = false,
    int perPage = 10,
    FinanceFilter? filter,
  }) async {
    if (refresh || state is FinanceInitial) {
      emit(FinanceLoading());
    }

    try {
      _perPage = perPage;
      _currentPage = 1;
      _currentFilter = filter;

      final response = await _financeRepository.getClientAccount(
        page: _currentPage,
        perPage: _perPage,
        filter: _currentFilter,
      );

      if (isClosed) return;

      if (response.isSuccess) {
        _financeData = response.data;
        emit(FinanceLoaded(data: response.data, isRefresh: refresh));
      } else {
        emit(
          FinanceError(
            message: ErrorMessageSanitizer.sanitize(response.message),
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          FinanceError(message: ErrorMessageSanitizer.sanitize(e.toString())),
        );
      }
    }
  }

  /// Load more finance data (pagination)
  Future<void> loadMoreFinanceData() async {
    if (_isLoadingMore || !hasMorePages || isClosed) return;

    try {
      _isLoadingMore = true;
      emit(FinanceLoadingMore(data: _financeData!));

      final nextPage = _currentPage + 1;
      final response = await _financeRepository.getClientAccount(
        page: nextPage,
        perPage: _perPage,
        filter: _currentFilter,
      );

      if (isClosed) return;

      if (response.isSuccess) {
        _currentPage = nextPage;

        // Append new transactions to existing data
        final updatedData = FinanceData(
          summary: response.data.summary,
          transactions: [
            ...(_financeData?.transactions ?? []),
            ...response.data.transactions,
          ],
          links: response.data.links,
          total: response.data.total,
          currentPage: response.data.currentPage,
          lastPage: response.data.lastPage,
        );

        _financeData = updatedData;
        emit(FinanceLoaded(data: updatedData, isRefresh: false));
      } else {
        emit(
          FinanceError(
            message: ErrorMessageSanitizer.sanitize(response.message),
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          FinanceError(message: ErrorMessageSanitizer.sanitize(e.toString())),
        );
      }
    } finally {
      _isLoadingMore = false;
    }
  }

  /// Refresh finance data
  Future<void> refreshFinanceData() async {
    await loadFinanceData(refresh: true, filter: _currentFilter);
  }

  /// Apply filter to finance data
  Future<void> applyFilter(FinanceFilter filter) async {
    await loadFinanceData(refresh: true, filter: filter);
  }

  /// Clear all filters
  Future<void> clearFilters() async {
    await loadFinanceData(refresh: true, filter: null);
  }

  /// Export finance data to PDF
  Future<String> exportToPdf(AppLocalizations localizations) async {
    if (_isExportingPdf || _financeData == null) {
      throw Exception('Cannot export: No data available or already exporting');
    }

    try {
      _isExportingPdf = true;
      emit(FinanceExportingPdf());

      final filePath = await PdfExportService.exportFinanceDataToPdf(
        financeData: _financeData!,
        localizations: localizations,
      );

      emit(FinancePdfExportSuccess(filePath: filePath));
      return filePath;
    } catch (e) {
      emit(
        FinancePdfExportError(
          message: ErrorMessageSanitizer.sanitize(e.toString()),
        ),
      );
      rethrow;
    } finally {
      _isExportingPdf = false;
    }
  }

  /// Submit settlement request
  Future<void> submitSettlementRequest({
    required double amount,
    required String notes,
  }) async {
    if (_isSubmittingSettlementRequest || isClosed) return;

    // Store the current state to return to after settlement request
    final currentState = state;

    try {
      _isSubmittingSettlementRequest = true;
      emit(FinanceSettlementRequestSubmitting());

      final response = await _financeRepository.submitSettlementRequest(
        amount: amount,
        notes: notes,
      );

      if (isClosed) return;

      if (response.isSuccess) {
        emit(FinanceSettlementRequestSuccess(message: response.message));

        // Return to the previous state after a brief delay to show success message
        await Future.delayed(const Duration(milliseconds: 1500));

        if (!isClosed) {
          // Return to the previous loaded state if it was FinanceLoaded
          if (currentState is FinanceLoaded) {
            emit(FinanceLoaded(data: currentState.data, isRefresh: false));
          } else {
            // Otherwise refresh the finance data
            await loadFinanceData(refresh: true, filter: _currentFilter);
          }
        }
      } else {
        emit(
          FinanceSettlementRequestError(
            message: ErrorMessageSanitizer.sanitize(response.message),
          ),
        );

        // Return to the previous state after error
        await Future.delayed(const Duration(milliseconds: 2000));

        if (!isClosed) {
          if (currentState is FinanceLoaded) {
            emit(FinanceLoaded(data: currentState.data, isRefresh: false));
          } else {
            await loadFinanceData(refresh: true, filter: _currentFilter);
          }
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          FinanceSettlementRequestError(
            message: ErrorMessageSanitizer.sanitize(e.toString()),
          ),
        );

        // Return to the previous state after error
        await Future.delayed(const Duration(milliseconds: 2000));

        if (!isClosed) {
          if (currentState is FinanceLoaded) {
            emit(FinanceLoaded(data: currentState.data, isRefresh: false));
          } else {
            await loadFinanceData(refresh: true, filter: _currentFilter);
          }
        }
      }
    } finally {
      _isSubmittingSettlementRequest = false;
    }
  }

  /// Reset finance state
  void reset() {
    if (!isClosed) {
      _financeData = null;
      _currentPage = 1;
      _isLoadingMore = false;
      _isExportingPdf = false;
      _isSubmittingSettlementRequest = false;
      _currentFilter = null;
      emit(FinanceInitial());
    }
  }
}
