import 'package:flutter/cupertino.dart';
import 'package:pr0gramm/api/response_parser.dart';
import 'package:pr0gramm/content/pr0_comment.dart';
import 'package:pr0gramm/design/pr0gramm_colors.dart';

class CommentPage extends StatefulWidget {
  final int pr0grammContentID;

  CommentPage({@required this.pr0grammContentID});

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  _emptyList() {
    return Text(
      "Noch keine Kommentare vorhanden.",
      style: TextStyle(color: iRGENDWASDOOFESISTPASSIERTFarbe),
    );
  }

  List<ParCom> sortComments(List<Pr0Comment> commentList, id) {
    List<ParCom> parComList = [];
    List<Pr0Comment> children =
        commentList.where((element) => element.parent == id).toList();

    for (var i = 0; i < children.length; i++) {
      parComList.add(ParCom(
        comment: children[i],
        commentList: sortComments(commentList, children[i].id),
      ));
    }
    return parComList;
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ResponseParser.getCommentsOverID(widget.pr0grammContentID),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Pr0Comment> commentList = snapshot.data;
          if (commentList.isEmpty) {
            return _emptyList();
          }
          return Column(
            children: snapshot.data,
          );
        }
        return Container();
      },
    );
  }
}

class ParCom extends StatelessWidget {
  final Pr0Comment pr0grammComment;
  final List<Pr0Comment> pr0grammCommentList;

  ParCom({this.pr0grammComment, this.pr0grammCommentList});

  addComment(Pr0Comment pr0grammCommentChild) {
    pr0grammCommentList.add(pr0grammCommentChild);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
