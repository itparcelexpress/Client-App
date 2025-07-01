import 'dart:typed_data';

import 'package:client_app/core/utilities/app_endpoints.dart';
import 'package:client_app/core/utilities/logger.dart';
import 'package:client_app/data/local/local_data.dart';
import 'package:client_app/data/remote/app_request.dart';
import 'package:client_app/data/remote/helper/app_response.dart';
import 'package:client_app/features/invoices/data/models/invoice_models.dart';
import 'package:dio/dio.dart';

class InvoiceRepository {
  InvoiceRepository();

  /// Get all invoices for the current user with pagination
  static Future<InvoicesListResponse> getInvoices({
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final user = LocalData.user;
      if (user?.id == null) {
        throw Exception('User not found. Please login again.');
      }

      final AppResponse response = await AppRequest.get(
        AppEndPoints.clientInvoices(user!.id!),
        true,
        queryParameters: {'page': page, 'per_page': perPage},
      );

      if (response.success && response.origin != null) {
        return InvoicesListResponse.fromJson(response.origin!);
      } else {
        throw Exception(response.message ?? 'Failed to fetch invoices');
      }
    } catch (e) {
      Logger.error('Error fetching invoices: $e');
      if (e.toString().contains('message')) {
        rethrow;
      }
      throw Exception('Network error occurred while fetching invoices');
    }
  }

  /// Get specific invoice details by ID
  static Future<InvoiceDetailResponse> getInvoiceDetails(int invoiceId) async {
    try {
      final user = LocalData.user;
      if (user?.id == null) {
        throw Exception('User not found. Please login again.');
      }

      final AppResponse response = await AppRequest.get(
        AppEndPoints.clientInvoiceDetails(user!.id!, invoiceId),
        true,
      );

      if (response.success && response.origin != null) {
        return InvoiceDetailResponse.fromJson(response.origin!);
      } else {
        throw Exception(response.message ?? 'Failed to fetch invoice details');
      }
    } catch (e) {
      Logger.error('Error fetching invoice details: $e');
      if (e.toString().contains('message')) {
        rethrow;
      }
      throw Exception('Network error occurred while fetching invoice details');
    }
  }

  /// Download invoice PDF
  static Future<List<int>> downloadInvoicePdf(int invoiceId) async {
    try {
      final user = LocalData.user;
      if (user?.id == null) {
        throw Exception('User not found. Please login again.');
      }

      Logger.info('Downloading PDF for invoice ID: $invoiceId');

      final AppResponse response = await AppRequest.get(
        AppEndPoints.clientInvoiceDownload(user!.id!, invoiceId),
        true,
        initHeader: {'Accept': 'application/pdf'},
        responseType: ResponseType.bytes, // Handle as binary data
      );

      if (response.success && response.data != null) {
        Logger.info('PDF Response data type: ${response.data.runtimeType}');

        // Response should now be List<int> directly from Dio
        if (response.data is List<int>) {
          Logger.info(
            'PDF downloaded successfully as List<int>, size: ${(response.data as List<int>).length} bytes',
          );
          return response.data as List<int>;
        } else if (response.data is Uint8List) {
          Logger.info(
            'PDF downloaded successfully as Uint8List, size: ${(response.data as Uint8List).length} bytes',
          );
          return (response.data as Uint8List).toList();
        } else {
          // This shouldn't happen with ResponseType.bytes, but keep as fallback
          Logger.warning(
            'Unexpected response data type: ${response.data.runtimeType}',
          );
          throw Exception(
            'Unexpected PDF data format: ${response.data.runtimeType}',
          );
        }
      } else {
        throw Exception(response.message ?? 'Failed to download invoice PDF');
      }
    } catch (e) {
      Logger.error('Error downloading invoice PDF: $e');
      if (e.toString().contains('User not found') ||
          e.toString().contains('Unexpected PDF data format')) {
        rethrow;
      }
      throw Exception('Network error occurred while downloading invoice PDF');
    }
  }

  /// Search invoices by invoice number or status
  static Future<InvoicesListResponse> searchInvoices({
    String? invoiceNo,
    String? status,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final user = LocalData.user;
      if (user?.id == null) {
        throw Exception('User not found. Please login again.');
      }

      Map<String, dynamic> queryParams = {'page': page, 'per_page': perPage};

      if (invoiceNo != null && invoiceNo.isNotEmpty) {
        queryParams['invoice_no'] = invoiceNo;
      }

      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }

      final AppResponse response = await AppRequest.get(
        AppEndPoints.clientInvoicesSearch(user!.id!),
        true,
        queryParameters: queryParams,
      );

      if (response.success && response.origin != null) {
        return InvoicesListResponse.fromJson(response.origin!);
      } else {
        throw Exception(response.message ?? 'Failed to search invoices');
      }
    } catch (e) {
      Logger.error('Error searching invoices: $e');
      if (e.toString().contains('message')) {
        rethrow;
      }
      throw Exception('Network error occurred while searching invoices');
    }
  }

  /// Get payment transactions
  static Future<PaymentTransactionsResponse> getPaymentTransactions() async {
    try {
      final AppResponse response = await AppRequest.get(
        AppEndPoints.clientPaymentTransactions,
        true,
      );

      if (response.success && response.origin != null) {
        return PaymentTransactionsResponse.fromJson(response.origin!);
      } else {
        throw Exception(
          response.message ?? 'Failed to fetch payment transactions',
        );
      }
    } catch (e) {
      Logger.error('Error fetching payment transactions: $e');
      if (e.toString().contains('message')) {
        rethrow;
      }
      throw Exception(
        'Network error occurred while fetching payment transactions',
      );
    }
  }

  /// Get payment summary
  static Future<PaymentSummaryResponse> getPaymentSummary() async {
    try {
      final AppResponse response = await AppRequest.get(
        AppEndPoints.clientPaymentSummary,
        true,
      );

      if (response.success && response.origin != null) {
        return PaymentSummaryResponse.fromJson(response.origin!);
      } else {
        throw Exception(response.message ?? 'Failed to fetch payment summary');
      }
    } catch (e) {
      Logger.error('Error fetching payment summary: $e');
      if (e.toString().contains('message')) {
        rethrow;
      }
      throw Exception('Network error occurred while fetching payment summary');
    }
  }
}
