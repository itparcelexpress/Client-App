/// Reusable form field validators for the app.
/// Centralizes all validation logic to ensure consistency and reuse.

class Validators {
  /// Validates a required field.
  static String? requiredField(
    String? value, {
    String fieldName = 'This field',
  }) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $fieldName';
    }
    return null;
  }

  /// Validates the minimum length of a field.
  static String? minLength(
    String? value,
    int min, {
    String fieldName = 'This field',
  }) {
    if (value == null || value.trim().length < min) {
      return '$fieldName must be at least $min characters';
    }
    return null;
  }

  /// Optional variant of [minLength].
  static String? optionalMinLength(
    String? value,
    int min, {
    String fieldName = 'This field',
  }) {
    if (value == null || value.trim().isEmpty) return null;
    return minLength(value, min, fieldName: fieldName);
  }

  /// Validates an email address.
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates a phone number (Egyptian format by default).
  static String? phone(String? value, {String fieldName = 'Phone'}) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $fieldName';
    }
    final phoneRegex = RegExp(r'^01[0125][0-9]{8}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Please enter a valid $fieldName number';
    }
    return null;
  }

  /// Optional phone validator.
  static String? optionalPhone(String? value, {String fieldName = 'Phone'}) {
    if (value == null || value.trim().isEmpty) return null;
    return phone(value, fieldName: fieldName);
  }

  /// Validates a URL (e.g. for Google Maps).
  static String? locationUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a location URL';
    }
    final urlRegex = RegExp(
      r'^(https?:\/\/)?([\w\-]+\.)+[a-zA-Z]{2,}([\/\w\-.,@?^=%&:/~+#]*)?$',
    );
    if (!urlRegex.hasMatch(value.trim())) {
      return 'Please enter a valid URL';
    }
    return null;
  }

  /// Validates that a string can be parsed to a positive double.
  static String? amount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an amount';
    }
    final parsed = double.tryParse(value.replaceAll(',', ''));
    if (parsed == null || parsed <= 0) {
      return 'Please enter a valid amount';
    }
    return null;
  }

  /// Validates a numeric-only string.
  static String? numeric(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $fieldName';
    }
    if (!RegExp(r'^\d+$').hasMatch(value.trim())) {
      return '$fieldName must contain digits only';
    }
    return null;
  }

  /// Validates a national ID (e.g., Egyptian 14-digit).
  static String? nationalId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your national ID';
    }
    if (!RegExp(r'^\d{14}$').hasMatch(value.trim())) {
      return 'Please enter a valid 14-digit ID';
    }
    return null;
  }

  /// Validates strong passwords.
  static String? strongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    final hasUpper = RegExp(r'[A-Z]').hasMatch(value);
    final hasLower = RegExp(r'[a-z]').hasMatch(value);
    final hasDigit = RegExp(r'\d').hasMatch(value);
    final hasSymbol = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);
    if (!(hasUpper && hasLower && hasDigit && hasSymbol)) {
      return 'Password must contain upper, lower, number and symbol';
    }
    return null;
  }

  /// Combine multiple validators into one.
  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) {
    return (value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }
}
