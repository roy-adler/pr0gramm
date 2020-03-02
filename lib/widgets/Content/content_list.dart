import 'package:pr0gramm/content/pr0gramm_content.dart';
import 'package:pr0gramm/api/response_parser.dart';

class ContentList {
  static int promoted = 1;
  static int sFW = 9;
  static int nSFW = 2;
  static int nSFL = 4;

  static Future<List<Pr0grammContent>> getSFWContentList({String search}) {
    return ResponseParser.getPr0grammContentList(promoted, sFW);
  }

  static Future<List<Pr0grammContent>> getNSFWContentList({String search}) {
    return ResponseParser.getPr0grammContentList(promoted, nSFW);
  }

  static Future<List<Pr0grammContent>> getNSFLContentList({String search}) {
    return ResponseParser.getPr0grammContentList(promoted, nSFL);
  }
}
