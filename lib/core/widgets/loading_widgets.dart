import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// Reusable loading widgets for consistent UX across the app
class LoadingWidgets {
  LoadingWidgets._();

  // Primary brand color for loading indicators
  static const Color _primaryColor = Color(0xFF667eea);

  /// Main loading indicator for full-screen loading states
  static Widget fullScreenLoading({
    String? message,
    Color? color,
    double? size,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitThreeBounce(color: color ?? _primaryColor, size: size ?? 30),
          if (message != null) ...[
            const SizedBox(height: 20),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Compact loading indicator for buttons and small areas
  static Widget compactLoading({Color? color, double? size}) {
    return SizedBox(
      width: size ?? 20,
      height: size ?? 20,
      child: SpinKitThreeBounce(color: color ?? Colors.white, size: size ?? 12),
    );
  }

  /// Loading indicator for list items and cards
  static Widget listLoading({Color? color, double? size}) {
    return Center(
      child: SpinKitCircle(color: color ?? _primaryColor, size: size ?? 30),
    );
  }

  /// Loading indicator for pagination (load more)
  static Widget paginationLoading({Color? color, double? size}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: SpinKitPulse(color: color ?? _primaryColor, size: size ?? 24),
      ),
    );
  }

  /// Loading indicator for splash screen
  static Widget splashLoading({Color? color, double? size}) {
    return SpinKitWanderingCubes(
      color: color ?? Colors.white,
      size: size ?? 50.0,
    );
  }

  /// Loading indicator for overlay/dialog
  static Widget overlayLoading({Color? color, double? size}) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SpinKitCircle(color: color ?? _primaryColor, size: size ?? 40),
      ),
    );
  }

  /// Loading indicator for map loading
  static Widget mapLoading({Color? color, double? size}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitFadingCircle(color: color ?? _primaryColor, size: size ?? 40),
          const SizedBox(height: 16),
          const Text(
            'Loading map...',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  /// Loading indicator for data loading with message
  static Widget dataLoading({
    required String message,
    Color? color,
    double? size,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitDualRing(color: color ?? _primaryColor, size: size ?? 40),
          const SizedBox(height: 20),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Loading indicator for button with text
  static Widget buttonLoading({
    required String text,
    Color? color,
    double? size,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size ?? 16,
          height: size ?? 16,
          child: SpinKitThreeBounce(
            color: color ?? Colors.white,
            size: size ?? 8,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
