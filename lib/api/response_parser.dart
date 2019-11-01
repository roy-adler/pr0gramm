import 'dart:convert';

import 'package:http/http.dart';
import 'package:pr0gramm_app/content/captchaContainer.dart';
import 'package:pr0gramm_app/content/is_loggedIn.dart';
import 'package:pr0gramm_app/content/pr0gramm_comment.dart';
import 'package:pr0gramm_app/content/pr0gramm_content.dart';
import 'package:pr0gramm_app/content/pr0gramm_content_container.dart';
import 'package:pr0gramm_app/api/request_response_handler.dart';
import 'package:pr0gramm_app/content/pr0gramm_info.dart';
import 'package:pr0gramm_app/content/pr0gramm_login.dart';
import 'package:pr0gramm_app/content/pr0gramm_tag.dart';

abstract class ResponseParser {
  static RequestResponseHandler rrh = RequestResponseHandler();

  //Content
  static Future<Pr0grammContentContainer> getPr0grammContentContainer(
      int promoted, int flags) async {
    Response response =
        await rrh.itemsGet(promotedNum: promoted, flagsNum: flags);
    Map<String, dynamic> parsedJson = jsonDecode(response.body);
    Pr0grammContentContainer pr0grammContentContainer =
        Pr0grammContentContainer.fromJson(parsedJson);
    return pr0grammContentContainer;
  }

  static Future<List<Pr0grammContent>> getPr0grammContentList(
      int promoted, int flags) async {
    Pr0grammContentContainer pr0grammContentContainer =
        await getPr0grammContentContainer(promoted, flags);
    List<Pr0grammContent> pr0grammContentList = List<Pr0grammContent>();
    pr0grammContentList = pr0grammContentContainer.items
        .map((i) => Pr0grammContent.fromJson(i))
        .toList();
    return pr0grammContentList;
  }

  //Info
  static Future<Pr0grammInfo> getPr0grammInfo(int itemID) async {
    // itemID = 680;
    Response response = await rrh.itemsInfo(itemID);
    Map<String, dynamic> parsedJson = jsonDecode(response.body);

    Pr0grammInfo pr0grammInfo = Pr0grammInfo.fromJson(parsedJson);
    return pr0grammInfo;
  }

  static getTags(Pr0grammInfo pr0grammInfo) async {
    List<Pr0grammTag> pr0grammTagList = List<Pr0grammTag>();
    pr0grammTagList =
        pr0grammInfo.tags.map((i) => Pr0grammTag.fromJson(i)).toList();
    return pr0grammTagList;
  }

  static getComments(Pr0grammInfo pr0grammInfo) async {
    List<Pr0grammComment> pr0grammCommentList = List<Pr0grammComment>();
    pr0grammCommentList =
        pr0grammInfo.comments.map((i) => Pr0grammComment.fromJson(i)).toList();
    return pr0grammCommentList;
  }

  //Login
  static Future<Pr0grammLogin> getPr0grammLogin(
      {String username, String password}) async {
    Response response = await rrh.login(username, password);
    Map<String, dynamic> parsedJson = jsonDecode(response.body);
    return Pr0grammLogin.fromJson(parsedJson);
  }

  static setCookie(String cookies) {
    rrh.setCookie(cookies);
  }

  static Future<IsLoggedIn> isLoggedIn() async {
    Response response = await rrh.isLoggedIn();
    Map<String, dynamic> parsedJson = jsonDecode(response.body);
    return IsLoggedIn.fromJson(parsedJson);
  }

  static Future<CaptchaContainer> getCaptcha() async {
    Response response = await rrh.captcha();
    Map<String, dynamic> parsedJson = jsonDecode(response.body);
    return CaptchaContainer.fromJson(parsedJson);
  }
}
