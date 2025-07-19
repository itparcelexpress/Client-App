import 'package:client_app/core/utilities/error_message_sanitizer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ErrorMessageSanitizer', () {
    test('should sanitize client commission error', () {
      const errorMessage =
          'Client commission not available for the selected state.';
      final sanitized = ErrorMessageSanitizer.sanitize(errorMessage);

      expect(
        sanitized,
        'Service is not available for the selected location. Please choose a different area or contact support.',
      );
    });

    test('should sanitize commission error', () {
      const errorMessage = 'Commission is not available for the state';
      final sanitized = ErrorMessageSanitizer.sanitize(errorMessage);

      expect(
        sanitized,
        'Service is not available for the selected location. Please choose a different area or contact support.',
      );
    });

    test('should sanitize unauthorized error', () {
      const errorMessage = 'Unauthorized access';
      final sanitized = ErrorMessageSanitizer.sanitize(errorMessage);

      expect(sanitized, 'Your session has expired. Please log in again.');
    });

    test('should sanitize network error', () {
      const errorMessage = 'Network error occurred';
      final sanitized = ErrorMessageSanitizer.sanitize(errorMessage);

      expect(sanitized, 'Please check your internet connection and try again.');
    });

    test('should sanitize timeout error', () {
      const errorMessage = 'Request timeout';
      final sanitized = ErrorMessageSanitizer.sanitize(errorMessage);

      expect(sanitized, 'Request timed out. Please try again.');
    });

    test('should sanitize server error', () {
      const errorMessage = 'Internal server error';
      final sanitized = ErrorMessageSanitizer.sanitize(errorMessage);

      expect(
        sanitized,
        'Our servers are experiencing issues. Please try again later.',
      );
    });

    test('should remove technical prefixes', () {
      const errorMessage = 'DioExceptionType.badResponse: HTTP 400 Bad Request';
      final sanitized = ErrorMessageSanitizer.sanitize(errorMessage);

      expect(
        sanitized,
        'Invalid request. Please check your input and try again.',
      );
    });

    test('should handle empty message', () {
      const errorMessage = '';
      final sanitized = ErrorMessageSanitizer.sanitize(errorMessage);

      expect(sanitized, 'An unexpected error occurred. Please try again.');
    });

    test('should handle null API response', () {
      final sanitized = ErrorMessageSanitizer.sanitizeApiError(null);

      expect(sanitized, 'An unexpected error occurred. Please try again.');
    });

    test('should sanitize API response with message', () {
      final apiResponse = {
        'message': 'Client commission not available for the selected state.',
        'success': false,
        'errors': ['Client commission is not available for the state'],
      };

      final sanitized = ErrorMessageSanitizer.sanitizeApiError(apiResponse);

      expect(
        sanitized,
        'Service is not available for the selected location. Please choose a different area or contact support.',
      );
    });

    test('should sanitize API response with errors array', () {
      final apiResponse = {
        'success': false,
        'errors': ['Client commission is not available for the state'],
      };

      final sanitized = ErrorMessageSanitizer.sanitizeApiError(apiResponse);

      expect(
        sanitized,
        'Service is not available for the selected location. Please choose a different area or contact support.',
      );
    });

    test('should provide generic message for technical errors', () {
      const errorMessage = '{null}';
      final sanitized = ErrorMessageSanitizer.sanitize(errorMessage);

      expect(sanitized, 'An unexpected error occurred. Please try again.');
    });
  });
}
