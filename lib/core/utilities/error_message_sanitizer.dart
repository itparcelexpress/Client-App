class ErrorMessageSanitizer {
  ErrorMessageSanitizer._();

  /// Sanitizes error messages to make them user-friendly
  /// Removes technical jargon and inappropriate language
  static String sanitize(String errorMessage) {
    if (errorMessage.isEmpty) {
      return 'An unexpected error occurred. Please try again.';
    }

    // Convert to lowercase for easier matching
    String sanitized = errorMessage.toLowerCase();

    // Handle specific error patterns
    if (sanitized.contains('client commission not available')) {
      return 'Service is not available for the selected location. Please choose a different area or contact support.';
    }

    if (sanitized.contains('commission is not available')) {
      return 'Service is not available for the selected location. Please choose a different area or contact support.';
    }

    if (sanitized.contains('not available for the selected state')) {
      return 'Service is not available for the selected location. Please choose a different area or contact support.';
    }

    if (sanitized.contains('unauthorized') ||
        sanitized.contains('unauthenticated')) {
      return 'Your session has expired. Please log in again.';
    }

    if (sanitized.contains('network error') ||
        sanitized.contains('connection error')) {
      return 'Please check your internet connection and try again.';
    }

    if (sanitized.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }

    if (sanitized.contains('server error') ||
        sanitized.contains('internal server error')) {
      return 'Our servers are experiencing issues. Please try again later.';
    }

    if (sanitized.contains('validation failed')) {
      return 'Please check your input and try again.';
    }

    if (sanitized.contains('not found')) {
      return 'The requested information was not found.';
    }

    if (sanitized.contains('forbidden')) {
      return 'You do not have permission to perform this action.';
    }

    if (sanitized.contains('bad request')) {
      return 'Invalid request. Please check your input and try again.';
    }

    // Remove technical error prefixes
    sanitized = sanitized
        .replaceAll('dioexceptiontype.', '')
        .replaceAll('dioexception.', '')
        .replaceAll('exception:', '')
        .replaceAll('error:', '')
        .replaceAll('failed:', '');

    // Remove common technical terms
    sanitized = sanitized
        .replaceAll('http', '')
        .replaceAll('api', '')
        .replaceAll('endpoint', '')
        .replaceAll('request', '')
        .replaceAll('response', '')
        .replaceAll('status code', '')
        .replaceAll('statuscode', '');

    // Clean up extra spaces and punctuation
    sanitized =
        sanitized
            .replaceAll(RegExp(r'\s+'), ' ')
            .replaceAll(RegExp(r'[{}[\]"]'), '')
            .trim();

    // Capitalize first letter
    if (sanitized.isNotEmpty) {
      sanitized = sanitized[0].toUpperCase() + sanitized.substring(1);
    }

    // If the message is too technical or empty after sanitization, provide a generic message
    if (sanitized.isEmpty ||
        sanitized.length < 10 ||
        sanitized.contains('{') ||
        sanitized.contains('}') ||
        sanitized.contains('null') ||
        sanitized.contains('undefined')) {
      return 'An unexpected error occurred. Please try again.';
    }

    return sanitized;
  }

  /// Sanitizes a list of error messages
  static List<String> sanitizeList(List<String> errorMessages) {
    return errorMessages.map((error) => sanitize(error)).toList();
  }

  /// Sanitizes error messages from API response
  static String sanitizeApiError(Map<String, dynamic>? apiResponse) {
    if (apiResponse == null) {
      return 'An unexpected error occurred. Please try again.';
    }

    // Try to get the main message first
    String? message = apiResponse['message']?.toString();

    // If no main message, try to get from errors array
    if (message == null || message.isEmpty) {
      final errors = apiResponse['errors'];
      if (errors is List && errors.isNotEmpty) {
        message = errors.first.toString();
      }
    }

    // If still no message, check validation errors map structure
    if (message == null || message.isEmpty) {
      final errors = apiResponse['errors'];
      if (errors is Map<String, dynamic>) {
        // Take the first error message from the map
        for (final entry in errors.entries) {
          final value = entry.value;
          if (value is List && value.isNotEmpty) {
            message = value.first.toString();
            break;
          } else if (value is String) {
            message = value;
            break;
          }
        }
      }
    }

    // If still no message, provide a generic one
    if (message == null || message.isEmpty) {
      return 'An unexpected error occurred. Please try again.';
    }

    return sanitize(message);
  }
}
