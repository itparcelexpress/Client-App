import 'package:json_annotation/json_annotation.dart';

part 'app_version_models.g.dart';

/// Request model for checking app version
@JsonSerializable()
class AppVersionRequest {
  final String platform;
  final String app;
  final String current;
  final int build;

  const AppVersionRequest({
    required this.platform,
    required this.app,
    required this.current,
    required this.build,
  });

  factory AppVersionRequest.fromJson(Map<String, dynamic> json) =>
      _$AppVersionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AppVersionRequestToJson(this);

  @override
  String toString() {
    return 'AppVersionRequest(platform: $platform, app: $app, current: $current, build: $build)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppVersionRequest &&
        other.platform == platform &&
        other.app == app &&
        other.current == current &&
        other.build == build;
  }

  @override
  int get hashCode {
    return platform.hashCode ^ app.hashCode ^ current.hashCode ^ build.hashCode;
  }
}

/// Response model from server for app version check
@JsonSerializable()
class AppVersionResponse {
  final String platform;
  final String app;
  final String current;
  final int build;
  @JsonKey(name: 'min_supported_version')
  final String minSupportedVersion;
  @JsonKey(name: 'min_supported_build')
  final int minSupportedBuild;
  @JsonKey(name: 'latest_version')
  final String latestVersion;
  @JsonKey(name: 'latest_build')
  final int latestBuild;
  @JsonKey(name: 'must_update')
  final bool mustUpdate;
  @JsonKey(name: 'should_update')
  final bool shouldUpdate;
  @JsonKey(name: 'force_all')
  final bool forceAll;
  @JsonKey(name: 'store_url')
  final String? storeUrl;
  final String changelog;

  const AppVersionResponse({
    required this.platform,
    required this.app,
    required this.current,
    required this.build,
    required this.minSupportedVersion,
    required this.minSupportedBuild,
    required this.latestVersion,
    required this.latestBuild,
    required this.mustUpdate,
    required this.shouldUpdate,
    required this.forceAll,
    this.storeUrl,
    required this.changelog,
  });

  factory AppVersionResponse.fromJson(Map<String, dynamic> json) =>
      _$AppVersionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AppVersionResponseToJson(this);

  /// Check if update is forced (must update or force all)
  bool get isUpdateForced => mustUpdate || forceAll;

  /// Check if update is available (should update or must update)
  bool get isUpdateAvailable => shouldUpdate || mustUpdate;

  /// Check if current version is outdated compared to minimum supported
  bool get isCurrentVersionOutdated {
    return _compareVersions(current, minSupportedVersion) < 0 ||
        build < minSupportedBuild;
  }

  /// Compare two version strings (returns -1, 0, or 1)
  int _compareVersions(String version1, String version2) {
    final v1Parts = version1.split('.').map(int.parse).toList();
    final v2Parts = version2.split('.').map(int.parse).toList();

    // Pad with zeros if versions have different number of parts
    while (v1Parts.length < v2Parts.length) v1Parts.add(0);
    while (v2Parts.length < v1Parts.length) v2Parts.add(0);

    for (int i = 0; i < v1Parts.length; i++) {
      if (v1Parts[i] < v2Parts[i]) return -1;
      if (v1Parts[i] > v2Parts[i]) return 1;
    }
    return 0;
  }

  @override
  String toString() {
    return 'AppVersionResponse(platform: $platform, app: $app, current: $current, build: $build, minSupportedVersion: $minSupportedVersion, minSupportedBuild: $minSupportedBuild, latestVersion: $latestVersion, latestBuild: $latestBuild, mustUpdate: $mustUpdate, shouldUpdate: $shouldUpdate, forceAll: $forceAll, storeUrl: $storeUrl, changelog: $changelog)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppVersionResponse &&
        other.platform == platform &&
        other.app == app &&
        other.current == current &&
        other.build == build &&
        other.minSupportedVersion == minSupportedVersion &&
        other.minSupportedBuild == minSupportedBuild &&
        other.latestVersion == latestVersion &&
        other.latestBuild == latestBuild &&
        other.mustUpdate == mustUpdate &&
        other.shouldUpdate == shouldUpdate &&
        other.forceAll == forceAll &&
        other.storeUrl == storeUrl &&
        other.changelog == changelog;
  }

  @override
  int get hashCode {
    return platform.hashCode ^
        app.hashCode ^
        current.hashCode ^
        build.hashCode ^
        minSupportedVersion.hashCode ^
        minSupportedBuild.hashCode ^
        latestVersion.hashCode ^
        latestBuild.hashCode ^
        mustUpdate.hashCode ^
        shouldUpdate.hashCode ^
        forceAll.hashCode ^
        storeUrl.hashCode ^
        changelog.hashCode;
  }
}

/// Current app version info from package_info_plus
@JsonSerializable()
class CurrentAppVersionInfo {
  final String version;
  final String buildNumber;
  final String packageName;
  final String appName;

  const CurrentAppVersionInfo({
    required this.version,
    required this.buildNumber,
    required this.packageName,
    required this.appName,
  });

  factory CurrentAppVersionInfo.fromJson(Map<String, dynamic> json) =>
      _$CurrentAppVersionInfoFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentAppVersionInfoToJson(this);

  /// Convert build number to int
  int get buildNumberAsInt {
    try {
      return int.parse(buildNumber);
    } catch (e) {
      return 0;
    }
  }

  @override
  String toString() {
    return 'CurrentAppVersionInfo(version: $version, buildNumber: $buildNumber, packageName: $packageName, appName: $appName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CurrentAppVersionInfo &&
        other.version == version &&
        other.buildNumber == buildNumber &&
        other.packageName == packageName &&
        other.appName == appName;
  }

  @override
  int get hashCode {
    return version.hashCode ^
        buildNumber.hashCode ^
        packageName.hashCode ^
        appName.hashCode;
  }
}
