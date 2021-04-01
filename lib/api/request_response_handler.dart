import 'package:http/http.dart' as http;
import 'dart:async';
import 'debug.dart';
import 'preferences.dart';

class RequestResponseHandler {
  static const String pr0Api = 'pr0gramm.com';
  Map<String, String> headers = {};

  String paramsMaker(List<String> stringList) {
    String retString = "?";
    for (int index = 0; index < stringList.length; index++) {
      retString += stringList[index] + '&';
    }
    return retString.substring(0, retString.length - 1);
  }

  Future<http.Response> userInfo({String user}) async {
    Map<String, dynamic> queryParameters = {'name': user};
    return get(url: "/items/info", queryParameters: queryParameters);
  }

  Future<http.Response> itemsGetWithoutPermission() async {
    return get(url: "/items/get");
  }

  Future<http.Response> itemsGet(
      {int promotedNum,
      int flagsNum,
      String tag,
      String user,
      String collection,
      String self}) async {
    Map<String, dynamic> queryParameters = {'flags': flagsNum.toString()};

    if (tag != null) {
      queryParameters['tags'] = tag;
    }

    if (promotedNum != null) {
      queryParameters['promoted'] = promotedNum.toString();
    }

    if (user != null) {
      queryParameters['user'] = user;
    }

    if (collection != null) {
      queryParameters['collection'] = collection;
    }

    if (self != null) {
      queryParameters['self'] = self;
    }

    return get(url: "/items/get", queryParameters: queryParameters);
  }

  Future<http.Response> itemsInfo(int num) async {
    Map<String, dynamic> queryParameters = {'itemId': num.toString()};
    return get(url: "/items/info", queryParameters: queryParameters);
  }

  Future<http.Response> login(
    String name,
    String password,
    String captcha,
    String token,
  ) async {
    print("Login");
    print("name: $name");
    print("password: $password");
    print("captcha: $captcha");
    print("token: $token");
    Uri uri = new Uri.https(
        'pr0gramm.com', 'api/user/login'); // TODO: Check ob das geht
    http.Response loginResponse = await http.post(
      uri,
      headers: headers,
      body: {
        'name': name,
        'password': password,
        'captcha': captcha,
        'token': token
      },
    );
    return updateCookie(loginResponse);
  }

  Future<http.Response> logout() async {
    if (internetDEBUG) {
      print("Logout");
    }
    return get(url: "/user/logout");
  }

  Future<http.Response> isLoggedIn() async {
    if (internetDEBUG) {
      print("IsLoggedIn");
    }
    return get(url: "/user/loggedin");
  }

  Future<http.Response> captcha() async {
    return get(url: "/user/captcha");
  }

  Future<http.Response> get(
      {String url, Map<String, dynamic> queryParameters}) async {
    Uri uri = Uri.https(pr0Api, 'api' + url, queryParameters);

    // var responsecomments = await http
    //     .get(Uri.https('pr0gramm.com', 'api/items/info', queryParameters));
    // debugPrint('Response JSON is: ${responsecomments.body}');
    // var url = Uri.https('www.pr0gramm.com', '/api/items/get');

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      return response;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }

  setCookie(String cookies) async {
    if (internetDEBUG) {
      print("Setting new cookie..");
    }
    Preferences.saveCookies(cookies);
    headers['Cookie'] = cookies;
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
