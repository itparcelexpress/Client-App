import 'package:client_app/core/utilities/error_message_sanitizer.dart';
import 'package:client_app/features/invoices/data/models/invoice_models.dart';
import 'package:client_app/features/wallet/cubit/wallet_state.dart';
import 'package:client_app/features/wallet/data/repositories/wallet_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletCubit extends Cubit<WalletState> {
  final WalletRepository _repository;

  WalletCubit(this._repository) : super(WalletInitial());

  List<WalletTransaction> _transactions = [];
  String _balance = '0.00';
  int _currentPage = 1;
  int _totalPages = 1;
  int _total = 0;

  Future<void> loadWallet({bool refresh = false, int perPage = 20}) async {
    if (isClosed) return;

    if (refresh || state is WalletInitial) {
      emit(WalletLoading());
      _currentPage = 1;
      _transactions = [];
    }

    try {
      final response = await _repository.getWallet(
        page: _currentPage,
        perPage: perPage,
      );

      if (isClosed) return;

      if (response.success) {
        final data = response.data;
        _balance = data.balance;
        final page = data.transactions;

        if (refresh || _currentPage == 1) {
          _transactions = page.data;
        } else {
          _transactions.addAll(page.data);
        }

        _currentPage = page.currentPage;
        _totalPages = page.lastPage;
        _total = page.total;

        if (_transactions.isEmpty) {
          emit(WalletEmpty());
        } else {
          emit(
            WalletLoaded(
              balance: _balance,
              transactions: _transactions,
              currentPage: _currentPage,
              totalPages: _totalPages,
              total: _total,
              hasMorePages: _currentPage < _totalPages,
            ),
          );
        }
      } else {
        emit(WalletError(message: response.message, errors: response.errors));
      }
    } catch (e) {
      if (kDebugMode) {
        print('WalletCubit loadWallet error: $e');
      }
      final msg = ErrorMessageSanitizer.sanitize(e.toString());
      if (!isClosed) emit(WalletError(message: msg, errors: [msg]));
    }
  }

  Future<void> loadMore({int perPage = 20}) async {
    if (isClosed) return;
    if (_currentPage >= _totalPages) return;

    try {
      _currentPage++;
      final response = await _repository.getWallet(
        page: _currentPage,
        perPage: perPage,
      );

      if (isClosed) return;

      if (response.success) {
        final page = response.data.transactions;
        _transactions.addAll(page.data);
        _currentPage = page.currentPage;
        _totalPages = page.lastPage;
        _total = page.total;

        emit(
          WalletLoaded(
            balance: _balance,
            transactions: _transactions,
            currentPage: _currentPage,
            totalPages: _totalPages,
            total: _total,
            hasMorePages: _currentPage < _totalPages,
          ),
        );
      } else {
        _currentPage--; // revert
        emit(WalletError(message: response.message, errors: response.errors));
      }
    } catch (e) {
      _currentPage--;
      final msg = ErrorMessageSanitizer.sanitize(e.toString());
      if (!isClosed) emit(WalletError(message: msg, errors: [msg]));
    }
  }
}
