import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences sharedPreferences;
  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<void> setString(String key, String value) async {
    await sharedPreferences.setString(key, value);
  }

  static Future<String> getString(String key) async {
    return sharedPreferences.getString(key) ?? "";
  }

  static Future<void> removeString(String key) async {
    await sharedPreferences.remove(key);
  }

  static Future<bool> containsKey(String key) async {
    return sharedPreferences.containsKey(key);
  }

  static Future<void> clear() async {
    await sharedPreferences.clear();
  }

}
