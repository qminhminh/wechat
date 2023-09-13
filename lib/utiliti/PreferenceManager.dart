import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
class PreferenceManager {
 late SharedPreferences _sharedPreferences;

  Future<void> initialize() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  void putBoolean(String key, bool value) {
    _sharedPreferences?.setBool(key, value);
  }

  bool getBoolean(String key, {bool defaultValue = false}) {
    return _sharedPreferences?.getBool(key) ?? defaultValue;
  }

  void putString(String key, String value) {
    _sharedPreferences?.setString(key, value);
  }

  String getString(String key, {String defaultValue = ''}) {
    return _sharedPreferences?.getString(key) ?? defaultValue;
  }

  void clear() {
    _sharedPreferences?.clear();
  }
}
