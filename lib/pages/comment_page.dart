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
    List<ParCom> parComList = [];

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
