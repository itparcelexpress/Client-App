/// Utility class for formatting numbers consistently throughout the app
class NumberFormatter {
  /// Formats a double or string number to display exactly two decimal places
  /// Returns '0.00' if the input is null or can't be parsed as a number
  static String formatCurrency(dynamic value) {
    if (value == null) {
      return '0.00';
    }

    double? numValue;

    if (value is double) {
      numValue = value;
    } else if (value is int) {
      numValue = value.toDouble();
    } else if (value is String) {
      numValue = double.tryParse(value);
    }

    return numValue?.toStringAsFixed(2) ?? '0.00';
  }

  /// Adds two currency values (as strings or numbers) and returns the formatted result
  static String addCurrency(dynamic value1, dynamic value2) {
    double val1 = double.tryParse(value1?.toString() ?? '0') ?? 0;
    double val2 = double.tryParse(value2?.toString() ?? '0') ?? 0;

    return (val1 + val2).toStringAsFixed(2);
  }
}
