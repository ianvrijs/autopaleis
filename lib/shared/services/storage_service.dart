import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<bool> saveString(String key, String value) async {
    await init();
    return _prefs!.setString(key, value);
  }

  String? getString(String key) {
    return _prefs?.getString(key);
  }

  Future<bool> saveInt(String key, int value) async {
    await init();
    return _prefs!.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  Future<bool> saveBool(String key, bool value) async {
    await init();
    return _prefs!.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  Future<bool> saveJson(String key, Map<String, dynamic> value) async {
    await init();
    return _prefs!.setString(key, jsonEncode(value));
  }

  Map<String, dynamic>? getJson(String key) {
    final jsonString = _prefs?.getString(key);
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  Future<bool> remove(String key) async {
    await init();
    return _prefs!.remove(key);
  }

  Future<bool> clear() async {
    await init();
    return _prefs!.clear();
  }

  bool containsKey(String key) {
    return _prefs?.containsKey(key) ?? false;
  }
}
