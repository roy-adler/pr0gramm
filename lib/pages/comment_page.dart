import 'package:flutter/cupertino.dart';
import 'package:pr0gramm_app/api/response_parser.dart';
import 'package:pr0gramm_app/content/pr0gramm_comment.dart';
import 'package:pr0gramm_app/content/pr0gramm_content.dart';
import 'package:pr0gramm_app/content/pr0gramm_info.dart';
import 'package:pr0gramm_app/content/pr0gramm_tag.dart';
import 'package:pr0gramm_app/design/pr0_text.dart';
import 'package:pr0gramm_app/design/pr0gramm_colors.dart';
import 'package:pr0gramm_app/content/pr0gramm_content.dart';

class CommentPage extends StatelessWidget {
  List<Pr0grammComment> commentList;

  CommentPage({@required this.commentList});

  _emptyList() {
    return Text(
      "Tja, bin eben leer",
      style: TextStyle(color: IRGENDWASDOOFESISTPASSIERTFarbe),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (commentList.isEmpty) {
      _emptyList();
    }
    List<int> toDelete = [];

    for (int index = 0; index < commentList.length; index++) {
      Pr0grammComment currentComment = commentList[index];
      if (currentComment.parent != 0) {
        var parentIndex = commentList
            .indexWhere((element) => element.id == currentComment.parent);
        if (parentIndex == -1) {
          print("FUCK?!");
        } else {
          commentList[parentIndex].children.add(currentComment);
          toDelete.add(currentComment.id);
        }
      }
    }

    // Delete Unwanted comments
    for (int index = 0; index < toDelete.length; index++) {
      int deleteIndex = commentList.indexWhere((element) =>
          element.id == toDelete[index] && element.children.isEmpty);
      if (deleteIndex != -1) {
        commentList.removeAt(deleteIndex);
      }
    }

    if (commentList.isEmpty) {
      _emptyList();
    }

    return Column(
      children: commentList,
    );
  }
}
