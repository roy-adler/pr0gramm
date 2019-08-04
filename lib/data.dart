import 'package:http/http.dart';

abstract class Data {
  static Future<Response> makeGetRequest() async {
    Response response = await get("https://pr0gramm.com/api/items/get");
    return response;
  }
}
