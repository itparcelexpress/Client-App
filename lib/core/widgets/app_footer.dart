import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../l10n/app_localizations.dart';

/// Footer widget that displays copyright information and app version
class AppFooter extends StatelessWidget {
  final EdgeInsets? padding;
  final Color? textColor;
  final double? fontSize;

  const AppFooter({super.key, this.padding, this.textColor, this.fontSize});

  /// Get version string asynchronously
  Future<String> _getVersionString() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return '${packageInfo.version}+${packageInfo.buildNumber}';
    } catch (e) {
      // Fallback to pubspec.yaml values if package_info_plus fails
      return '1.0.0+6';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Copyright text
          Text(
            AppLocalizations.of(context)?.copyright_text ??
                '© 2024 Parcel Express. All rights reserved.',
            style: TextStyle(
              fontSize: fontSize ?? 12.0,
              color: textColor ?? Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          // App version - using FutureBuilder for proper async handling
          FutureBuilder<String>(
            future: _getVersionString(),
            builder: (context, snapshot) {
              String versionText;
              if (snapshot.hasData) {
                versionText = snapshot.data!;
              } else {
                // Fallback version
                versionText = '1.0.0+6';
              }

              return Text(
                AppLocalizations.of(context)?.version_text(versionText) ??
                    'Version $versionText',
                style: TextStyle(
                  fontSize: (fontSize ?? 12.0) - 1.0,
                  color: textColor?.withValues(alpha: 0.8) ?? Colors.grey[500],
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Simplified footer widget for cases where BlocBuilder is not available
class SimpleAppFooter extends StatelessWidget {
  final EdgeInsets? padding;
  final Color? textColor;
  final double? fontSize;
  final String? version;

  const SimpleAppFooter({
    super.key,
    this.padding,
    this.textColor,
    this.fontSize,
    this.version,
  });

  /// Get version string asynchronously
  Future<String> _getVersionString() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return '${packageInfo.version}+${packageInfo.buildNumber}';
    } catch (e) {
      // Fallback to pubspec.yaml values if package_info_plus fails
      return '1.0.0+6';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Copyright text
          Text(
            AppLocalizations.of(context)?.copyright_text ??
                '© 2024 Parcel Express. All rights reserved.',
            style: TextStyle(
              fontSize: fontSize ?? 12.0,
              color: textColor ?? Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          // App version - using FutureBuilder for proper async handling
          FutureBuilder<String>(
            future: _getVersionString(),
            builder: (context, snapshot) {
              String versionText;
              if (snapshot.hasData) {
                versionText = snapshot.data!;
              } else {
                // Use provided version or fallback
                versionText = version ?? '1.0.0+6';
              }

              return Text(
                AppLocalizations.of(context)?.version_text(versionText) ??
                    'Version $versionText',
                style: TextStyle(
                  fontSize: (fontSize ?? 12.0) - 1.0,
                  color: textColor?.withValues(alpha: 0.8) ?? Colors.grey[500],
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              );
            },
          ),
        ],
      ),
    );
  }
}
