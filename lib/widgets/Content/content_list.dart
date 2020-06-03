import 'package:pr0gramm/content/pr0gramm_content.dart';
import 'package:pr0gramm/api/response_parser.dart';
import 'package:pr0gramm/global_variables.dart';

// TODO: Change Behaviour/ Datamodel
class ContentList {
  static int promoted = 1;

  static Future<List<Pr0grammContent>> getFilteredContentList(
      {int filter, String search}) {
    return ResponseParser.getPr0grammContentList(promoted, filter, tag: search);
  }

  static Future<List<Pr0grammContent>> getSFWContentList({String search}) {
    return ResponseParser.getPr0grammContentList(promoted, sfw, tag: search);
  }

  static Future<List<Pr0grammContent>> getNSFWContentList({String search}) {
    return ResponseParser.getPr0grammContentList(promoted, nsfw, tag: search);
  }

  static Future<List<Pr0grammContent>> getNSFLContentList({String search}) {
    return ResponseParser.getPr0grammContentList(promoted, nsfl, tag: search);
  }
}
