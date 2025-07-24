/// Reusable form field validators for the app.
/// Centralizes all validation logic to ensure consistency and reuse.

import 'package:flutter/material.dart';
import 'package:client_app/l10n/app_localizations.dart';

class Validators {
  /// Validates a required field.
  static String? requiredField(
    String? value, {
    required BuildContext context,
    required String fieldName,
  }) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.pleaseEnterField(fieldName);
    }
    return null;
  }

  /// Validates the minimum length of a field.
  static String? minLength(
    String? value,
    int min, {
    required BuildContext context,
    required String fieldName,
  }) {
    if (value == null || value.trim().length < min) {
      return AppLocalizations.of(context)!.fieldMinLength(fieldName, min);
    }
    return null;
  }

  /// Optional variant of [minLength].
  static String? optionalMinLength(
    String? value,
    int min, {
    required BuildContext context,
    required String fieldName,
  }) {
    if (value == null || value.trim().isEmpty) return null;
    return minLength(value, min, context: context, fieldName: fieldName);
  }

  /// Validates an email address.
  static String? email(String? value, {required BuildContext context}) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.pleaseEnterEmail;
    }
    // More comprehensive email regex
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return AppLocalizations.of(context)!.pleaseEnterValidEmail;
    }
    return null;
  }

  /// Validates a phone number (international format).
  static String? phone(
    String? value, {
    required BuildContext context,
    required String fieldName,
  }) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.pleaseEnterField(fieldName);
    }
    // International phone format (minimum 8 digits, maximum 15 digits)
    // Allows optional + prefix and country code
    final phoneRegex = RegExp(r'^\+?[0-9]{8,15}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return AppLocalizations.of(context)!.pleaseEnterValidPhone(fieldName);
    }
    return null;
  }

  /// Optional phone validator.
  static String? optionalPhone(
    String? value, {
    required BuildContext context,
    required String fieldName,
  }) {
    if (value == null || value.trim().isEmpty) return null;
    return phone(value, context: context, fieldName: fieldName);
  }

  /// Validates a maps URL.
  static String? locationUrl(String? value, {required BuildContext context}) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.pleaseEnterLocationUrl;
    }
    // Specific regex for Google Maps or similar map service URLs
    final mapsRegex = RegExp(
      r'^(https?:\/\/)?(www\.)?(google\.com\/maps|maps\.google\.com|maps\.app\.goo\.gl|goo\.gl\/maps).*$',
      caseSensitive: false,
    );
    if (!mapsRegex.hasMatch(value.trim())) {
      return AppLocalizations.of(context)!.pleaseEnterValidLocationUrl;
    }
    return null;
  }

  /// Optional location URL validator
  static String? optionalLocationUrl(
    String? value, {
    required BuildContext context,
  }) {
    if (value == null || value.trim().isEmpty) return null;
    return locationUrl(value, context: context);
  }

  /// Validates that a string can be parsed to a positive double with minimum value.
  static String? amount(
    String? value, {
    required BuildContext context,
    double minAmount = 0.0,
  }) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.pleaseEnterAmount;
    }
    final parsed = double.tryParse(value.replaceAll(',', ''));
    if (parsed == null) {
      return AppLocalizations.of(context)!.pleaseEnterValidAmount;
    }
    if (parsed <= minAmount) {
      return AppLocalizations.of(
        context,
      )!.amountMustBeGreaterThan(minAmount.toStringAsFixed(2));
    }
    return null;
  }

  /// Validates a zipcode.
  static String? zipcode(String? value, {required BuildContext context}) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.pleaseEnterZipcode;
    }
    // Allows 4-10 digit codes
    final zipcodeRegex = RegExp(r'^\d{4,10}$');
    if (!zipcodeRegex.hasMatch(value.trim())) {
      return AppLocalizations.of(context)!.pleaseEnterValidZipcode;
    }
    return null;
  }

  /// Validates a tax number.
  static String? taxNumber(String? value, {required BuildContext context}) {
    if (value == null || value.trim().isEmpty) return null;
    // Tax number should be 5-20 digits
    final taxRegex = RegExp(r'^\d{5,20}$');
    if (!taxRegex.hasMatch(value.trim())) {
      return AppLocalizations.of(context)!.taxNumberValidation;
    }
    return null;
  }

  /// Validates an identification number.
  static String? identificationNumber(
    String? value, {
    required BuildContext context,
  }) {
    if (value == null || value.trim().isEmpty) return null;
    // ID should be 5-20 alphanumeric characters
    final idRegex = RegExp(r'^[A-Za-z0-9]{5,20}$');
    if (!idRegex.hasMatch(value.trim())) {
      return AppLocalizations.of(context)!.identificationValidation;
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
