import 'package:client_app/core/utilities/error_message_sanitizer.dart';
import 'package:client_app/features/address_book/cubit/address_book_state.dart';
import 'package:client_app/features/address_book/data/models/address_book_models.dart';
import 'package:client_app/features/address_book/data/repositories/address_book_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressBookCubit extends Cubit<AddressBookState> {
  final AddressBookRepository _repository;

  AddressBookCubit(this._repository) : super(AddressBookInitial());

  // Current data holders
  List<AddressBookEntry> _allEntries = [];
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalEntries = 0;

  // Getters for current state
  List<AddressBookEntry> get allEntries => _allEntries;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalEntries => _totalEntries;
  bool get hasMorePages => _currentPage < _totalPages;

  // Load address book entries
  Future<void> loadAddressBookEntries({
    bool refresh = false,
    int perPage = 10,
  }) async {
    if (isClosed) return;

    if (refresh || state is AddressBookInitial) {
      emit(AddressBookLoading());
      _currentPage = 1;
      _allEntries.clear();
    }

    try {
      final response = await _repository.getAddressBookEntries(
        page: _currentPage,
        perPage: perPage,
      );

      if (isClosed) return;

      if (response != null && response.success) {
        final paginationData = response.data;

        if (refresh || _currentPage == 1) {
          _allEntries = paginationData.data;
        } else {
          _allEntries.addAll(paginationData.data);
        }

        _currentPage = paginationData.currentPage;
        _totalPages = paginationData.lastPage;
        _totalEntries = paginationData.total;

        if (_allEntries.isEmpty) {
          emit(const AddressBookEmpty());
        } else {
          emit(
            AddressBookLoaded(
              entries: _allEntries,
              currentPage: _currentPage,
              totalPages: _totalPages,
              totalEntries: _totalEntries,
              hasMorePages: hasMorePages,
              message: response.message,
            ),
          );
        }
      } else {
        emit(
          AddressBookError(
            message: response?.message ?? 'Failed to load address book entries',
            errors: response?.errors,
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('🔴 AddressBookCubit loadAddressBookEntries Error: $e');
      }
      if (!isClosed) {
        // Sanitize the error message to make it user-friendly
        String errorMessage = ErrorMessageSanitizer.sanitize(e.toString());
        emit(AddressBookError(message: errorMessage, errors: [errorMessage]));
      }
    }
  }

  // Load more entries (pagination)
  Future<void> loadMoreEntries({int perPage = 10}) async {
    if (!hasMorePages || isClosed) return;

    try {
      _currentPage++;

      final response = await _repository.getAddressBookEntries(
        page: _currentPage,
        perPage: perPage,
      );

      if (isClosed) return;

      if (response != null && response.success) {
        final paginationData = response.data;
        _allEntries.addAll(paginationData.data);
        _currentPage = paginationData.currentPage;
        _totalPages = paginationData.lastPage;
        _totalEntries = paginationData.total;

        emit(
          AddressBookLoaded(
            entries: _allEntries,
            currentPage: _currentPage,
            totalPages: _totalPages,
            totalEntries: _totalEntries,
            hasMorePages: hasMorePages,
            message: response.message,
          ),
        );
      } else {
        // Revert page increment on error
        _currentPage--;
        emit(
          AddressBookError(
            message: response?.message ?? 'Failed to load more entries',
            errors: response?.errors,
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('🔴 AddressBookCubit loadMoreEntries Error: $e');
      }
      // Revert page increment on error
      _currentPage--;
      if (!isClosed) {
        // Sanitize the error message to make it user-friendly
        String errorMessage = ErrorMessageSanitizer.sanitize(e.toString());
        emit(AddressBookError(message: errorMessage, errors: [errorMessage]));
      }
    }
  }

  // Create new address book entry
  Future<void> createAddressBookEntry(AddressBookRequest request) async {
    if (isClosed) return;

    try {
      emit(AddressBookCreating());

      final response = await _repository.createAddressBookEntry(request);

      if (isClosed) return;

      if (response != null && response.success && response.data != null) {
        // Add the new entry to local list
        _allEntries.insert(0, response.data!);
        _totalEntries++;

        emit(
          AddressBookEntryCreated(
            entry: response.data!,
            message: response.message,
          ),
        );

        // Refresh the list to show updated data
        await loadAddressBookEntries(refresh: true);
      } else {
        emit(
          AddressBookCreateError(
            message: response?.message ?? 'Failed to create address book entry',
            errors: response?.errors,
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('🔴 AddressBookCubit createAddressBookEntry Error: $e');
      }
      if (!isClosed) {
        // Sanitize the error message to make it user-friendly
        String errorMessage = ErrorMessageSanitizer.sanitize(e.toString());
        emit(
          AddressBookCreateError(message: errorMessage, errors: [errorMessage]),
        );
      }
    }
  }

  // Update address book entry
  Future<void> updateAddressBookEntry(
    int entryId,
    AddressBookRequest request,
  ) async {
    if (isClosed) return;

    try {
      emit(AddressBookUpdating());

      final response = await _repository.updateAddressBookEntry(
        entryId,
        request,
      );

      if (isClosed) return;

      if (response != null && response.success && response.data != null) {
        // Update the entry in local list
        final index = _allEntries.indexWhere((entry) => entry.id == entryId);
        if (index != -1) {
          _allEntries[index] = response.data!;
        }

        emit(
          AddressBookEntryUpdated(
            entry: response.data!,
            message: response.message,
          ),
        );

        // Refresh the list to show updated data
        await loadAddressBookEntries(refresh: true);
      } else {
        emit(
          AddressBookUpdateError(
            message: response?.message ?? 'Failed to update address book entry',
            errors: response?.errors,
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('🔴 AddressBookCubit updateAddressBookEntry Error: $e');
      }
      if (!isClosed) {
        emit(
          AddressBookUpdateError(
            message: 'An error occurred while updating address book entry',
            errors: [e.toString()],
          ),
        );
      }
    }
  }

  // Delete address book entry
  Future<void> deleteAddressBookEntry(int entryId) async {
    if (isClosed) return;

    try {
      emit(AddressBookDeleting());

      final response = await _repository.deleteAddressBookEntry(entryId);

      if (isClosed) return;

      if (response.success) {
        // Remove the entry from local list
        _allEntries.removeWhere((entry) => entry.id == entryId);
        _totalEntries--;

        emit(
          AddressBookEntryDeleted(
            entryId: entryId,
            message:
                response.message ?? 'Address book entry deleted successfully',
          ),
        );

        // Refresh the list to show updated data
        await loadAddressBookEntries(refresh: true);
      } else {
        emit(
          AddressBookDeleteError(
            message: response.message ?? 'Failed to delete address book entry',
            errors: [response.message],
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('🔴 AddressBookCubit deleteAddressBookEntry Error: $e');
      }
      if (!isClosed) {
        emit(
          AddressBookDeleteError(
            message: 'An error occurred while deleting address book entry',
            errors: [e.toString()],
          ),
        );
      }
    }
  }

  // Get entry by ID
  AddressBookEntry? getEntryById(int entryId) {
    try {
      return _allEntries.firstWhere((entry) => entry.id == entryId);
    } catch (e) {
      return null;
    }
  }

  // Clear all data
  void clearData() {
    if (!isClosed) {
      _allEntries.clear();
      _currentPage = 1;
      _totalPages = 1;
      _totalEntries = 0;
      emit(AddressBookInitial());
    }
  }

  // Reset to initial state
  void reset() {
    if (!isClosed) {
      clearData();
    }
  }
}
