// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_version_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppVersionRequest _$AppVersionRequestFromJson(Map<String, dynamic> json) =>
    AppVersionRequest(
      platform: json['platform'] as String,
      app: json['app'] as String,
      current: json['current'] as String,
      build: (json['build'] as num).toInt(),
    );

Map<String, dynamic> _$AppVersionRequestToJson(AppVersionRequest instance) =>
    <String, dynamic>{
      'platform': instance.platform,
      'app': instance.app,
      'current': instance.current,
      'build': instance.build,
    };

AppVersionResponse _$AppVersionResponseFromJson(Map<String, dynamic> json) =>
    AppVersionResponse(
      platform: json['platform'] as String,
      app: json['app'] as String,
      current: json['current'] as String,
      build: (json['build'] as num).toInt(),
      minSupportedVersion: json['min_supported_version'] as String,
      minSupportedBuild: (json['min_supported_build'] as num).toInt(),
      latestVersion: json['latest_version'] as String,
      latestBuild: (json['latest_build'] as num).toInt(),
      mustUpdate: json['must_update'] as bool,
      shouldUpdate: json['should_update'] as bool,
      forceAll: json['force_all'] as bool,
      storeUrl: json['store_url'] as String?,
      changelog: json['changelog'] as String,
    );

Map<String, dynamic> _$AppVersionResponseToJson(AppVersionResponse instance) =>
    <String, dynamic>{
      'platform': instance.platform,
      'app': instance.app,
      'current': instance.current,
      'build': instance.build,
      'min_supported_version': instance.minSupportedVersion,
      'min_supported_build': instance.minSupportedBuild,
      'latest_version': instance.latestVersion,
      'latest_build': instance.latestBuild,
      'must_update': instance.mustUpdate,
      'should_update': instance.shouldUpdate,
      'force_all': instance.forceAll,
      'store_url': instance.storeUrl,
      'changelog': instance.changelog,
    };

CurrentAppVersionInfo _$CurrentAppVersionInfoFromJson(
        Map<String, dynamic> json) =>
    CurrentAppVersionInfo(
      version: json['version'] as String,
      buildNumber: json['buildNumber'] as String,
      packageName: json['packageName'] as String,
      appName: json['appName'] as String,
    );

Map<String, dynamic> _$CurrentAppVersionInfoToJson(
        CurrentAppVersionInfo instance) =>
    <String, dynamic>{
      'version': instance.version,
      'buildNumber': instance.buildNumber,
      'packageName': instance.packageName,
      'appName': instance.appName,
    };
