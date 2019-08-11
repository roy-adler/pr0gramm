import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Preferences {
  static String _usernameKey = "username";
  static String _passwordKey = "password";
  static String _cooKey = "cookey";

  static Future<String> username() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(_usernameKey);
  }

  static Future<String> saveUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_usernameKey, username);
  }

  static Future<String> password() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(_passwordKey);
  }

  static Future<String> savePassword(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_passwordKey, password);
  }

  static Future<String> cookies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(_cooKey);
  }

  static Future<String> saveCookies(String cookies) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_cooKey, cookies);
  }
}
