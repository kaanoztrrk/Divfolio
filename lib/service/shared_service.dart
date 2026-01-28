// ignore_for_file: avoid_print

import 'package:shared_preferences/shared_preferences.dart';

/// A singleton service for managing SharedPreferences storage.
///
/// Provides centralized methods to save, read, and delete key-value pairs.
/// Includes logging for easier debugging.
class SharedService {
  // -------------------- Singleton Setup --------------------
  static final SharedService _instance = SharedService._internal();

  factory SharedService() => _instance;

  SharedService._internal();

  SharedPreferences? _prefs;

  /// Initialize SharedPreferences instance (call once at app startup)
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    print("✅ SharedService initialized");
  }

  // -------------------- SET Methods --------------------
  Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
    print("💾 Saved [String] $key = $value");
  }

  Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
    print("💾 Saved [Bool] $key = $value");
  }

  Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(key, value);
    print("💾 Saved [Int] $key = $value");
  }

  Future<void> setDouble(String key, double value) async {
    await _prefs?.setDouble(key, value);
    print("💾 Saved [Double] $key = $value");
  }

  // -------------------- GET Methods --------------------
  String? getString(String key) {
    final value = _prefs?.getString(key);
    print("📦 Read [String] $key = $value");
    return value;
  }

  bool? getBool(String key) {
    final value = _prefs?.getBool(key);
    print("📦 Read [Bool] $key = $value");
    return value;
  }

  int? getInt(String key) {
    final value = _prefs?.getInt(key);
    print("📦 Read [Int] $key = $value");
    return value;
  }

  double? getDouble(String key) {
    final value = _prefs?.getDouble(key);
    print("📦 Read [Double] $key = $value");
    return value;
  }

  // -------------------- REMOVE Methods --------------------
  Future<void> remove(String key) async {
    await _prefs?.remove(key);
    print("🗑️ Removed key: $key");
  }

  Future<void> clear() async {
    await _prefs?.clear();
    print("🗑️ Cleared all SharedPreferences data");
  }
}
