import 'dart:convert';

import 'package:http/http.dart';
import 'package:pr0gramm_app/content/pr0gramm_comment.dart';
import 'package:pr0gramm_app/content/pr0gramm_content.dart';
import 'package:pr0gramm_app/content/pr0gramm_content_container.dart';
import 'package:pr0gramm_app/api/request_response_handler.dart';
import 'package:pr0gramm_app/content/pr0gramm_info.dart';
import 'package:pr0gramm_app/content/pr0gramm_login.dart';
import 'package:pr0gramm_app/content/pr0gramm_tag.dart';

abstract class ResponseParser {
  static RequestResponseHandler RRH = RequestResponseHandler();
  //Content
  static Future<Pr0grammContentContainer> getPr0grammContentContainer() async {
    Response response = await RRH.itemsGet();
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

  //Info
  static Future<Pr0grammInfo> getPr0grammInfo(int itemID) async {
    itemID = 680;
    Response response = await RRH.itemsInfo(itemID);
    Map<String, dynamic> parsedJson = jsonDecode(response.body);

    Pr0grammInfo PI = Pr0grammInfo.fromJson(parsedJson);
    return PI;
  }

  static getTags(Pr0grammInfo PI) async {
    List<Pr0grammTag> pr0grammTagList = List<Pr0grammTag>();
    pr0grammTagList = PI.tags.map((i) => Pr0grammTag.fromJson(i)).toList();
    return pr0grammTagList;
  }

  static getComments(Pr0grammInfo PI) async {
    List<Pr0grammComment> pr0grammCommentList = List<Pr0grammComment>();
    pr0grammCommentList =
        PI.comments.map((i) => Pr0grammComment.fromJson(i)).toList();
    return pr0grammCommentList;
  }

  //Login
  static Future<Pr0grammLogin> getPr0grammLogin() async {
    Response response = await RRH.login();
    Map<String, dynamic> parsedJson = jsonDecode(response.body);
    Pr0grammLogin PL = Pr0grammLogin.fromJson(parsedJson);
    return PL;
  }
}
