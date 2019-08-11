import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class RequestResponseHandler {
  static String pr0Api = "https://pr0gramm.com/api";
  Map<String, String> headers = {};

  Future<http.Response> itemsGet() async {
    print("\n\nitemsGet");
    return updateCookie(await http.get(
      pr0Api + "/items/get",
      headers: headers,
    ));
  }

  Future<http.Response> itemsInfo(int num) async {
    print("\n\nitemsInfo");
    var a = updateCookie(await http.get(
      pr0Api + "/items/info?itemId=" + num.toString(),
      headers: headers,
    ));
    print(jsonDecode(a.body));
    return a;
  }

  Future<http.Response> login(String name, String password) async {
    print("\n\nLogin");


    return updateCookie(await http.post(
      'https://pr0gramm.com/api/user/login',
      headers: headers,
      body: {'name': name, 'password': password},
    ));
  }

  Future<http.Response> isLoggedIn() async {
    return get(url: "/user/loggedin");
  }

  Future<http.Response> get({String url}) {
    return http.get(pr0Api + url, headers: headers);
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
      headers['Cookie'] = addCookie;
      isLoggedIn();
    }
    return response;
  }
}
