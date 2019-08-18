import 'package:flutter/cupertino.dart';
import 'package:pr0gramm_app/content/pr0gramm_comment.dart';
import 'package:pr0gramm_app/design/pr0gramm_colors.dart';

class CommentPage extends StatelessWidget {
  final List<Pr0grammComment> commentList;

  CommentPage({@required this.commentList});

  _emptyList() {
    print("LEEEr");
    return Text(
      "Noch keine Kommentare vorhanden.",
      style: TextStyle(color: iRGENDWASDOOFESISTPASSIERTFarbe),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (commentList.isEmpty) {
      return _emptyList();
    }
    List<int> toDelete = [];

    for (int index = 0; index < commentList.length; index++) {
      Pr0grammComment currentComment = commentList[index];
      if (currentComment.parent != 0) {
        // filter all comments with parents
        var parentIndex = commentList
            .indexWhere((element) => element.id == currentComment.parent);
        if (parentIndex == -1) {
          print("FUCK?!");
        } else {
          // add all comments with parents to toDelete
          toDelete.add(currentComment.id);
        }
      }
    }

    // Delete Unwanted comments
    for (int index = 0; index < toDelete.length; index++) {
      int deleteIndex = commentList.indexWhere(
          (element) => element.id == toDelete[index] && element.parent == 0);
      if (deleteIndex != -1) {
        commentList.removeAt(deleteIndex);
      }
    }

    if (commentList.isEmpty) {
      return _emptyList();
    }

    return Column(
      children: commentList,
    );
  }
}

class ParCom extends StatelessWidget {
  final Pr0grammComment pr0grammComment;
  final List<Pr0grammComment> pr0grammCommentList;

  ParCom({this.pr0grammComment, this.pr0grammCommentList});

  addComment(Pr0grammComment pr0grammCommentChild) {
    pr0grammCommentList.add(pr0grammCommentChild);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
