import 'debug.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Preferences {
  static String _usernameKey = "username";
  static String _passwordKey = "password";
  static String _cooKey = "cookey";
  static String _tag = "tag";
  static String _muted = "muted";

  //tag
  static Future<String> tag() async {
    return await _read(_tag);
  }

  static Future<void> saveTag(String tag) async {
    await _save(_tag, tag);
  }

  //muted
  static Future<bool> muted() async {
    return (await _read(_muted)) == 'true';
  }

  static Future<void> saveMuted(bool muted) async {
    await _save(_muted, muted.toString());
  }

  //Username
  static Future<String> username() async {
    return await _read(_usernameKey);
  }

  static Future<void> saveUsername(String username) async {
    await _save(_usernameKey, username);
  }

  // Password
  static Future<String> password() async {
    return await _read(_passwordKey);
  }

  static Future<void> savePassword(String password) async {
    await _save(_passwordKey, password);
  }

  // Cookies
  static Future<String> cookies() async {
    return await _read(_cooKey);
  }

  static Future<void> saveCookies(String cookies) async {
    await _save(_cooKey, cookies);
  }

  // General Data
  static Future<void> _save(String key, String value) async {
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
