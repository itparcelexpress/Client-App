import 'package:flutter/widgets.dart';

/// Centralized currency utilities to ensure OMR formatting app-wide
class CurrencyUtils {
  /// Returns the currency symbol based on locale: 'OMR' for English, 'ر.ع' for Arabic
  static String symbol(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return isArabic ? 'ر.ع' : 'OMR';
  }

  /// Formats a numeric value with 2 decimals and app currency symbol.
  /// Example: EN -> 'OMR 12.50', AR -> '12.50 ر.ع'
  static String formatWithSymbol(BuildContext context, num? value) {
    final amount = _toFixed2(value);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final sym = symbol(context);
    return isArabic ? '$amount $sym' : '$sym $amount';
  }

  /// Returns the amount normalized to two decimals as string
  static String _toFixed2(num? value) {
    final v = value ?? 0;
    return v.toStringAsFixed(2);
  }
}
