import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class JDCache {
  static JDCache? _singleton;
  static SharedPreferences? _prefs;

  static Future<JDCache?> getInstance() async {
    if (_singleton == null) {
      var singleton = JDCache._();
      await singleton._init();
      _singleton = singleton;
    }
    return _singleton;
  }

  JDCache._();

  Future _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// put object.
  static Future<bool>? putObject(String key, Object value) {
    return _prefs?.setString(key, json.encode(value));
  }

  /// get object.
  static Map? getObject(String key) {
    String? data = _prefs?.getString(key);
    return (data == null || data.isEmpty) ? null : json.decode(data);
  }

  /// put object list.
  static Future<bool>? putObjectList(String key, List<Object> list) {
    List<String>? dataList = list.map((value) {
      return json.encode(value);
    }).toList();
    return _prefs?.setStringList(key, dataList);
  }

  /// get object list.
  static List<Map>? getObjectList(String key) {
    List<String>? dataLis = _prefs?.getStringList(key);
    return dataLis?.map((value) {
      Map dataMap = json.decode(value);
      return dataMap;
    }).toList();
  }

  /// get string.
  static String? getString(String key, {String? defValue = ''}) {
    return _prefs?.getString(key) ?? defValue;
  }

  /// put string.
  static Future<bool>? setString(String key, String value) {
    return _prefs?.setString(key, value);
  }

  /// get bool.
  static bool? getBool(String key, {bool? defValue = false}) {
    return _prefs?.getBool(key) ?? defValue;
  }

  /// put bool.
  static Future<bool>? setBool(String key, bool value) {
    return _prefs?.setBool(key, value);
  }

  /// get int.
  static int? getInt(String key, {int? defValue = 0}) {
    return _prefs?.getInt(key) ?? defValue;
  }

  /// put int.
  static Future<bool>? setInt(String key, int value) {
    return _prefs?.setInt(key, value);
  }

  /// get double.
  static double? getDouble(String key, {double? defValue = 0.0}) {
    return _prefs?.getDouble(key) ?? defValue;
  }

  /// put double.
  static Future<bool>? setDouble(String key, double value) {
    return _prefs?.setDouble(key, value);
  }

  /// get string list.
  static List<String>? getStringList(String key,
      {List<String>? defValue = const []}) {
    return _prefs?.getStringList(key) ?? defValue;
  }

  /// put string list.
  static Future<bool>? setStringList(String key, List<String> value) {
    return _prefs?.setStringList(key, value);
  }

  /// get dynamic.
  static dynamic getDynamic(String key, {Object? defValue}) {
    return _prefs?.get(key) ?? defValue;
  }

  /// have key.
  static bool? haveKey(String key) {
    return _prefs?.getKeys().contains(key);
  }

  /// contains Key.
  static bool? containsKey(String key) {
    return _prefs?.containsKey(key);
  }

  /// get keys.
  static Set<String>? getKeys() {
    return _prefs?.getKeys();
  }

  /// remove.
  static Future<bool>? remove(String key) {
    return _prefs?.remove(key);
  }

  /// clear.
  static Future<bool>? clear() {
    return _prefs?.clear();
  }

  /// Fetches the latest values from the host platform.
  static Future<void>? reload() {
    return _prefs?.reload();
  }

  ///Sp is initialized.
  static bool isInitialized() {
    return _prefs != null;
  }

  /// get Sp.
  static SharedPreferences? getSp() {
    return _prefs;
  }

  //删除某些前缀key的缓存
  static deleteCacheWithPrefix(String prefix) {
    if (prefix.isEmpty) {
      return;
    }
    _prefs?.getKeys().where((element) {
      return element.startsWith(prefix);
    }).forEach((element) {
      _prefs?.remove(element);
    });
  }
}
