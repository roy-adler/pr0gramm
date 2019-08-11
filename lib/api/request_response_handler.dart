import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pr0gramm_app/api/preferences.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class RequestResponseHandler {
  static String pr0Api = "https://pr0gramm.com/api";
  Map<String, String> headers = {};

  String paramsMaker(List<String> stringList) {
    String retString = "?";
    for (int index = 0; index < stringList.length; index++) {
      retString += stringList[index] + '&';
    }
    return retString.substring(0, retString.length - 1);
  }

  Future<http.Response> itemsGet(
      {int promotedNum = 1, int flagsNum = 9}) async {
    List<String> paramList = [];
    String promoted = "promoted=" + promotedNum.toString();
    String flags = "flags=" + flagsNum.toString();
    paramList.add(flags);
    paramList.add(promoted);
    String req = paramsMaker(paramList);
    return get(url: "/items/get${req}");
  }

  Future<http.Response> itemsInfo(int num) async {
    return get(url: "/items/info?itemId=" + num.toString());
  }

  Future<http.Response> login(String name, String password) async {
    print("Login");
    return await updateCookie(await http.post(
      'https://pr0gramm.com/api/user/login',
      headers: headers,
      body: {'name': name, 'password': password},
    ));
  }

  Future<http.Response> isLoggedIn() async {
    return get(url: "/user/loggedin");
  }

  Future<http.Response> get({String url}) {
    String request = pr0Api + url;
    print(request);
    return http.get(request, headers: headers);
  }

  setCookie(String cookies) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    headers['Cookie'] = cookies;
    Preferences.saveCookies(cookies);
  }

  http.Response updateCookie(http.Response response) {
    String rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      var strings = rawCookie.split(",");
      String addCookie = "";
      for (int i = 0; i < strings.length; i++) {
        if (strings[i].contains("me") ||
            strings[i].contains("pp") ||
            strings[i].contains("__cfduid")) {
          addCookie += strings[i].split(";").first + ";";
        }
      }
      addCookie = addCookie.substring(0, addCookie.length - 1);
      setCookie(addCookie);
    }
    return response;
  }
}
