import 'package:http/http.dart';
import 'dart:async';

abstract class RequestResponseHandler {
  static String pr0Api = "https://pr0gramm.com/api";

  static Future<Response> itemsGet() async {
    return get(pr0Api + "/items/get");
  }

  static Future<Response> itemsInfo(int num) async {
    return get(pr0Api + "/items/info?itemId=" + num.toString());
  }

  static Future<Response> login() async {
    String name = "Stroboy";
    String password = "a55ed20e2";
    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "User-Agent": "PostmanRuntime/7.15.2",
      "Accept": "*/*",
      "Cache-Control": "no-cache",
      "Postman-Token":
          "99bf0556-9d35-44d8-9975-931f574000aa,e09af054-e57d-40de-af63-83608557db59",
      "Host": "pr0gramm.com",
      "Cookie": "__cfduid=d791c5f2339a971ba3283120eefe85abe1565024459",
      "Accept-Encoding": "gzip, deflate",
      "Content-Length": "51",
      "Connection": "keep-alive",
      "cache-control": "no-cache",
    };

    return post(
      'https://pr0gramm.com/api/user/login',
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {'name': name, 'password': password},
    );
  }
}
