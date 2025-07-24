import 'package:animate_do/animate_do.dart';
import 'package:client_app/core/utilities/responsive_utils.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  // Helper method for consistent system fonts
  TextStyle _systemFont({
    required double fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade400,
              Colors.blue.shade600,
              Colors.purple.shade400,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BounceInDown(
                  duration: const Duration(milliseconds: 1000),
                  child: Container(
                    height: ResponsiveUtils.getResponsiveHeight(context, 150),
                    width: ResponsiveUtils.getResponsiveWidth(context, 150),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade400, Colors.purple.shade400],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.local_shipping,
                      size: ResponsiveUtils.getResponsiveWidth(context, 75),
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: ResponsiveUtils.getResponsivePadding(context, 30),
                ),
                BounceInUp(
                  duration: const Duration(milliseconds: 1000),
                  delay: const Duration(milliseconds: 500),
                  child: Text(
                    AppLocalizations.of(context)!.appTitle,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(
                        context,
                        32,
                      ),
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                SizedBox(
                  height: ResponsiveUtils.getResponsivePadding(context, 10),
                ),
                FadeInUp(
                  duration: const Duration(milliseconds: 800),
                  delay: const Duration(milliseconds: 1000),
                  child: Text(
                    AppLocalizations.of(context)!.tagline,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(
                        context,
                        16,
                      ),
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                const SizedBox(height: 60),

                // Loading Indicator
                SpinKitWanderingCubes(color: Colors.white, size: 50.0),

                const SizedBox(height: 20),

                // Loading Text
                Text(
                  AppLocalizations.of(context)!.loading,
                  style: _systemFont(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
