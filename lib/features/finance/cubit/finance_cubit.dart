import 'package:client_app/features/finance/data/models/finance_models.dart';
import 'package:client_app/features/finance/data/repositories/finance_repository.dart';
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

  // Getters for current state
  FinanceData? get financeData => _financeData;
  int get currentPage => _currentPage;
  int get perPage => _perPage;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMorePages => _financeData?.hasMorePages ?? false;

  /// Load initial finance data
  Future<void> loadFinanceData({bool refresh = false, int perPage = 10}) async {
    if (refresh || state is FinanceInitial) {
      emit(FinanceLoading());
    }

    try {
      _perPage = perPage;
      _currentPage = 1;

      final response = await _financeRepository.getClientAccount(
        page: _currentPage,
        perPage: _perPage,
      );

      if (isClosed) return;

      if (response.isSuccess) {
        _financeData = response.data;
        emit(FinanceLoaded(data: response.data, isRefresh: refresh));
      } else {
        emit(FinanceError(message: response.message));
      }
    } catch (e) {
      if (!isClosed) {
        emit(FinanceError(message: e.toString()));
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
        emit(FinanceError(message: response.message));
      }
    } catch (e) {
      if (!isClosed) {
        emit(FinanceError(message: e.toString()));
      }
    } finally {
      _isLoadingMore = false;
    }
  }

  /// Refresh finance data
  Future<void> refreshFinanceData() async {
    await loadFinanceData(refresh: true);
  }

  /// Reset finance state
  void reset() {
    if (!isClosed) {
      _financeData = null;
      _currentPage = 1;
      _isLoadingMore = false;
      emit(FinanceInitial());
    }
  }
}
