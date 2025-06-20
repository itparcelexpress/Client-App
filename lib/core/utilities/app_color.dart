import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primaryColor = Color(0xFF0044AA);
  static const Color primary2Color = Color(0xFF008FD1);
  static const Color secondryColor = Color(0xFFFF8C00);
  static const Color titleTextColor = Color(0xFF1B293D);
  static const Color greyColor = Color(0xFFECEEF5);

  // New colors
  static const Color surfaceColor = Color(0xFFFAFAFA);
  static const Color cardColor = Colors.white;
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFFA000);
  static const Color errorColor = Color(0xFFE53935);
  static const Color textPrimaryColor = Color(0xFF2C3E50);
  static const Color textSecondaryColor = Color(0xFF718093);
  static const Color dividerColor = Color(0xFFE0E0E0);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary2Color, primaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondryColor, Color(0xFFFF6B00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
