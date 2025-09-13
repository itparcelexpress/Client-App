import 'dart:convert';

import 'package:client_app/core/models/user_model.dart';
import 'package:client_app/injections.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalData {
  static final LocalData _instance = LocalData._internal();

  factory LocalData() => _instance;

  LocalData._internal();

  static bool loadingActive = true;

  //! Setter Functions
  static Future<bool> setString(String key, String value) async {
    return await getIt<SharedPreferences>().setString(key, value);
  }

  static Future<bool> setBool(String key, bool value) async {
    return await getIt<SharedPreferences>().setBool(key, value);
  }

  static Future<bool> remove(String key) async {
    return await getIt<SharedPreferences>().remove(key);
  }

  static Future<bool> clear() async {
    return await getIt<SharedPreferences>().clear();
  }

  //! Getter Functions
  static bool get isFirstUse {
    return getIt<SharedPreferences>().getBool(LocalKeys.isFirstUse) ?? true;
  }

  static String get token {
    return getIt<SharedPreferences>().getString(LocalKeys.token) ?? '';
  }

  static bool get isLoggedIn {
    return getIt<SharedPreferences>().getBool(LocalKeys.isLoggedIn) ?? false;
  }

  static UserModel? get user {
    final userJson = getIt<SharedPreferences>().getString(LocalKeys.user);
    if (userJson != null && userJson.isNotEmpty) {
      try {
        return UserModel.fromJson(jsonDecode(userJson));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  //! User-specific setters
  static Future<bool> setToken(String token) async {
    return await setString(LocalKeys.token, token);
  }

  static Future<bool> setIsLoggedIn(bool isLoggedIn) async {
    return await setBool(LocalKeys.isLoggedIn, isLoggedIn);
  }

  static Future<bool> setUser(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      return await setString(LocalKeys.user, userJson);
    } catch (e) {
      return false;
    }
  }

  static Future<bool> logout() async {
    try {
      // Clear all authentication-related data
      await remove(LocalKeys.token);
      await remove(LocalKeys.user);
      await setIsLoggedIn(false);

      // Optional: Clear all data for complete logout
      // await clear();

      return true;
    } catch (e) {
      // Even if some operations fail, try to clear what we can
      try {
        await remove(LocalKeys.token);
        await remove(LocalKeys.user);
        await setIsLoggedIn(false);
      } catch (_) {
        // If even the fallback fails, return false
        return false;
      }
      return true;
    }
  }

  // Method to clear all sensitive data
  static Future<bool> clearSensitiveData() async {
    try {
      await remove(LocalKeys.token);
      await remove(LocalKeys.user);
      return true;
    } catch (e) {
      return false;
    }
  }
}

class LocalKeys {
  static String isFirstUse = 'IS_FIRST_USE';
  static String token = 'TOKEN';
  static String isLoggedIn = 'IS_LOGGED_IN';
  static String user = 'USER';
}
