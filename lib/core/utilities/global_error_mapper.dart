import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class GlobalErrorMapper {
  GlobalErrorMapper._();

  /// Maps API error messages to localized user-friendly messages
  static String mapErrorToLocalizedMessage({
    required String? message,
    List<String>? errors,
    Map<String, dynamic>? data,
    int? statusCode,
    required BuildContext context,
  }) {
    final localizations = AppLocalizations.of(context)!;
    final msg = (message ?? '').toLowerCase().trim();

    // Handle specific error messages from API
    if (msg.contains('amount exceeds current balance')) {
      return localizations.settlementAmountExceedsBalance;
    }

    if (msg.contains('insufficient balance')) {
      return localizations.insufficientBalance;
    }

    if (msg.contains('invalid settlement amount')) {
      return localizations.invalidSettlementAmount;
    }

    if (msg.contains('settlement request already exists')) {
      return localizations.settlementRequestAlreadyExists;
    }

    if (msg.contains('minimum settlement amount')) {
      return localizations.minimumSettlementAmount;
    }

    if (msg.contains('maximum settlement amount')) {
      return localizations.maximumSettlementAmount;
    }

    if (msg.contains('account not found')) {
      return localizations.accountNotFound;
    }

    if (msg.contains('unauthorized') || msg.contains('unauthenticated')) {
      return localizations.sessionExpired;
    }

    if (msg.contains('forbidden')) {
      return localizations.accessDenied;
    }

    if (msg.contains('not found')) {
      return localizations.resourceNotFound;
    }

    if (msg.contains('validation failed') || msg.contains('invalid input')) {
      return localizations.validationFailed;
    }

    if (msg.contains('network error') || msg.contains('connection error')) {
      return localizations.networkError;
    }

    if (msg.contains('timeout')) {
      return localizations.requestTimeout;
    }

    if (msg.contains('server error') || msg.contains('internal server error')) {
      return localizations.serverError;
    }

    if (msg.contains('service unavailable')) {
      return localizations.serviceUnavailable;
    }

    if (msg.contains('too many requests')) {
      return localizations.tooManyRequests;
    }

    if (msg.contains('payment required')) {
      return localizations.paymentRequired;
    }

    if (msg.contains('conflict')) {
      return localizations.resourceConflict;
    }

    if (msg.contains('precondition failed')) {
      return localizations.preconditionFailed;
    }

    if (msg.contains('request entity too large')) {
      return localizations.requestTooLarge;
    }

    if (msg.contains('unsupported media type')) {
      return localizations.unsupportedMediaType;
    }

    if (msg.contains('unprocessable entity')) {
      return localizations.unprocessableEntity;
    }

    if (msg.contains('locked')) {
      return localizations.resourceLocked;
    }

    if (msg.contains('failed dependency')) {
      return localizations.failedDependency;
    }

    if (msg.contains('upgrade required')) {
      return localizations.upgradeRequired;
    }

    if (msg.contains('precondition required')) {
      return localizations.preconditionRequired;
    }

    if (msg.contains('too many connections')) {
      return localizations.tooManyConnections;
    }

    if (msg.contains('legal reasons')) {
      return localizations.unavailableForLegalReasons;
    }

    // Handle specific status codes
    if (statusCode != null) {
      switch (statusCode) {
        case 400:
          return localizations.badRequest;
        case 401:
          return localizations.unauthorized;
        case 403:
          return localizations.forbidden;
        case 404:
          return localizations.notFound;
        case 405:
          return localizations.methodNotAllowed;
        case 406:
          return localizations.notAcceptable;
        case 408:
          return localizations.requestTimeout;
        case 409:
          return localizations.resourceConflict;
        case 410:
          return localizations.gone;
        case 411:
          return localizations.lengthRequired;
        case 412:
          return localizations.preconditionFailed;
        case 413:
          return localizations.payloadTooLarge;
        case 414:
          return localizations.uriTooLong;
        case 415:
          return localizations.unsupportedMediaType;
        case 416:
          return localizations.rangeNotSatisfiable;
        case 417:
          return localizations.expectationFailed;
        case 418:
          return localizations.imATeapot;
        case 421:
          return localizations.misdirectedRequest;
        case 422:
          return localizations.unprocessableEntity;
        case 423:
          return localizations.locked;
        case 424:
          return localizations.failedDependency;
        case 425:
          return localizations.tooEarly;
        case 426:
          return localizations.upgradeRequired;
        case 428:
          return localizations.preconditionRequired;
        case 429:
          return localizations.tooManyRequests;
        case 431:
          return localizations.requestHeaderFieldsTooLarge;
        case 451:
          return localizations.unavailableForLegalReasons;
        case 500:
          return localizations.internalServerError;
        case 501:
          return localizations.notImplemented;
        case 502:
          return localizations.badGateway;
        case 503:
          return localizations.serviceUnavailable;
        case 504:
          return localizations.gatewayTimeout;
        case 505:
          return localizations.httpVersionNotSupported;
        case 506:
          return localizations.variantAlsoNegotiates;
        case 507:
          return localizations.insufficientStorage;
        case 508:
          return localizations.loopDetected;
        case 510:
          return localizations.notExtended;
        case 511:
          return localizations.networkAuthenticationRequired;
      }
    }

    // Handle errors from the errors array
    if (errors != null && errors.isNotEmpty) {
      final joinedErrors = errors.join(' ').toLowerCase();

      if (joinedErrors.contains('amount')) {
        return localizations.invalidAmount;
      }

      if (joinedErrors.contains('email')) {
        return localizations.invalidEmail;
      }

      if (joinedErrors.contains('phone')) {
        return localizations.invalidPhone;
      }

      if (joinedErrors.contains('password')) {
        return localizations.invalidPassword;
      }

      if (joinedErrors.contains('required')) {
        return localizations.fieldRequired;
      }
    }

    // Handle data-specific errors
    if (data != null) {
      if (data['current_balance'] != null && data['requested'] != null) {
        final currentBalance = data['current_balance'] as num?;
        final requested = data['requested'] as num?;

        if (currentBalance != null &&
            requested != null &&
            requested > currentBalance) {
          return localizations.settlementAmountExceedsBalance;
        }
      }
    }

    // If no specific error found, return a generic message
    return localizations.unexpectedErrorOccurred;
  }

  /// Maps DioException to localized error message
  static String mapDioExceptionToLocalizedMessage({
    required dynamic exception,
    required BuildContext context,
  }) {
    final localizations = AppLocalizations.of(context)!;

    if (exception.toString().toLowerCase().contains(
      'dioexceptiontype.badresponse',
    )) {
      return localizations.badResponse;
    }

    if (exception.toString().toLowerCase().contains(
      'dioexceptiontype.connectiontimeout',
    )) {
      return localizations.connectionTimeout;
    }

    if (exception.toString().toLowerCase().contains(
      'dioexceptiontype.sendtimeout',
    )) {
      return localizations.sendTimeout;
    }

    if (exception.toString().toLowerCase().contains(
      'dioexceptiontype.receivetimeout',
    )) {
      return localizations.receiveTimeout;
    }

    if (exception.toString().toLowerCase().contains(
      'dioexceptiontype.cancel',
    )) {
      return localizations.requestCancelled;
    }

    if (exception.toString().toLowerCase().contains(
      'dioexceptiontype.connectionerror',
    )) {
      return localizations.connectionError;
    }

    if (exception.toString().toLowerCase().contains(
      'dioexceptiontype.unknown',
    )) {
      return localizations.unknownError;
    }

    return localizations.unexpectedErrorOccurred;
  }

  /// Sanitizes and maps any error to a user-friendly localized message
  static String sanitizeAndMapError({
    required dynamic error,
    required BuildContext context,
    String? message,
    List<String>? errors,
    Map<String, dynamic>? data,
    int? statusCode,
  }) {
    // First try to map based on message and status code
    if (message != null || statusCode != null) {
      final mappedMessage = mapErrorToLocalizedMessage(
        message: message,
        errors: errors,
        data: data,
        statusCode: statusCode,
        context: context,
      );

      if (mappedMessage !=
          AppLocalizations.of(context)!.unexpectedErrorOccurred) {
        return mappedMessage;
      }
    }

    // Try to map DioException
    final dioMessage = mapDioExceptionToLocalizedMessage(
      exception: error,
      context: context,
    );

    if (dioMessage != AppLocalizations.of(context)!.unexpectedErrorOccurred) {
      return dioMessage;
    }

    // Fallback to generic error
    return AppLocalizations.of(context)!.unexpectedErrorOccurred;
  }
}
