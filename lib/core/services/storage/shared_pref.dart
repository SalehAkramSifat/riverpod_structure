import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  SharedPreferences? _prefs;
  final Completer<SharedPreferences> _initCompleter = Completer<SharedPreferences>();

  SharedPref() {
    _initCompleter.complete(SharedPreferences.getInstance());
  }

  Future<SharedPreferences> get _instance async =>
      _prefs ??= await _initCompleter.future;

  Future<bool> set(String key, String value) async =>
      (await _instance).setString(key, value);

  Future<Object?> get(String key) async => (await _instance).get(key);

  Future<String?> getString(String key) async =>
      (await _instance).getString(key);

  Future<bool> setBool(String key, bool value) async =>
      (await _instance).setBool(key, value);

  Future<bool?> getBool(String key) async =>
      (await _instance).getBool(key);

  Future<bool> has(String key) async =>
      (await _instance).containsKey(key);

  Future<bool> remove(String key) async =>
      (await _instance).remove(key);

  Future<bool> clear() async =>
      (await _instance).clear();
}

typedef SharedPrefImplementation = SharedPref;
