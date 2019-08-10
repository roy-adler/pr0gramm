import 'dart:convert';
import 'package:http/http.dart';
import 'dart:async';

class RequestResponseHandler {

  static String pr0Api = "https://pr0gramm.com/api";
  Map<String, String> headers = {};

  Future<Response> itemsGet() async {
    print("\n\nitemsGet");
    return updateCookie(await get(
      pr0Api + "/items/get",
      headers: headers,
    ));
  }

  Future<Response> itemsInfo(int num) async {
    print("\n\nitemsInfo");
    var a = updateCookie(await get(
      pr0Api + "/items/info?itemId=" + num.toString(),
      headers: headers,
    ));
    print(jsonDecode(a.body));
    return a;
  }

  Future<Response> login() async {
    print("\n\nLogin");
    String name = "Stroboy";
    String password = "a55ed20e2";

    return updateCookie(await post(
      'https://pr0gramm.com/api/user/login',
      headers:headers,
      body: {'name': name, 'password': password},
    ));
  }

  Response updateCookie(Response response) {
    print("\n  Header:");
    print(response.headers);
    String rawCookie = response.headers['set-cookie'];
    print("\n  Cookies: ${response.headers['set-cookie']}");
    if (rawCookie != null) {
      headers['cookie'] = rawCookie;
    }
    return response;
  }
}
