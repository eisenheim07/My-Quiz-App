import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  final SharedPreferences preffs;

  PreferenceManager(this.preffs);

  putString(String key, String value) {
    preffs.setString(key, value);
  }

  String? getString(String key) {
    return preffs.getString(key);
  }

  putBoolean(String key, bool value) {
    preffs.setBool(key, value);
  }

  bool? getBool(String key) {
    return preffs.getBool(key);
  }

  clear() async {
    return await preffs.clear();
  }
}
