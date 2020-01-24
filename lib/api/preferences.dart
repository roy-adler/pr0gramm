import 'package:pr0gramm_app/api/debug.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Preferences {
  static String _usernameKey = "username";
  static String _passwordKey = "password";
  static String _cooKey = "cookey";

  //Username
  static Future<String> username() async {
    return await _read(_usernameKey);
  }

  static void saveUsername(String username) async {
    _save(_usernameKey, username);
  }

  // Password
  static Future<String> password() async {
    return await _read(_passwordKey);
  }

  static void savePassword(String password) async {
    _save(_passwordKey, password);
  }

  // Cookies
  static Future<String> cookies() async {
    return await _read(_cooKey);
  }

  static void saveCookies(String cookies) async {
    _save(_cooKey, cookies);
  }

  // General Data
  static _save(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
    if (saveDEBUG) {
      print("SAVE Key: [$key], value: [$value]");
    }
  }

  static _read(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = prefs.get(key);
    if (readDEBUG) {
      print("READ Key: [$key], value: [$value]");
    }
    return value;
  }
}
