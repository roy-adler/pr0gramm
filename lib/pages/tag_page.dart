import 'package:flutter/cupertino.dart';
import 'package:pr0gramm_app/api/response_parser.dart';
import 'package:pr0gramm_app/content/pr0gramm_comment.dart';
import 'package:pr0gramm_app/content/pr0gramm_content.dart';
import 'package:pr0gramm_app/content/pr0gramm_info.dart';
import 'package:pr0gramm_app/content/pr0gramm_tag.dart';
import 'package:pr0gramm_app/design/pr0_text.dart';
import 'package:pr0gramm_app/design/pr0gramm_colors.dart';
import 'package:pr0gramm_app/content/pr0gramm_content.dart';

class TagPage extends StatelessWidget {
  List<Pr0grammTag> tagList;

  TagPage({@required this.tagList});

  @override
  Widget build(BuildContext context) {
    return Wrap(children: tagList);
  }
}
