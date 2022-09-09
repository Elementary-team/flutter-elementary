import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  final _prefs = SharedPreferences.getInstance();

  Future<List<String>?> get(String key) async {
    final instance = await _prefs;

    final result = instance.getStringList(key);

    return result;
  }

  Future<void> set(String key, List<String> value) async {
    final instance = await _prefs;

    await instance.setStringList(key, value);
  }

  Future<void> clear(String key) async {
    final instance = await _prefs;
    final emptyList = <String>[];

    await instance.setStringList(key, emptyList);
  }
}
