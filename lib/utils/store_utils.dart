
import 'package:hive_flutter/adapters.dart';

class Store {
  static bool _initialized = false;
  static late final Box _infoBox;
  static late final Box<String> _forumBox;
  static late final Box<String> _sduBox;
  static late final Box<String> _cacheBox;

  static Box<String> get forumBox => _forumBox;
  static Box<String> get sduBox => _sduBox;
  static Box<String> get cacheBox => _cacheBox;


  static Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    String? subDir = 'fisher-forum';
    await Hive.initFlutter(subDir);
    _infoBox = await Hive.openBox('info');
    _forumBox = await Hive.openBox('forum');
    _sduBox = await Hive.openBox('sdu');
    _cacheBox = await Hive.openBox('cache');
    _initialized = true;
  }

  static bool containsKey(String key) {
    return _infoBox.containsKey(key);
  }

  static String getString(String key, {String def = ""}) {
    return get<String>(key) ?? def;
  }

  static int getInt(String key, {int def = 0}) {
    return get<int>(key) ?? def;
  }

  static double getDouble(String key, {double def = 0.0}) {
    return get<double>(key) ?? def;
  }

  static bool getBool(String key, {bool def = false}) {
    return get<bool>(key) ?? def;
  }

  static List<T> getList<T>(String key, {List<T> def = const []}) {
    Iterable? l = get(key);
    if (l == null || l.isEmpty) {
      return def;
    } else {
      return l.cast<T>().toList();
    }
  }

  static Map<K, V> getMap<K, V>(String key, {Map<K, V> def = const {}}) {
    Map<String, dynamic>? map = get<Map<String, dynamic>>(key);
    if (map == null || map.isEmpty) {
      return def;
    } else {
      return map.cast<K, V>();
    }
  }

  ///能够被get的类除基本数据类型、String、List, Map, DateTime, Uint8List外
  ///必须实现hive适配器[https://docs.hivedb.dev/#/custom-objects/type_adapters]
  static T? get<T>(String key, {T? defaultValue}) {
    return _infoBox.get(key, defaultValue: defaultValue);
  }

  ///能够被set的类除基本数据类型、String、List, Map, DateTime, Uint8List外
  ///必须实现hive适配器[https://docs.hivedb.dev/#/custom-objects/type_adapters]
  static Future<void> set(String key, dynamic value) {
    return _infoBox.put(key, value);
  }

  static Future<void> putAll(Map<String, dynamic> entries) {
    return _infoBox.putAll(entries);
  }

  static Future<void> remove(String key) {
    return _infoBox.delete(key);
  }

  static Future<void> removeKeys(List<String> keys) {
    return _infoBox.deleteAll(keys);
  }

  static Future<int> removeAll() {
    return _infoBox.clear();
  }
}

// class SecureStore {
//   static const storage = FlutterSecureStorage();
//
//   static Future<String?> read(String key) async {
//     return await storage.read(key: key);
//   }
//
//   static Future<void> delete(String key) async {
//     await storage.delete(key: key);
//   }
//
//   static Future<void> write(String key, String? value) async {
//     await storage.write(key: key, value: value);
//   }
// }
