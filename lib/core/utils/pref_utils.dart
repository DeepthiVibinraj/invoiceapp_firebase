import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesUtils {
  static SharedPreferences? _sharedPreferences;

  PreferencesUtils() {
    SharedPreferences.getInstance().then((value) {
      _sharedPreferences = value;
    });
  }

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    // print('SharedPreference Initialized');
  }

  ///will clear all the data stored in preference
  void clearPreferencesData() async {
    _sharedPreferences!.clear();
  }

  // Set all the preference value by Key and value pair - Value as String
  Future<void> setPreferenceData(String prfKey, String prefValue) {
    return _sharedPreferences!.setString(prfKey, prefValue);
  }

  Map<String, dynamic> getPreferenceData(
    String prfKey,
  ) {
    // print("GET PREF==>");
    // print("GET PREF==prfKey>$prfKey");
    try {
      String? jsonStr = _sharedPreferences!.getString(prfKey);
      // print("GET PREF==>$jsonStr");
      if (jsonStr!.isNotEmpty) {
        // print("GET PREF= NEXT=>$jsonStr");
        Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
        // print("Decoded JSON:");
        print(jsonMap);
        return jsonMap;
      }
    } catch (e) {
      // print("Error decoding JSON: $e");
      return {};
    }

    // Return an empty map as a default
    return {};
  }

  Future<void> setAppLanguage(String newLanguage) async {
    // print("SET PREFERENCE Language val => $newLanguage");
    await _sharedPreferences!.setString('app_lang', newLanguage);
  }

  Future<String> getAppLanguage() async {
    return _sharedPreferences!.getString('app_lang') ?? 'en_US';
  }

  Future<void> setAppTheme(ThemeMode value) async {
    // print("SET PREFERENCE Language val => $value");
    await _sharedPreferences!.setString('app_theme', value.toString());
  }

  String getAppTheme() {
    try {
      // print("GET THEME DATA=>");
      String? themeModeString =
          _sharedPreferences!.getString('app_theme') ?? '';
      return themeModeString;
    } catch (e) {
      return '';
    }
  }

  Future<void> setAuthUser(Map<String, dynamic> userInfo) {
    // print("SET AUTH USER val=>$userInfo");
    _sharedPreferences!.setBool('isLoggedIn', true);
    return _sharedPreferences!.setString('auth_user', json.encode(userInfo));
  }

  String getAuthUser() {
    try {
      // print("GET AUTH USER=>");
      return _sharedPreferences!.getString('auth_user') ?? '';
    } catch (e) {
      return '';
    }
  }

  Future<bool> isLoggedIn() async {
    return _sharedPreferences!.getBool('isLoggedIn') ?? false;
  }

  // For HospitalCode
  Future<void> setHospCode(String code) async {
    await _sharedPreferences!.setString('app_lang', code);
  }

  Future<String> getHospCode() async {
    return _sharedPreferences!.getString('app_lang') ?? 'en_US';
  }

  Future<void> clearAuthUser() {
    _sharedPreferences!.remove('isLoggedIn');
    return _sharedPreferences!.remove('auth_user');
  }

  Future<bool> clearAuthPreference() async {
    try {
      // print("clearAuthPreferenceUSER=>");
      _sharedPreferences!.remove('isLoggedIn');
      return _sharedPreferences!.remove('auth_user');
    } catch (e) {
      return false;
    }
  }
}
