import 'package:flutter/material.dart';

class ResponsiveUtils {
  static bool isSmallScreen(BuildContext context) =>
      MediaQuery.of(context).size.width < 360;

  static bool isMediumScreen(BuildContext context) =>
      MediaQuery.of(context).size.width >= 360 &&
      MediaQuery.of(context).size.width < 768;

  static bool isLargeScreen(BuildContext context) =>
      MediaQuery.of(context).size.width >= 768;

  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    if (isSmallScreen(context)) {
      return baseSize * 0.85;
    } else if (isMediumScreen(context)) {
      return baseSize;
    } else {
      return baseSize * 1.1;
    }
  }

  static double getResponsivePadding(BuildContext context, double basePadding) {
    if (isSmallScreen(context)) {
      return basePadding * 0.7;
    } else if (isMediumScreen(context)) {
      return basePadding;
    } else {
      return basePadding * 1.2;
    }
  }

  static double getResponsiveHeight(BuildContext context, double baseHeight) {
    final screenHeight = MediaQuery.of(context).size.height;
    if (screenHeight < 600) {
      return baseHeight * 0.8;
    } else if (screenHeight < 800) {
      return baseHeight;
    } else {
      return baseHeight * 1.1;
    }
  }

  static double getResponsiveWidth(BuildContext context, double baseWidth) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseWidth * 0.8;
    } else if (screenWidth < 768) {
      return baseWidth;
    } else {
      return baseWidth * 1.2;
    }
  }

  static EdgeInsets getResponsiveMargin(
    BuildContext context,
    EdgeInsets baseMargin,
  ) {
    final multiplier = isSmallScreen(context) ? 0.7 : 1.0;
    return EdgeInsets.only(
      left: baseMargin.left * multiplier,
      top: baseMargin.top * multiplier,
      right: baseMargin.right * multiplier,
      bottom: baseMargin.bottom * multiplier,
    );
  }

  static EdgeInsets getResponsivePaddingEdgeInsets(
    BuildContext context,
    EdgeInsets basePadding,
  ) {
    final multiplier = isSmallScreen(context) ? 0.7 : 1.0;
    return EdgeInsets.only(
      left: basePadding.left * multiplier,
      top: basePadding.top * multiplier,
      right: basePadding.right * multiplier,
      bottom: basePadding.bottom * multiplier,
    );
  }

  static double getScreenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;
  static double getScreenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double getSafeAreaHeight(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom;
  }
}
