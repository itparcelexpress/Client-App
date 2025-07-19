import 'package:client_app/core/utilities/app_endpoints.dart';
import 'package:client_app/core/utilities/error_message_sanitizer.dart';
import 'package:client_app/data/remote/app_request.dart';
import 'package:client_app/data/remote/helper/app_response.dart';
import 'package:client_app/features/address_book/data/models/address_book_models.dart';
import 'package:flutter/foundation.dart';

abstract class AddressBookRepository {
  Future<AddressBookListResponse?> getAddressBookEntries({
    int page = 1,
    int perPage = 10,
  });
  Future<AddressBookResponse?> createAddressBookEntry(
    AddressBookRequest request,
  );
  Future<AddressBookResponse?> updateAddressBookEntry(
    int addressId,
    AddressBookRequest request,
  );
  Future<AppResponse> deleteAddressBookEntry(int addressId);
}

class AddressBookRepositoryImpl implements AddressBookRepository {
  @override
  Future<AddressBookListResponse?> getAddressBookEntries({
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final response = await AppRequest.get(
        AppEndPoints.addressBook,
        true, // Requires authentication
        queryParameters: {
          'page': page.toString(),
          'per_page': perPage.toString(),
        },
      );

      if (kDebugMode) {
        print('🟢 Address Book List Response: ${response.origin}');
      }

      if (response.success && response.origin != null) {
        return AddressBookListResponse.fromJson(response.origin!);
      } else {
        if (kDebugMode) {
          print('🔴 Address Book List Error: ${response.message}');
        }
        String errorMessage = ErrorMessageSanitizer.sanitizeApiError(
          response.origin,
        );
        return AddressBookListResponse(
          message: errorMessage,
          success: false,
          data: const AddressBookPaginationData(
            currentPage: 1,
            data: [],
            firstPageUrl: '',
            from: 0,
            lastPage: 1,
            lastPageUrl: '',
            links: [],
            path: '',
            perPage: 10,
            to: 0,
            total: 0,
          ),
          errors: [errorMessage],
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('🔴 Address Book List Exception: $e');
      }
      String errorMessage = ErrorMessageSanitizer.sanitize(e.toString());
      return AddressBookListResponse(
        message: errorMessage,
        success: false,
        data: const AddressBookPaginationData(
          currentPage: 1,
          data: [],
          firstPageUrl: '',
          from: 0,
          lastPage: 1,
          lastPageUrl: '',
          links: [],
          path: '',
          perPage: 10,
          to: 0,
          total: 0,
        ),
        errors: [errorMessage],
      );
    }
  }

  @override
  Future<AddressBookResponse?> createAddressBookEntry(
    AddressBookRequest request,
  ) async {
    try {
      if (kDebugMode) {
        print('🟢 Creating Address Book Entry: ${request.toJson()}');
      }

      final response = await AppRequest.post(
        AppEndPoints.createAddressBook,
        true, // Requires authentication
        data: request.toJson(),
      );

      if (kDebugMode) {
        print('🟢 Create Address Book Response: ${response.origin}');
      }

      if (response.success && response.origin != null) {
        return AddressBookResponse.fromJson(response.origin!);
      } else {
        if (kDebugMode) {
          print('🔴 Create Address Book Error: ${response.message}');
        }
        String errorMessage = ErrorMessageSanitizer.sanitizeApiError(
          response.origin,
        );
        return AddressBookResponse(
          message: errorMessage,
          success: false,
          errors: [errorMessage],
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('🔴 Create Address Book Exception: $e');
      }
      String errorMessage = ErrorMessageSanitizer.sanitize(e.toString());
      return AddressBookResponse(
        message: errorMessage,
        success: false,
        errors: [errorMessage],
      );
    }
  }

  @override
  Future<AddressBookResponse?> updateAddressBookEntry(
    int addressId,
    AddressBookRequest request,
  ) async {
    try {
      if (kDebugMode) {
        print('🟢 Updating Address Book Entry $addressId: ${request.toJson()}');
      }

      final response = await AppRequest.post(
        AppEndPoints.updateAddressBook(addressId),
        true, // Requires authentication
        data: request.toJson(),
      );

      if (kDebugMode) {
        print('🟢 Update Address Book Response: ${response.origin}');
      }

      if (response.success && response.origin != null) {
        return AddressBookResponse.fromJson(response.origin!);
      } else {
        if (kDebugMode) {
          print('🔴 Update Address Book Error: ${response.message}');
        }
        String errorMessage = ErrorMessageSanitizer.sanitizeApiError(
          response.origin,
        );
        return AddressBookResponse(
          message: errorMessage,
          success: false,
          errors: [errorMessage],
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('🔴 Update Address Book Exception: $e');
      }
      String errorMessage = ErrorMessageSanitizer.sanitize(e.toString());
      return AddressBookResponse(
        message: errorMessage,
        success: false,
        errors: [errorMessage],
      );
    }
  }

  @override
  Future<AppResponse> deleteAddressBookEntry(int addressId) async {
    try {
      if (kDebugMode) {
        print('🟢 Deleting Address Book Entry: $addressId');
      }

      final response = await AppRequest.post(
        AppEndPoints.deleteAddressBook(addressId),
        true, // Requires authentication
      );

      if (kDebugMode) {
        print('🟢 Delete Address Book Response: ${response.origin}');
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print('🔴 Delete Address Book Exception: $e');
      }
      return AppResponse(
        success: false,
        message: 'An error occurred while deleting address book entry',
        origin: {'error': e.toString()},
      );
    }
  }
}
