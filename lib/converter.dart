import 'dart:convert';

import 'package:http/http.dart';
import 'package:pr0gramm_app/data.dart';
import 'package:pr0gramm_app/pr0gramm_content.dart';
import 'package:pr0gramm_app/pr0gramm_content_container.dart';

abstract class Converter {
  static Future<Pr0grammContentContainer> getPr0grammContentContainer() async {
    Response response = await Data.makeGetRequest();
    Map<String, dynamic> parsedJson = jsonDecode(response.body);
    Pr0grammContentContainer PCC =
        Pr0grammContentContainer.fromJson(parsedJson);
    return PCC;
  }

  static Future<List<Pr0grammContent>> getPr0grammContentList() async {
    Pr0grammContentContainer PCC = await getPr0grammContentContainer();
    List<Pr0grammContent> pr0grammContentList = List<Pr0grammContent>();
    pr0grammContentList =
        PCC.items.map((i) => Pr0grammContent.fromJson(i)).toList();

    return pr0grammContentList;
  }
}
